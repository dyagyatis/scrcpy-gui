import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../models/device.dart';
import '../models/scrcpy_config.dart';
import '../models/preset.dart';
import '../services/adb_service.dart';
import '../services/scrcpy_service.dart';
import '../services/config_service.dart';
import '../services/update_service.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
  final AdbService adb = AdbService();
  final ScrcpyService scrcpy = ScrcpyService();
  final ConfigService configService = ConfigService();
  final UpdateService updater = UpdateService();

  String language = 'ru'; // 'ru' or 'en'
  AppAccentColor activeAccent = AppAccentColor.purple;
  bool isOledMode = false;

  List<AndroidDevice> devices = [];
  String? selectedSerial;
  ScrcpyConfig config = ScrcpyConfig();
  String selectedPreset = 'default';
  List<Preset> userPresets = [];
  List<String> recentIps = [];
  List<String> logs = [];

  // Scrcpy Versions
  List<String> availableScrcpyVersions = ['v4.1', 'v4.0', 'v3.3.4', 'v3.1', 'v2.7', 'v2.4'];
  String selectedScrcpyVersion = 'v4.1';
  bool isFetchingVersions = false;

  bool isBinaryReady = false;
  bool isDownloading = false;
  String downloadStatus = '';
  String? scrcpyPath;
  String? adbPath;

  AppState() {
    _init();
  }

  ThemeData get theme => AppTheme.createTheme(accent: activeAccent, isOled: isOledMode);

  String tr(String key) => I18n.t(key, language);

  Future<void> _init() async {
    await _detectBinaries();
    await _loadConfig();
    await refreshDevices();
    fetchAvailableScrcpyVersions();
    scrcpy.logs.listen((log) {
      logs.add(log);
      notifyListeners();
    });
  }

  Future<void> _detectBinaries() async {
    final baseDir = Directory.current.path;
    final localBin = p.join(baseDir, 'bin');
    final localScrcpy = p.join(localBin, Platform.isWindows ? 'scrcpy.exe' : 'scrcpy');
    final localAdb = p.join(localBin, Platform.isWindows ? 'adb.exe' : 'adb');

    if (File(localScrcpy).existsSync() && File(localAdb).existsSync()) {
      scrcpyPath = localScrcpy;
      adbPath = localAdb;
    } else {
      scrcpyPath = 'scrcpy';
      adbPath = 'adb';
    }

    adb.adbPath = adbPath!;
    scrcpy.scrcpyPath = scrcpyPath!;

    isBinaryReady = await adb.isAvailable();
    notifyListeners();
  }

  Future<void> _loadConfig() async {
    final data = await configService.load();
    if (data.containsKey('language')) {
      language = data['language'];
    }
    if (data.containsKey('accent')) {
      final accStr = data['accent'] as String;
      activeAccent = AppAccentColor.values.firstWhere(
        (a) => a.name == accStr,
        orElse: () => AppAccentColor.purple,
      );
    }
    if (data.containsKey('isOledMode')) {
      isOledMode = data['isOledMode'] ?? false;
    }
    if (data.containsKey('selectedScrcpyVersion')) {
      selectedScrcpyVersion = data['selectedScrcpyVersion'];
    }
    if (data.containsKey('config')) {
      config = ScrcpyConfig.fromJson(data['config']);
    }
    if (data.containsKey('recentIps')) {
      recentIps = List<String>.from(data['recentIps']);
    }
    if (data.containsKey('selectedPreset')) {
      selectedPreset = data['selectedPreset'];
    }
    if (data.containsKey('customPresets')) {
      userPresets = (data['customPresets'] as List)
          .map((item) => Preset.fromJson(item))
          .toList();
    }
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    language = lang;
    await saveSettings();
    notifyListeners();
  }

  Future<void> setAccent(AppAccentColor accent) async {
    activeAccent = accent;
    await saveSettings();
    notifyListeners();
  }

  Future<void> setOledMode(bool oled) async {
    isOledMode = oled;
    await saveSettings();
    notifyListeners();
  }

  void setSelectedScrcpyVersion(String ver) {
    selectedScrcpyVersion = ver;
    saveSettings();
    notifyListeners();
  }

  Future<void> fetchAvailableScrcpyVersions() async {
    isFetchingVersions = true;
    notifyListeners();
    try {
      final client = HttpClient();
      client.userAgent = 'Scrcpy-GUI-Flutter';
      final uri = Uri.parse('https://api.github.com/repos/Genymobile/scrcpy/releases');
      final req = await client.getUrl(uri);
      final resp = await req.close();

      if (resp.statusCode == 200) {
        final bodyStr = await resp.transform(utf8.decoder).join();
        final list = jsonDecode(bodyStr) as List;
        final tags = list
            .map((item) => item['tag_name']?.toString() ?? '')
            .where((t) => t.isNotEmpty && t.startsWith('v'))
            .toList();

        if (tags.isNotEmpty) {
          availableScrcpyVersions = tags;
          if (!availableScrcpyVersions.contains(selectedScrcpyVersion)) {
            selectedScrcpyVersion = availableScrcpyVersions.first;
          }
        }
      }
    } catch (_) {}
    isFetchingVersions = false;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    try {
      final file = File(configService.configFile);
      await file.parent.create(recursive: true);
      final data = {
        'language': language,
        'accent': activeAccent.name,
        'isOledMode': isOledMode,
        'selectedScrcpyVersion': selectedScrcpyVersion,
        'config': config.toJson(),
        'recentIps': recentIps,
        'selectedPreset': selectedPreset,
        'customPresets': userPresets.map((p) => p.toJson()).toList(),
      };
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    } catch (_) {}
    notifyListeners();
  }

  Future<void> refreshDevices() async {
    devices = await adb.getDevices();
    if (devices.isNotEmpty) {
      if (selectedSerial == null || !devices.any((d) => d.serial == selectedSerial)) {
        selectedSerial = devices.first.serial;
      }
    } else {
      selectedSerial = null;
    }
    notifyListeners();
  }

  void selectDevice(String serial) {
    selectedSerial = serial;
    notifyListeners();
  }

  AndroidDevice? get currentDevice =>
      devices.where((d) => d.serial == selectedSerial).firstOrNull;

  void applyPreset(Preset preset) {
    selectedPreset = preset.id;
    config = ScrcpyConfig.fromJson(preset.config.toJson());
    saveSettings();
    notifyListeners();
  }

  void addCustomPreset({required String name, required String description, required String icon}) {
    final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final custom = Preset(
      id: newId,
      name: name,
      description: description,
      icon: icon,
      config: ScrcpyConfig.fromJson(config.toJson()),
      isCustom: true,
    );
    userPresets.add(custom);
    selectedPreset = newId;
    saveSettings();
    notifyListeners();
  }

  void deleteCustomPreset(String id) {
    userPresets.removeWhere((p) => p.id == id);
    if (selectedPreset == id) selectedPreset = 'default';
    saveSettings();
    notifyListeners();
  }

  Future<bool> launchScrcpy([String? serial]) async {
    if (!isBinaryReady) return false;
    final targetSerial = serial ?? selectedSerial ?? '';
    final success = await scrcpy.start(
      config: config,
      serial: targetSerial,
      onFinished: (_) => notifyListeners(),
    );
    notifyListeners();
    return success;
  }

  Future<void> launchAllDevices() async {
    for (var dev in devices) {
      if (dev.state == 'device') {
        await scrcpy.start(config: config, serial: dev.serial, onFinished: (_) => notifyListeners());
      }
    }
    notifyListeners();
  }

  Future<void> stopScrcpy([String? serial]) async {
    await scrcpy.stop(serial ?? selectedSerial);
    notifyListeners();
  }

  bool isCurrentDeviceRunning() {
    return scrcpy.isSessionRunning(selectedSerial ?? 'default');
  }

  String get commandPreview {
    final args = config.buildArgs(serial: selectedSerial ?? '');
    return '${p.basename(scrcpyPath ?? "scrcpy")} ${args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ')}';
  }

  void clearLogs() {
    logs.clear();
    notifyListeners();
  }

  void addRecentIp(String ip) {
    if (recentIps.contains(ip)) {
      recentIps.remove(ip);
    }
    recentIps.insert(0, ip);
    if (recentIps.length > 10) {
      recentIps = recentIps.sublist(0, 10);
    }
    saveSettings();
  }

  Future<bool> downloadScrcpyBinaries({String? version}) async {
    final ver = version ?? selectedScrcpyVersion;
    isDownloading = true;
    downloadStatus = 'Downloading Scrcpy $ver archive...';
    notifyListeners();

    try {
      final binDir = Directory(p.join(Directory.current.path, 'bin'));
      await binDir.create(recursive: true);

      if (Platform.isWindows) {
        final url = 'https://github.com/Genymobile/scrcpy/releases/download/$ver/scrcpy-win64-$ver.zip';
        final zipPath = p.join(binDir.path, 'scrcpy_temp.zip');
        
        final client = HttpClient();
        final req = await client.getUrl(Uri.parse(url));
        final resp = await req.close();
        
        if (resp.statusCode != 200) {
          isDownloading = false;
          downloadStatus = '❌ Release $ver not found or download failed (HTTP ${resp.statusCode})';
          notifyListeners();
          return false;
        }

        final sink = File(zipPath).openWrite();
        await resp.pipe(sink);

        downloadStatus = 'Extracting Scrcpy $ver binaries...';
        notifyListeners();

        final psScript = 'Expand-Archive -Path "$zipPath" -DestinationPath "${binDir.path}\\temp_scrcpy" -Force; '
            r'Get-ChildItem -Path "' + binDir.path + r'\temp_scrcpy" -Directory | ForEach-Object { Copy-Item -Path "$($_.FullName)\*" -Destination "' + binDir.path + r'" -Recurse -Force }; '
            'Remove-Item -Path "$zipPath", "${binDir.path}\\temp_scrcpy" -Recurse -Force';
        await Process.run('powershell', ['-Command', psScript]);
      } else {
        downloadStatus = 'Please install version $ver via brew or package manager.';
      }

      await _detectBinaries();
      isDownloading = false;
      downloadStatus = isBinaryReady ? '✅ Scrcpy $ver installed successfully!' : '❌ Failed to configure binaries.';
      notifyListeners();
      return isBinaryReady;
    } catch (e) {
      isDownloading = false;
      downloadStatus = 'Error downloading $ver: $e';
      notifyListeners();
      return false;
    }
  }
}
