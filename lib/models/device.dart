class AndroidDevice {
  final String serial;
  final String state;
  final String model;
  final String product;
  final bool isWifi;

  AndroidDevice({
    required this.serial,
    required this.state,
    required this.model,
    required this.product,
    required this.isWifi,
  });

  String get displayName {
    String name = model.isNotEmpty ? model : serial;
    if (isWifi) {
      return '$name (Wi-Fi: $serial)';
    }
    return '$name ($serial)';
  }

  factory AndroidDevice.fromAdbLine(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    final serial = parts.isNotEmpty ? parts[0] : '';
    final state = parts.length > 1 ? parts[1] : 'unknown';

    String model = '';
    String product = '';

    for (var part in parts.skip(2)) {
      if (part.startsWith('model:')) {
        model = part.substring(6).replaceAll('_', ' ');
      } else if (part.startsWith('product:')) {
        product = part.substring(8);
      }
    }

    final isWifi = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d+$').hasMatch(serial);

    return AndroidDevice(
      serial: serial,
      state: state,
      model: model.isNotEmpty ? model : serial,
      product: product,
      isWifi: isWifi,
    );
  }
}
