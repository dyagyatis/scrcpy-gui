import 'dart:convert';
import 'dart:io';
import '../models/scrcpy_config.dart';

class ConfigService {
  final String _configFile;

  ConfigService([String? filePath])
      : _configFile = filePath ??
            Platform.environment['USERPROFILE'] != null
                ? '${Platform.environment['USERPROFILE']}/.scrcpy_flutter_config.json'
                : 'config.json';

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
  }) async {
    try {
      final file = File(_configFile);
      await file.parent.create(recursive: true);
      final data = {
        'config': config.toJson(),
        'recentIps': recentIps,
        'selectedPreset': selectedPreset,
      };
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    } catch (e) {
      print('Error saving config: $e');
    }
  }
}
