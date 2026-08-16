import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'widgets/custom_titlebar.dart';
import 'widgets/sidebar_nav.dart';
import 'widgets/command_card.dart';
import 'widgets/applications_card.dart';
import 'widgets/general_card.dart';
import 'widgets/audio_card.dart';
import 'widgets/virtual_display_card.dart';
import 'widgets/recording_card.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/keymapper_tab.dart';
import 'tabs/files_tab.dart';
import 'tabs/monitor_tab.dart';
import 'tabs/app_drawer_tab.dart';
import 'tabs/scripts_tab.dart';
import 'tabs/shortcuts_tab.dart';
import 'tabs/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  bool _dismissWarning = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: state.isOledMode ? AppTheme.bgOled : AppTheme.bgDarkest,
      body: Column(
        children: [
          // 1. Custom Desktop Titlebar with working minimize/maximize/close and device pill
          const CustomTitlebar(),

          // 2. Main Body with Sidebar + Tab Content
          Expanded(
            child: Row(
              children: [
                // Animated Sidebar Navigation
                SidebarNav(
                  selectedIndex: _selectedNavIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedNavIndex = index);
                  },
                ),

                // Active Tab Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Warning / Auto-Download Banner (Red) if scrcpy is not detected
                      if (!state.isBinaryReady && !_dismissWarning)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B1214),
                            border: Border.all(color: AppTheme.redAccent.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: AppTheme.redAccent, size: 20),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Scrcpy was not found on your system PATH. You can download official binaries automatically in 1 click.',
                                  style: TextStyle(fontSize: 12, color: Color(0xFFFCA5A5)),
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.greenAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                ),
                                icon: state.isDownloading
                                    ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.download, size: 14),
                                label: Text(state.isDownloading ? 'Downloading...' : '📥 Download Scrcpy v4.1', style: const TextStyle(fontSize: 11)),
                                onPressed: state.isDownloading ? null : () => state.downloadScrcpyBinaries(),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => setState(() => _dismissWarning = true),
                                child: const Text('Dismiss', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 11)),
                              ),
                            ],
                          ),
                        ),

                      // Active View Switcher (9 Tabs) with Smooth Transition
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: IndexedStack(
                            key: ValueKey<int>(_selectedNavIndex),
                            index: _selectedNavIndex,
                            children: [
                              // 0: Home Dashboard
                              _buildHomeDashboard(context),
                              // 1: Favorites
                              const FavoritesTab(),
                              // 2: Keymapper
                              const KeymapperTab(),
                              // 3: Files Explorer
                              const FilesTab(),
                              // 4: Monitor Diagnostics
                              const MonitorTab(),
                              // 5: App Drawer
                              const AppDrawerTab(),
                              // 6: Scripts
                              const ScriptsTab(),
                              // 7: Shortcuts
                              const ShortcutsTab(),
                              // 8: Settings
                              const SettingsTab(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Command Card
          CommandCard(
            onFavorite: () {
              setState(() => _selectedNavIndex = 1);
            },
          ),

          // 2-Column Section Cards
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Left Column (Applications, General)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ApplicationsCard(),
                    GeneralCard(),
                  ],
                ),
              ),
              SizedBox(width: 14),

              // Right Column (Audio, Virtual Display, Recording)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    AudioCard(),
                    VirtualDisplayCard(),
                    RecordingCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
