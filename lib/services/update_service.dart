import 'dart:convert';
import 'dart:io';

class UpdateInfo {
  final String tagName;
  final String htmlUrl;
  final String body;
  final bool hasUpdate;

  UpdateInfo({
    required this.tagName,
    required this.htmlUrl,
    required this.body,
    required this.hasUpdate,
  });
}

class UpdateService {
  static const currentVersion = 'v2.0.0';
  static const repo = 'dyagyatis/scrcpy-gui';

  Future<UpdateInfo> checkForUpdates() async {
    try {
      final client = HttpClient();
      client.userAgent = 'Scrcpy-GUI-Flutter';
      final uri = Uri.parse('https://api.github.com/repos/$repo/releases/latest');
      final req = await client.getUrl(uri);
      final resp = await req.close();

      if (resp.statusCode == 200) {
        final bodyStr = await resp.transform(utf8.decoder).join();
        final json = jsonDecode(bodyStr);
        final tag = json['tag_name'] ?? '';
        final url = json['html_url'] ?? 'https://github.com/$repo/releases';
        final desc = json['body'] ?? '';

        final isNewer = tag.isNotEmpty && tag != currentVersion;
        return UpdateInfo(
          tagName: tag,
          htmlUrl: url,
          body: desc,
          hasUpdate: isNewer,
        );
      }
    } catch (_) {}

    return UpdateInfo(
      tagName: currentVersion,
      htmlUrl: 'https://github.com/$repo/releases',
      body: '',
      hasUpdate: false,
    );
  }
}
