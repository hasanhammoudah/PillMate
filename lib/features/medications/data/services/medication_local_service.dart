import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/medication_model.dart';

class MedicationLocalService {
  static const _key = 'medications';

  Future<List<Medication>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => Medication.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<Medication> medications) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      medications.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }

  Future<void> add(Medication medication) async {
    final all = await getAll();
    all.add(medication);
    await _saveAll(all);
  }

  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((m) => m.id == id);
    await _saveAll(all);
  }
}
