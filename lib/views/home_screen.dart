import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'widgets/sidebar_nav.dart';
import 'widgets/command_card.dart';
import 'widgets/applications_card.dart';
import 'widgets/general_card.dart';
import 'widgets/audio_card.dart';
import 'widgets/virtual_display_card.dart';
import 'widgets/recording_card.dart';

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
      backgroundColor: AppTheme.bgDarkest,
      body: Row(
        children: [
          // 1. Left Sidebar Navigation
          SidebarNav(
            selectedIndex: _selectedNavIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedNavIndex = index);
            },
          ),

          // 2. Main Dashboard Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Warning Banner (Red) if scrcpy is not detected
                if (!state.isBinaryReady && !_dismissWarning)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            'Scrcpy was not found on your system PATH. Place scrcpy inside the bin/ directory or configure PATH.',
                            style: TextStyle(fontSize: 12, color: Color(0xFFFCA5A5)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _dismissWarning = true),
                          child: const Text('Dismiss', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                // Main Scrollable Cards Grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Command Card
                        const CommandCard(),

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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
