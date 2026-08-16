import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class AndroidFileItem {
  final String name;
  final bool isDirectory;
  final String size;
  final String date;

  AndroidFileItem({
    required this.name,
    required this.isDirectory,
    required this.size,
    required this.date,
  });
}

class FilesTab extends StatefulWidget {
  const FilesTab({super.key});

  @override
  State<FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  String _currentPath = '/sdcard/';
  List<AndroidFileItem> _items = [];
  bool _isLoading = false;
  String _statusMsg = '';

  @override
  void initState() {
    super.initState();
    _loadDirectory(_currentPath);
  }

  Future<void> _loadDirectory(String path) async {
    final state = context.read<AppState>();
    if (state.selectedSerial == null) return;

    setState(() {
      _isLoading = true;
      _currentPath = path.endsWith('/') ? path : '$path/';
    });

    final res = await state.adb.runAdb([
      if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
      'shell',
      'ls',
      '-l',
      _currentPath,
    ]);

    if (mounted) {
      if (res.exitCode == 0) {
        final lines = res.stdout.toString().split('\n');
        List<AndroidFileItem> list = [];

        for (var line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('total')) continue;
          final parts = trimmed.split(RegExp(r'\s+'));
          if (parts.length >= 8) {
            final isDir = parts[0].startsWith('d');
            final size = isDir ? '<DIR>' : '${(int.tryParse(parts[4]) ?? 0) ~/ 1024} KB';
            final date = '${parts[5]} ${parts[6]}';
            final name = parts.sublist(7).join(' ');
            if (name != '.' && name != '..') {
              list.add(AndroidFileItem(name: name, isDirectory: isDir, size: size, date: date));
            }
          }
        }
        list.sort((a, b) {
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        setState(() {
          _items = list;
          _isLoading = false;
        });
      } else {
        setState(() {
          _items = [];
          _isLoading = false;
        });
      }
    }
  }

  void _navigateUp() {
    if (_currentPath == '/sdcard/' || _currentPath == '/' || _currentPath == '/sdcard') return;
    final parent = _currentPath.replaceAll(RegExp(r'[^/]+/?$'), '');
    _loadDirectory(parent.isEmpty ? '/sdcard/' : parent);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.folder_shared_rounded, color: AppTheme.blueAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                state.tr('file_explorer'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.upload_file, size: 16),
                label: Text(state.tr('upload_file')),
                onPressed: state.selectedSerial == null ? null : () => _showUploadDialog(state),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Quick Shortcuts & Breadcrumbs
          Row(
            children: [
              _buildShortcutChip('📁 /sdcard', '/sdcard/'),
              const SizedBox(width: 6),
              _buildShortcutChip('📷 DCIM/Camera', '/sdcard/DCIM/Camera/'),
              const SizedBox(width: 6),
              _buildShortcutChip('⬇️ Downloads', '/sdcard/Download/'),
              const SizedBox(width: 6),
              _buildShortcutChip('🖼 Pictures', '/sdcard/Pictures/'),
              const SizedBox(width: 6),
              _buildShortcutChip('🎵 Music', '/sdcard/Music/'),
            ],
          ),
          const SizedBox(height: 12),

          // Path Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 16, color: AppTheme.purpleAccent),
                  tooltip: 'Go to parent folder',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _navigateUp,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _currentPath,
                    style: const TextStyle(fontFamily: 'Consolas', fontSize: 13, color: Color(0xFF60A5FA), fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16, color: AppTheme.textSecondary),
                  tooltip: 'Refresh',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _loadDirectory(_currentPath),
                ),
              ],
            ),
          ),
          if (_statusMsg.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_statusMsg, style: const TextStyle(fontSize: 11, color: AppTheme.greenAccent)),
          ],
          const SizedBox(height: 10),

          // Files Table / List
          Expanded(
            child: state.selectedSerial == null
                ? const Center(child: Text('No Android device connected.', style: TextStyle(color: AppTheme.textMuted)))
                : _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _items.isEmpty
                        ? const Center(child: Text('Folder is empty.', style: TextStyle(color: AppTheme.textMuted)))
                        : Container(
                            decoration: BoxDecoration(
                              color: AppTheme.bgCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderColor),
                            ),
                            child: ListView.separated(
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => const Divider(color: AppTheme.borderColor, height: 1),
                              itemBuilder: (context, idx) {
                                final item = _items[idx];
                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    item.isDirectory ? Icons.folder_rounded : Icons.insert_drive_file_rounded,
                                    color: item.isDirectory ? AppTheme.yellowAccent : AppTheme.blueAccent,
                                    size: 20,
                                  ),
                                  title: Text(item.name, style: const TextStyle(fontSize: 13, color: Colors.white)),
                                  subtitle: Text('${item.date} • ${item.size}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                  trailing: item.isDirectory
                                      ? const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted)
                                      : IconButton(
                                          icon: const Icon(Icons.download_rounded, size: 16, color: AppTheme.greenAccent),
                                          tooltip: 'Download to PC (~/Downloads)',
                                          onPressed: () => _downloadFile(state, item.name),
                                        ),
                                  onTap: item.isDirectory
                                      ? () => _loadDirectory('$_currentPath${item.name}/')
                                      : null,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutChip(String label, String targetPath) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: AppTheme.bgInput,
      onPressed: () => _loadDirectory(targetPath),
    );
  }

  Future<void> _downloadFile(AppState state, String fileName) async {
    final phoneFile = '$_currentPath$fileName';
    setState(() => _statusMsg = '⏳ Downloading $fileName...');
    final res = await state.adb.runAdb([
      if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
      'pull',
      phoneFile,
      'Downloads/',
    ]);
    setState(() {
      _statusMsg = res.exitCode == 0 ? '✅ Downloaded to Downloads/$fileName' : '❌ Failed: ${res.stderr}';
    });
  }

  void _showUploadDialog(AppState state) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Upload Local File to Device', style: TextStyle(fontSize: 15)),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Absolute Local File Path', hintText: 'C:\\path\\to\\file.jpg'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.purpleAccent, foregroundColor: Colors.white),
            onPressed: () async {
              final path = ctrl.text.trim();
              if (path.isNotEmpty) {
                Navigator.pop(ctx);
                setState(() => _statusMsg = '⏳ Uploading $path...');
                final res = await state.adb.pushFile(state.selectedSerial!, path, remoteDir: _currentPath);
                setState(() {
                  _statusMsg = res['success'] == true ? '✅ File uploaded successfully!' : '❌ Upload error: ${res['message']}';
                });
                _loadDirectory(_currentPath);
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
