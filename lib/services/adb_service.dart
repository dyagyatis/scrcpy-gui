import 'dart:io';
import '../models/device.dart';

class AdbService {
  String adbPath;

  AdbService({this.adbPath = 'adb'});

  Future<ProcessResult> runAdb(List<String> args) async {
    try {
      return await Process.run(adbPath, args, runInShell: false);
    } catch (e) {
      return ProcessResult(0, -1, '', e.toString());
    }
  }

  Future<bool> isAvailable() async {
    final res = await runAdb(['version']);
    return res.exitCode == 0 && res.stdout.toString().contains('Android Debug Bridge');
  }

  Future<List<AndroidDevice>> getDevices() async {
    final res = await runAdb(['devices', '-l']);
    if (res.exitCode != 0) return [];

    final lines = res.stdout.toString().split('\n');
    List<AndroidDevice> devices = [];

    for (var line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final dev = AndroidDevice.fromAdbLine(line);
      if (dev.serial.isNotEmpty) {
        devices.add(dev);
      }
    }
    return devices;
  }

  Future<Map<String, dynamic>> connectWifi(String ipPort) async {
    final res = await runAdb(['connect', ipPort]);
    final out = (res.stdout.toString() + res.stderr.toString()).trim();
    final success = out.toLowerCase().contains('connected to') && !out.toLowerCase().contains('cannot');
    return {'success': success, 'message': out};
  }

  Future<Map<String, dynamic>> disconnectWifi(String ipPort) async {
    final res = await runAdb(['disconnect', ipPort]);
    return {'success': res.exitCode == 0, 'message': (res.stdout.toString() + res.stderr.toString()).trim()};
  }

  Future<Map<String, dynamic>> pairWifi(String ipPort, String code) async {
    final res = await runAdb(['pair', ipPort, code]);
    final out = (res.stdout.toString() + res.stderr.toString()).trim();
    final success = out.toLowerCase().contains('successfully paired');
    return {'success': success, 'message': out};
  }

  Future<Map<String, dynamic>> enableTcpIp(String serial, {int port = 5555}) async {
    List<String> args = [];
    if (serial.isNotEmpty) args.addAll(['-s', serial]);
    args.addAll(['tcpip', port.toString()]);
    final res = await runAdb(args);
    final out = (res.stdout.toString() + res.stderr.toString()).trim();
    return {'success': res.exitCode == 0, 'message': out};
  }

  Future<String?> getDeviceIp(String serial) async {
    final res = await runAdb(['-s', serial, 'shell', 'ip', 'route']);
    if (res.exitCode == 0) {
      final lines = res.stdout.toString().split('\n');
      for (var line in lines) {
        if (line.contains('src') && line.contains('wlan')) {
          final parts = line.trim().split(RegExp(r'\s+'));
          final idx = parts.indexOf('src');
          if (idx >= 0 && idx + 1 < parts.length) {
            return parts[idx + 1];
          }
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> installApk(String serial, String apkPath) async {
    List<String> args = [];
    if (serial.isNotEmpty) args.addAll(['-s', serial]);
    args.addAll(['install', '-r', apkPath]);
    final res = await runAdb(args);
    final out = (res.stdout.toString() + res.stderr.toString()).trim();
    final success = out.toLowerCase().contains('success');
    return {'success': success, 'message': out};
  }

  Future<Map<String, dynamic>> pushFile(String serial, String localPath, {String remoteDir = '/sdcard/Download/'}) async {
    List<String> args = [];
    if (serial.isNotEmpty) args.addAll(['-s', serial]);
    args.addAll(['push', localPath, remoteDir]);
    final res = await runAdb(args);
    return {'success': res.exitCode == 0, 'message': (res.stdout.toString() + res.stderr.toString()).trim()};
  }

  Future<Map<String, dynamic>> takeScreenshot(String serial, String savePath) async {
    try {
      final file = File(savePath);
      await file.parent.create(recursive: true);
      final process = await Process.start(adbPath, [
        if (serial.isNotEmpty) ...['-s', serial],
        'exec-out',
        'screencap',
        '-p'
      ]);
      final sink = file.openWrite();
      await process.stdout.pipe(sink);
      final exitCode = await process.exitCode;
      if (exitCode == 0 && await file.length() > 0) {
        return {'success': true, 'message': 'Скриншот сохранен: $savePath'};
      }
      return {'success': false, 'message': 'Не удалось сохранить снимок'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> sendKey(String serial, int keycode) async {
    await runAdb([
      if (serial.isNotEmpty) ...['-s', serial],
      'shell',
      'input',
      'keyevent',
      keycode.toString(),
    ]);
  }

  Future<void> reboot(String serial, {String mode = ''}) async {
    List<String> args = [];
    if (serial.isNotEmpty) args.addAll(['-s', serial]);
    args.add('reboot');
    if (mode.isNotEmpty) args.add(mode);
    await runAdb(args);
  }
}
