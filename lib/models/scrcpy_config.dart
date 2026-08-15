class ScrcpyConfig {
  // Video
  String maxSize; // 0 = original
  int bitRate; // Mbps
  String maxFps; // 0 = unlimited
  String videoCodec; // h264, h265, av1
  String orientation; // 0, 90, 180, 270
  int videoBuffer; // ms

  // Audio
  bool enableAudio;
  String audioCodec; // opus, aac, flac, raw
  int audioBitRate; // kbps
  int audioBuffer; // ms
  bool muteDeviceAudio;

  // Window & Geometry
  bool customWindowSize;
  int windowWidth;
  int windowHeight;
  bool customWindowPos;
  int windowX;
  int windowY;
  String windowTitle;
  bool alwaysOnTop;
  bool fullscreen;
  bool borderless;

  // Control & Device Behavior
  bool turnScreenOff;
  bool stayAwake;
  bool showTouches;
  bool noControl;
  bool powerOffOnClose;
  bool preferText;
  bool otgMode;

  // Recording
  bool recordEnabled;
  String recordFormat; // mp4, mkv
  String recordDirectory;
  String screenshotDirectory;

  ScrcpyConfig({
    this.maxSize = '0',
    this.bitRate = 8,
    this.maxFps = '0',
    this.videoCodec = 'h264',
    this.orientation = '0',
    this.videoBuffer = 0,
    this.enableAudio = true,
    this.audioCodec = 'opus',
    this.audioBitRate = 128,
    this.audioBuffer = 50,
    this.muteDeviceAudio = false,
    this.customWindowSize = false,
    this.windowWidth = 500,
    this.windowHeight = 1050,
    this.customWindowPos = false,
    this.windowX = 100,
    this.windowY = 100,
    this.windowTitle = '',
    this.alwaysOnTop = false,
    this.fullscreen = false,
    this.borderless = false,
    this.turnScreenOff = false,
    this.stayAwake = true,
    this.showTouches = false,
    this.noControl = false,
    this.powerOffOnClose = false,
    this.preferText = false,
    this.otgMode = false,
    this.recordEnabled = false,
    this.recordFormat = 'mp4',
    this.recordDirectory = '',
    this.screenshotDirectory = '',
  });

  List<String> buildArgs({String serial = '', String recordFile = ''}) {
    List<String> args = [];

    if (serial.isNotEmpty) {
      args.addAll(['-s', serial]);
    }

    if (otgMode) {
      args.add('--otg');
      return args;
    }

    // Video
    if (maxSize != '0' && maxSize.isNotEmpty) {
      args.addAll(['--max-size', maxSize]);
    }
    if (bitRate > 0) {
      args.addAll(['--video-bit-rate', '${bitRate}M']);
    }
    if (maxFps != '0' && maxFps.isNotEmpty) {
      args.addAll(['--max-fps', maxFps]);
    }
    if (videoCodec.isNotEmpty) {
      args.addAll(['--video-codec', videoCodec]);
    }
    if (orientation != '0' && orientation.isNotEmpty) {
      args.addAll(['--lock-video-orientation', orientation]);
    }
    if (videoBuffer > 0) {
      args.addAll(['--video-buffer', videoBuffer.toString()]);
    }

    // Audio
    if (!enableAudio) {
      args.add('--no-audio');
    } else {
      if (audioCodec.isNotEmpty) {
        args.addAll(['--audio-codec', audioCodec]);
      }
      if (audioBitRate > 0) {
        args.addAll(['--audio-bit-rate', '${audioBitRate}K']);
      }
      if (audioBuffer > 0) {
        args.addAll(['--audio-buffer', audioBuffer.toString()]);
      }
      if (muteDeviceAudio) {
        args.add('--no-audio-playback');
      }
    }

    // Window Geometry
    if (customWindowSize) {
      if (windowWidth > 0) args.addAll(['--window-width', windowWidth.toString()]);
      if (windowHeight > 0) args.addAll(['--window-height', windowHeight.toString()]);
    }
    if (customWindowPos) {
      args.addAll(['--window-x', windowX.toString()]);
      args.addAll(['--window-y', windowY.toString()]);
    }
    if (windowTitle.trim().isNotEmpty) {
      args.addAll(['--window-title', windowTitle.trim()]);
    }

    // Window flags
    if (alwaysOnTop) args.add('--always-on-top');
    if (fullscreen) args.add('--fullscreen');
    if (borderless) args.add('--window-borderless');

    // Controls
    if (turnScreenOff) args.add('--turn-screen-off');
    if (stayAwake) args.add('--stay-awake');
    if (showTouches) args.add('--show-touches');
    if (noControl) args.add('--no-control');
    if (powerOffOnClose) args.add('--power-off-on-close');
    if (preferText) args.add('--prefer-text');

    // Record
    if (recordFile.isNotEmpty) {
      args.addAll(['--record', recordFile]);
    }

    return args;
  }

  Map<String, dynamic> toJson() => {
    'maxSize': maxSize,
    'bitRate': bitRate,
    'maxFps': maxFps,
    'videoCodec': videoCodec,
    'orientation': orientation,
    'videoBuffer': videoBuffer,
    'enableAudio': enableAudio,
    'audioCodec': audioCodec,
    'audioBitRate': audioBitRate,
    'audioBuffer': audioBuffer,
    'muteDeviceAudio': muteDeviceAudio,
    'customWindowSize': customWindowSize,
    'windowWidth': windowWidth,
    'windowHeight': windowHeight,
    'customWindowPos': customWindowPos,
    'windowX': windowX,
    'windowY': windowY,
    'windowTitle': windowTitle,
    'alwaysOnTop': alwaysOnTop,
    'fullscreen': fullscreen,
    'borderless': borderless,
    'turnScreenOff': turnScreenOff,
    'stayAwake': stayAwake,
    'showTouches': showTouches,
    'noControl': noControl,
    'powerOffOnClose': powerOffOnClose,
    'preferText': preferText,
    'otgMode': otgMode,
    'recordEnabled': recordEnabled,
    'recordFormat': recordFormat,
    'recordDirectory': recordDirectory,
    'screenshotDirectory': screenshotDirectory,
  };

  factory ScrcpyConfig.fromJson(Map<String, dynamic> json) => ScrcpyConfig(
    maxSize: json['maxSize'] ?? '0',
    bitRate: json['bitRate'] ?? 8,
    maxFps: json['maxFps'] ?? '0',
    videoCodec: json['videoCodec'] ?? 'h264',
    orientation: json['orientation'] ?? '0',
    videoBuffer: json['videoBuffer'] ?? 0,
    enableAudio: json['enableAudio'] ?? true,
    audioCodec: json['audioCodec'] ?? 'opus',
    audioBitRate: json['audioBitRate'] ?? 128,
    audioBuffer: json['audioBuffer'] ?? 50,
    muteDeviceAudio: json['muteDeviceAudio'] ?? false,
    customWindowSize: json['customWindowSize'] ?? false,
    windowWidth: json['windowWidth'] ?? 500,
    windowHeight: json['windowHeight'] ?? 1050,
    customWindowPos: json['customWindowPos'] ?? false,
    windowX: json['windowX'] ?? 100,
    windowY: json['windowY'] ?? 100,
    windowTitle: json['windowTitle'] ?? '',
    alwaysOnTop: json['alwaysOnTop'] ?? false,
    fullscreen: json['fullscreen'] ?? false,
    borderless: json['borderless'] ?? false,
    turnScreenOff: json['turnScreenOff'] ?? false,
    stayAwake: json['stayAwake'] ?? true,
    showTouches: json['showTouches'] ?? false,
    noControl: json['noControl'] ?? false,
    powerOffOnClose: json['powerOffOnClose'] ?? false,
    preferText: json['preferText'] ?? false,
    otgMode: json['otgMode'] ?? false,
    recordEnabled: json['recordEnabled'] ?? false,
    recordFormat: json['recordFormat'] ?? 'mp4',
    recordDirectory: json['recordDirectory'] ?? '',
    screenshotDirectory: json['screenshotDirectory'] ?? '',
  );
}
