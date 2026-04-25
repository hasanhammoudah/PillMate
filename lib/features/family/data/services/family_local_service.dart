import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/family_member_model.dart';

class FamilyLocalService {
  static const _key = 'family_members';

  Future<List<FamilyMember>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => FamilyMember.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<FamilyMember> members) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      members.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }

  Future<void> add(FamilyMember member) async {
    final all = await getAll();
    all.add(member);
    await _saveAll(all);
  }

  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((m) => m.id == id);
    await _saveAll(all);
  }
}
