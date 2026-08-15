import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../models/device.dart';
import '../models/scrcpy_config.dart';
import '../models/preset.dart';
import '../services/adb_service.dart';
import '../services/scrcpy_service.dart';
import '../services/config_service.dart';

class AppState extends ChangeNotifier {
  final AdbService adb = AdbService();
  final ScrcpyService scrcpy = ScrcpyService();
  final ConfigService configService = ConfigService();

  List<AndroidDevice> devices = [];
  String? selectedSerial;
  ScrcpyConfig config = ScrcpyConfig();
  String selectedPreset = 'default';
  List<String> recentIps = [];
  List<String> logs = [];

  bool isBinaryReady = false;
  String? scrcpyPath;
  String? adbPath;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    await _detectBinaries();
    await _loadConfig();
    await refreshDevices();
    scrcpy.logs.listen((log) {
      logs.add(log);
      notifyListeners();
    });
  }

  Future<void> _detectBinaries() async {
    // Check local project bin/ folder first
    final baseDir = Directory.current.path;
    final localBin = p.join(baseDir, 'bin');
    final localScrcpy = p.join(localBin, 'scrcpy.exe');
    final localAdb = p.join(localBin, 'adb.exe');

    // Also check sibling scrcpy-gui project bin folder
    final siblingScrcpy = p.join(Directory.current.parent.path, 'scrcpy-gui', 'bin', 'scrcpy.exe');
    final siblingAdb = p.join(Directory.current.parent.path, 'scrcpy-gui', 'bin', 'adb.exe');

    if (File(localScrcpy).existsSync() && File(localAdb).existsSync()) {
      scrcpyPath = localScrcpy;
      adbPath = localAdb;
    } else if (File(siblingScrcpy).existsSync() && File(siblingAdb).existsSync()) {
      scrcpyPath = siblingScrcpy;
      adbPath = siblingAdb;
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
    if (data.containsKey('config')) {
      config = ScrcpyConfig.fromJson(data['config']);
    }
    if (data.containsKey('recentIps')) {
      recentIps = List<String>.from(data['recentIps']);
    }
    if (data.containsKey('selectedPreset')) {
      selectedPreset = data['selectedPreset'];
    }
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await configService.save(
      config: config,
      recentIps: recentIps,
      selectedPreset: selectedPreset,
    );
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

  void applyPreset(Preset preset) {
    selectedPreset = preset.id;
    config = preset.config;
    saveSettings();
    notifyListeners();
  }

  Future<bool> launchScrcpy() async {
    if (!isBinaryReady) return false;
    final success = await scrcpy.start(
      config: config,
      serial: selectedSerial ?? '',
      onFinished: (_) => notifyListeners(),
    );
    notifyListeners();
    return success;
  }

  Future<void> stopScrcpy() async {
    await scrcpy.stop(selectedSerial);
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
}
