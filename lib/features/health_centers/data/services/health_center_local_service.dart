import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/health_center_model.dart';

class HealthCenterLocalService {
  static const _key = 'health_centers';

  Future<List<HealthCenter>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => HealthCenter.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<HealthCenter> centers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      centers.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }

  Future<void> add(HealthCenter center) async {
    final all = await getAll();
    all.add(center);
    await _saveAll(all);
  }

  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((c) => c.id == id);
    await _saveAll(all);
  }
}
