import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';

/// Same layout the web prototype already uses, so both clients share one dataset:
///   sessions/{sessionId}                    session summary
///   sessions/{sessionId}/responses/{autoId} one FR1.3 record per tap
///
/// Offline behaviour (FR4.4): on Android and iOS, Cloud Firestore keeps a local
/// cache and queues writes while the device is offline, then syncs them when the
/// connection returns. For that reason writes below are NOT awaited in the
/// play screen: an awaited write would hang until the server acknowledges it.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _write(Future<dynamic> pending) async {
    try {
      await pending;
    } catch (e) {
      debugPrint('Firestore write failed: $e');
    }
  }

  void saveResponse(AssessmentResponse r) {
    _write(
      _db
          .collection('sessions')
          .doc(r.sessionId)
          .collection('responses')
          .add(r.toFirestore()),
    );
  }

  void saveSession(AssessmentSession s) {
    _write(
      _db.collection('sessions').doc(s.sessionId).set({
        'childId': s.childId,
        'ownerId': s.ownerId,
        'ageBand': s.ageBand.key,
        'completedActivities': s.completedActivities.map((a) => a.key).toList(),
        'startTime': s.startTime.toIso8601String(),
        'endTime': s.endTime?.toIso8601String(),
        'isComplete': s.isComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    );
  }

  /// Parents only see sessions they created (query must match the security
  /// rules); teachers and researchers see all sessions.
  Future<List<Map<String, dynamic>>> fetchSessions(UserProfile user) async {
    final col = _db.collection('sessions');
    final snap = user.role == UserRole.parent
        ? await col.where('ownerId', isEqualTo: user.id).get()
        : await col.get();
    return snap.docs.map((d) => {'sessionId': d.id, ...d.data()}).toList();
  }

  Future<List<AssessmentResponse>> fetchResponses(String sessionId) async {
    final snap = await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('responses')
        .get();
    return snap.docs
        .map((d) => AssessmentResponse.fromFirestore(d.data()))
        .toList();
  }
}
