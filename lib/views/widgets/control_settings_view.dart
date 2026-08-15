import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ControlSettingsView extends StatelessWidget {
  const ControlSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Custom Window Geometry
          _buildCard(
            title: '📐 Размер и геометрия окна Scrcpy',
            children: [
              SwitchListTile(
                title: const Text('Задать пользовательский размер окна (Width / Height)', style: TextStyle(fontSize: 13)),
                value: cfg.customWindowSize,
                onChanged: (v) {
                  cfg.customWindowSize = v;
                  state.saveSettings();
                },
              ),
              if (cfg.customWindowSize) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: cfg.windowWidth.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Ширина (px)', isDense: true),
                        onChanged: (v) {
                          cfg.windowWidth = int.tryParse(v) ?? 500;
                          state.saveSettings();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: cfg.windowHeight.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Высота (px)', isDense: true),
                        onChanged: (v) {
                          cfg.windowHeight = int.tryParse(v) ?? 1050;
                          state.saveSettings();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    _buildSizeChip('📱 Компактный (400x850)', 400, 850, cfg, state),
                    _buildSizeChip('📱 Стандарт (500x1050)', 500, 1050, cfg, state),
                    _buildSizeChip('📱 Большой (650x1400)', 650, 1400, cfg, state),
                    _buildSizeChip('🖥 Full HD (1920x1080)', 1920, 1080, cfg, state),
                  ],
                ),
              ],
              const Divider(color: AppTheme.borderColor),
              SwitchListTile(
                title: const Text('Задать координаты на мониторе (X / Y)', style: TextStyle(fontSize: 13)),
                value: cfg.customWindowPos,
                onChanged: (v) {
                  cfg.customWindowPos = v;
                  state.saveSettings();
                },
              ),
              if (cfg.customWindowPos) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: cfg.windowX.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Позиция X (px)', isDense: true),
                        onChanged: (v) {
                          cfg.windowX = int.tryParse(v) ?? 100;
                          state.saveSettings();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: cfg.windowY.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Позиция Y (px)', isDense: true),
                        onChanged: (v) {
                          cfg.windowY = int.tryParse(v) ?? 100;
                          state.saveSettings();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // 2. Window flags
          _buildCard(
            title: 'Окно и отображение',
            children: [
              SwitchListTile(
                title: const Text('📌 Поверх всех окон (Always on Top)', style: TextStyle(fontSize: 13)),
                value: cfg.alwaysOnTop,
                onChanged: (v) {
                  cfg.alwaysOnTop = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('🖥 Полноэкранный режим (Fullscreen)', style: TextStyle(fontSize: 13)),
                value: cfg.fullscreen,
                onChanged: (v) {
                  cfg.fullscreen = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('🔲 Без рамок окна (Borderless)', style: TextStyle(fontSize: 13)),
                value: cfg.borderless,
                onChanged: (v) {
                  cfg.borderless = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('🚫 Режим "Только просмотр" (без ввода)', style: TextStyle(fontSize: 13)),
                value: cfg.noControl,
                onChanged: (v) {
                  cfg.noControl = v;
                  state.saveSettings();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 3. Device Behavior
          _buildCard(
            title: 'Поведение экрана телефона',
            children: [
              SwitchListTile(
                title: const Text('💡 Выключить экран телефона при подключении', style: TextStyle(fontSize: 13)),
                subtitle: const Text('Экономит батарею, экран транслируется на ПК', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                value: cfg.turnScreenOff,
                onChanged: (v) {
                  cfg.turnScreenOff = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('⏰ Не давать уснуть (Stay Awake)', style: TextStyle(fontSize: 13)),
                value: cfg.stayAwake,
                onChanged: (v) {
                  cfg.stayAwake = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('👆 Показывать точки касания на экране', style: TextStyle(fontSize: 13)),
                value: cfg.showTouches,
                onChanged: (v) {
                  cfg.showTouches = v;
                  state.saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('🖱 OTG режим (Клавиатура/мышь без видео)', style: TextStyle(fontSize: 13)),
                value: cfg.otgMode,
                onChanged: (v) {
                  cfg.otgMode = v;
                  state.saveSettings();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeChip(String label, int w, int h, dynamic cfg, AppState state) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: AppTheme.bgInput,
      onPressed: () {
        cfg.windowWidth = w;
        cfg.windowHeight = h;
        state.saveSettings();
      },
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF93C5FD),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
