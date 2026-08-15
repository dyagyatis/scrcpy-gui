import 'scrcpy_config.dart';

class Preset {
  final String id;
  final String name;
  final String description;
  final String icon;
  final ScrcpyConfig config;
  final bool isCustom;

  Preset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.config,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'config': config.toJson(),
    'isCustom': isCustom,
  };

  factory Preset.fromJson(Map<String, dynamic> json) => Preset(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    icon: json['icon'] ?? '⭐',
    config: ScrcpyConfig.fromJson(json['config'] ?? {}),
    isCustom: json['isCustom'] ?? true,
  );

  static List<Preset> get defaultPresets => [
    Preset(
      id: 'default',
      name: 'Стандарт',
      description: 'Сбалансированное качество (8 Мбит/с, H.264)',
      icon: '⚡',
      config: ScrcpyConfig(
        maxSize: '0',
        bitRate: 8,
        maxFps: '0',
        videoCodec: 'h264',
        enableAudio: true,
        turnScreenOff: false,
        stayAwake: true,
        showTouches: false,
      ),
    ),
    Preset(
      id: 'gaming',
      name: 'Игровой',
      description: '120 FPS, 1080p, минимальный буфер',
      icon: '🎮',
      config: ScrcpyConfig(
        maxSize: '1080',
        bitRate: 16,
        maxFps: '120',
        videoCodec: 'h264',
        videoBuffer: 0,
        audioBuffer: 20,
        enableAudio: true,
        turnScreenOff: false,
        stayAwake: true,
        showTouches: false,
      ),
    ),
    Preset(
      id: 'webcam',
      name: 'Веб-камера (Webcam)',
      description: 'Использовать камеру телефона как вебку ПК (1080p, 60fps)',
      icon: '📷',
      config: ScrcpyConfig(
        videoSource: 'camera',
        cameraFacing: 'back',
        cameraSize: '1920x1080',
        cameraFps: '60',
        bitRate: 16,
        enableAudio: true,
      ),
    ),
    Preset(
      id: 'max_quality',
      name: 'Макс. качество',
      description: 'Исходное разрешение, 24 Мбит/с, H.265 / HEVC',
      icon: '🌟',
      config: ScrcpyConfig(
        maxSize: '0',
        bitRate: 24,
        maxFps: '0',
        videoCodec: 'h265',
        enableAudio: true,
        turnScreenOff: false,
        stayAwake: true,
        showTouches: false,
      ),
    ),
    Preset(
      id: 'eco',
      name: 'Эко',
      description: 'Экономичный режим: 720p, 4 Мбит/с, 30 FPS',
      icon: '🔋',
      config: ScrcpyConfig(
        maxSize: '720',
        bitRate: 4,
        maxFps: '30',
        videoCodec: 'h264',
        enableAudio: true,
        turnScreenOff: false,
        stayAwake: true,
        showTouches: false,
      ),
    ),
    Preset(
      id: 'stealth',
      name: 'Скрытый экран',
      description: 'Экран телефона выключен, управление с ПК',
      icon: '🕶',
      config: ScrcpyConfig(
        maxSize: '0',
        bitRate: 12,
        maxFps: '0',
        videoCodec: 'h264',
        enableAudio: true,
        turnScreenOff: true,
        stayAwake: true,
        showTouches: true,
      ),
    ),
  ];
}
