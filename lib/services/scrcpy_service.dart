import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/scrcpy_config.dart';

class ScrcpySession {
  final String id;
  final String serial;
  final Process process;
  final DateTime startTime;
  final String command;

  ScrcpySession({
    required this.id,
    required this.serial,
    required this.process,
    required this.startTime,
    required this.command,
  });
}

class ScrcpyService {
  String scrcpyPath;
  final Map<String, ScrcpySession> _activeSessions = {};
  final StreamController<String> _logController = StreamController<String>.broadcast();

  ScrcpyService({this.scrcpyPath = 'scrcpy'});

  Stream<String> get logs => _logController.stream;
  List<ScrcpySession> get activeSessions => _activeSessions.values.toList();
  bool isSessionRunning(String serial) => _activeSessions.containsKey(serial);

  Future<bool> start({
    required ScrcpyConfig config,
    String serial = '',
    String recordFile = '',
    Function(int exitCode)? onFinished,
  }) async {
    final key = serial.isNotEmpty ? serial : 'default';
    if (_activeSessions.containsKey(key)) {
      await stop(key);
    }

    final args = config.buildArgs(serial: serial, recordFile: recordFile);
    final cmdStr = '$scrcpyPath ${args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ')}';

    _logController.add('[GUI] Запуск: $cmdStr');

    try {
      final workingDir = File(scrcpyPath).parent.path;
      final process = await Process.start(
        scrcpyPath,
        args,
        workingDirectory: Directory(workingDir).existsSync() ? workingDir : null,
      );

      final session = ScrcpySession(
        id: key,
        serial: serial,
        process: process,
        startTime: DateTime.now(),
        command: cmdStr,
      );
      _activeSessions[key] = session;

      process.stdout.transform(utf8.decoder).listen((data) {
        for (var line in data.split('\n')) {
          if (line.trim().isNotEmpty) {
            _logController.add('[scrcpy] $line');
          }
        }
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        for (var line in data.split('\n')) {
          if (line.trim().isNotEmpty) {
            _logController.add('[scrcpy err] $line');
          }
        }
      });

      process.exitCode.then((code) {
        _activeSessions.remove(key);
        _logController.add('[GUI] Процесс scrcpy ($key) завершен с кодом: $code');
        if (onFinished != null) onFinished(code);
      });

      return true;
    } catch (e) {
      _logController.add('[GUI ERROR] Ошибка запуска scrcpy: $e');
      return false;
    }
  }

  Future<void> stop([String? serial]) async {
    if (serial != null) {
      final session = _activeSessions[serial];
      if (session != null) {
        _logController.add('[GUI] Остановка процесса для $serial...');
        session.process.kill();
        _activeSessions.remove(serial);
      }
    } else {
      for (var session in _activeSessions.values) {
        session.process.kill();
      }
      _activeSessions.clear();
    }
  }

  void dispose() {
    stop();
    _logController.close();
  }
}
