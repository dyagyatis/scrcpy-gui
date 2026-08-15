import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class LogConsoleView extends StatelessWidget {
  const LogConsoleView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            const Text(
              '📜 Команда и логи scrcpy:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              icon: const Icon(Icons.delete_outline, size: 14),
              label: const Text('Очистить', style: TextStyle(fontSize: 11)),
              onPressed: () => state.clearLogs(),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              icon: const Icon(Icons.copy, size: 14),
              label: const Text('Скопировать', style: TextStyle(fontSize: 11)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: state.logs.join('\n')));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Логи скопированы в буфер обмена')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Command Preview
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0D13),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF1E2433)),
          ),
          child: SelectableText(
            state.commandPreview,
            style: const TextStyle(
              fontFamily: 'Consolas',
              fontSize: 11,
              color: Color(0xFF60A5FA),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Log Output Box
        Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0C10),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF20242E)),
          ),
          child: state.logs.isEmpty
              ? const Center(
                  child: Text(
                    'Ожидание запуска...',
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.logs.length,
                  itemBuilder: (context, index) {
                    final line = state.logs[index];
                    return Text(
                      line,
                      style: TextStyle(
                        fontFamily: 'Consolas',
                        fontSize: 11,
                        color: line.contains('[GUI ERROR]') || line.contains('[scrcpy err]')
                            ? AppTheme.dangerColor
                            : const Color(0xFFA7F3D0),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
