import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'widgets/header_bar.dart';
import 'widgets/preset_selector.dart';
import 'widgets/device_card.dart';
import 'widgets/video_settings_view.dart';
import 'widgets/audio_settings_view.dart';
import 'widgets/control_settings_view.dart';
import 'widgets/record_settings_view.dart';
import 'widgets/tools_view.dart';
import 'widgets/log_console_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isRunning = state.isCurrentDeviceRunning();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header
            const HeaderBar(),
            const SizedBox(height: 12),
            const Divider(color: AppTheme.borderColor),
            const SizedBox(height: 8),

            // 2. Presets Toolbar
            const PresetSelector(),
            const SizedBox(height: 10),

            // 3. Device Selector Card
            const DeviceCard(),
            const SizedBox(height: 10),

            // 4. Settings Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Text('📺'), text: 'Видео'),
                Tab(icon: Text('🔊'), text: 'Аудио'),
                Tab(icon: Text('🎮'), text: 'Управление'),
                Tab(icon: Text('🎥'), text: 'Запись'),
                Tab(icon: Text('🛠'), text: 'Инструменты'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    VideoSettingsView(),
                    AudioSettingsView(),
                    ControlSettingsView(),
                    RecordSettingsView(),
                    ToolsView(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 5. Bottom Launch & Action Bar
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: isRunning ? AppTheme.successColor : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRunning ? '🟢 Трансляция активна...' : '⚪ Готов к запуску',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isRunning ? AppTheme.successColor : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isRunning) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dangerColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.stop, size: 18),
                    label: const Text('Остановить', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => state.stopScrcpy(),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.rocket_launch, size: 18),
                  label: const Text('Запустить Scrcpy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  onPressed: isRunning ? null : () => state.launchScrcpy(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 6. Log Console
            const LogConsoleView(),
          ],
        ),
      ),
    );
  }
}
