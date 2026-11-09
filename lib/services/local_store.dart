import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Device-only storage. Child nicknames are kept here and never leave the
/// device (approved proposal, Section 4.2).
class LocalStore {
  static const _childrenKey = 'smartkid_local_children';
  static const _currentKey = 'smartkid_current_child';

  static Future<List<ChildProfile>> children(String ownerId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_childrenKey);
    if (raw == null) return [];
    try {
      final list = (jsonDecode(raw) as List)
          .map(
            (e) => ChildProfile.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      // Only show children created by the signed-in account (shared devices).
      return list.where((c) => c.ownerId == ownerId).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addChild(ChildProfile child) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_childrenKey);
    final all = <dynamic>[];
    if (raw != null) {
      try {
        all.addAll(jsonDecode(raw) as List);
      } catch (_) {}
    }
    all.add(child.toJson());
    await prefs.setString(_childrenKey, jsonEncode(all));
    await prefs.setString(_currentKey, child.childId);
  }

  static Future<String?> currentChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentKey);
  }

  static Future<void> setCurrentChild(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentKey, childId);
  }

  static Future<void> clearCurrentChild() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentKey);
  }
}
