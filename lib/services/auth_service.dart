
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';

/// Firebase Authentication and Firestore user profiles.
///
/// Self-service registration creates parent accounts only.
/// Teacher and researcher roles are assigned by the research team.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Watches authentication and the corresponding Firestore user profile.
  ///
  /// The profile document is watched directly so registration does not fail
  /// just because the profile has not been created yet.
  Stream<UserProfile?> profileChanges() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) {
        return Stream<UserProfile?>.value(null);
      }

      return _db
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snap) {
            if (!snap.exists) {
              throw StateError(
                'Your user profile could not be found. '
                'Please contact the research team.',
              );
            }

            final data = snap.data();
            final roleValue = data?['role'];

            const validRoles = ['parent', 'teacher', 'researcher'];

            if (roleValue is! String ||
                !validRoles.contains(roleValue)) {
              throw StateError(
                'Your user role is invalid. '
                'Please contact the research team.',
              );
            }

            return UserProfile(
              id: user.uid,
              email: user.email ?? '',
              role: userRoleFromString(roleValue),
            );
          });
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Creates a Firebase Authentication account and a parent profile.
  Future<void> signUp(String email, String password) async {
    final cleanEmail = email.trim();

    final cred = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    try {
      await _db.collection('users').doc(cred.user!.uid).set({
        'email': cleanEmail,
        'role': 'parent',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Avoid leaving the user signed in without a Firestore profile.
      try {
        await cred.user!.delete();
      } catch (_) {
        await _auth.signOut();
      }
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();

  static String friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'That email is already registered. Try signing in instead.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'network-request-failed':
          return 'No internet connection. Please check your network and try again.';
      }
    }

    if (e is FirebaseException) {
      if (e.code == 'permission-denied') {
        return 'You do not have permission to access your account profile.';
      }
      if (e.code == 'unavailable') {
        return 'No internet connection. Please check your network and try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
