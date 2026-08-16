import 'dart:convert';
import 'dart:io';
import '../models/scrcpy_config.dart';
import '../models/preset.dart';

class ConfigService {
  final String _configFile;

  ConfigService([String? filePath])
      : _configFile = filePath ?? _getDefaultConfigPath();

  String get configFile => _configFile;

  static String _getDefaultConfigPath() {
    final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) {
      return '$home/.scrcpy_flutter_config.json';
    }
    return 'config.json';
  }

  Future<Map<String, dynamic>> load() async {
    try {
      final file = File(_configFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        return json.decode(content);
      }
    } catch (e) {
      print('Error loading config: $e');
    }
    return {};
  }

  Future<void> save({
    required ScrcpyConfig config,
    required List<String> recentIps,
    required String selectedPreset,
    List<Preset> customPresets = const [],
  }) async {
    try {
      final file = File(_configFile);
      await file.parent.create(recursive: true);
      final data = {
        'config': config.toJson(),
        'recentIps': recentIps,
        'selectedPreset': selectedPreset,
        'customPresets': customPresets.map((p) => p.toJson()).toList(),
      };
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    } catch (e) {
      print('Error saving config: $e');
    }
  }
}
