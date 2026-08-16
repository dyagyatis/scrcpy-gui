import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class MonitorTab extends StatefulWidget {
  const MonitorTab({super.key});

  @override
  State<MonitorTab> createState() => _MonitorTabState();
}

class _MonitorTabState extends State<MonitorTab> {
  Timer? _timer;
  double _cpuPercent = 24.0;
  int _ramUsedMb = 3450;
  int _ramTotalMb = 7800;
  double _batteryTemp = 32.5;
  int _batteryVoltage = 4120; // mV
  String _thermalStatus = 'Normal';

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchStats());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    final state = context.read<AppState>();
    if (state.selectedSerial == null) return;

    try {
      // 1. Battery & Thermal
      final bat = await state.adb.runAdb([
        if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
        'shell',
        'dumpsys',
        'battery',
      ]);
      if (bat.exitCode == 0) {
        final lines = bat.stdout.toString().split('\n');
        for (var line in lines) {
          final t = line.trim();
          if (t.startsWith('temperature:')) {
            final raw = int.tryParse(t.split(':').last.trim()) ?? 320;
            _batteryTemp = raw / 10.0;
          } else if (t.startsWith('voltage:')) {
            _batteryVoltage = int.tryParse(t.split(':').last.trim()) ?? 4000;
          }
        }
      }

      // 2. RAM Info
      final mem = await state.adb.runAdb([
        if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
        'shell',
        'cat',
        '/proc/meminfo',
      ]);
      if (mem.exitCode == 0) {
        final lines = mem.stdout.toString().split('\n');
        int totalKb = 0;
        int freeKb = 0;
        for (var line in lines) {
          if (line.startsWith('MemTotal:')) {
            totalKb = int.tryParse(RegExp(r'\d+').firstMatch(line)?.group(0) ?? '') ?? 0;
          } else if (line.startsWith('MemAvailable:')) {
            freeKb = int.tryParse(RegExp(r'\d+').firstMatch(line)?.group(0) ?? '') ?? 0;
          }
        }
        if (totalKb > 0) {
          _ramTotalMb = totalKb ~/ 1024;
          _ramUsedMb = (totalKb - freeKb) ~/ 1024;
        }
      }

      // 3. CPU Load estimate
      final cpu = await state.adb.runAdb([
        if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
        'shell',
        'dumpsys',
        'cpuinfo',
      ]);
      if (cpu.exitCode == 0) {
        final match = RegExp(r'(\d+)%\s+TOTAL').firstMatch(cpu.stdout.toString());
        if (match != null) {
          _cpuPercent = double.tryParse(match.group(1) ?? '25') ?? 25.0;
        }
      }

      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ramPercent = (_ramUsedMb / (_ramTotalMb > 0 ? _ramTotalMb : 1) * 100).clamp(0, 100);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: AppTheme.greenAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                state.tr('performance_monitor'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.greenAccent),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, color: AppTheme.greenAccent, size: 8),
                    SizedBox(width: 6),
                    Text('Live Polling (3s)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.greenAccent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Real-time hardware telemetry and thermals during screen mirroring.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // 4 Metric Gauge Cards
          Row(
            children: [
              _buildMetricCard(
                title: 'CPU Usage',
                value: '${_cpuPercent.toStringAsFixed(1)}%',
                progress: (_cpuPercent / 100).clamp(0.0, 1.0),
                color: _cpuPercent > 70 ? AppTheme.redAccent : AppTheme.purpleAccent,
                icon: Icons.memory_rounded,
                subtitle: 'Process & System Load',
              ),
              const SizedBox(width: 14),
              _buildMetricCard(
                title: 'RAM Consumption',
                value: '${ramPercent.toStringAsFixed(0)}%',
                progress: (ramPercent / 100).clamp(0.0, 1.0),
                color: ramPercent > 80 ? AppTheme.redAccent : AppTheme.cyanAccent,
                icon: Icons.developer_board_rounded,
                subtitle: '$_ramUsedMb MB / $_ramTotalMb MB',
              ),
              const SizedBox(width: 14),
              _buildMetricCard(
                title: 'Battery Temp',
                value: '${_batteryTemp.toStringAsFixed(1)} °C',
                progress: ((_batteryTemp - 20) / 40).clamp(0.0, 1.0),
                color: _batteryTemp > 42 ? AppTheme.redAccent : AppTheme.yellowAccent,
                icon: Icons.thermostat_rounded,
                subtitle: 'Health: $_thermalStatus • ${_batteryVoltage}mV',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Device Specifications Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📱 Connected Device Specifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildInfoTile('Device Model', state.currentDevice?.model ?? 'Not connected'),
                    _buildInfoTile('Serial / IP', state.currentDevice?.serial ?? 'None'),
                    _buildInfoTile('OS Version', state.currentDevice?.androidVersion ?? 'Android'),
                    _buildInfoTile('Screen Resolution', state.currentDevice?.resolution ?? 'Auto'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.bgInput,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
