import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_provider.dart';
import '../services/file_service.dart';
import 'player_screen.dart';

/// 主屏幕 - 文件浏览和选择
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedVideoPath;
  String? _selectedVideoFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Video Player Pro'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 应用图标
            Icon(
              Icons.video_library,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),

            // 标题
            const Text(
              'Video Player Pro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 副标题
            const Text(
              'Professional video player with frame interpolation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),

            // 选择视频按钮
            ElevatedButton.icon(
              onPressed: _selectVideo,
              icon: const Icon(Icons.folder_open),
              label: const Text('Select Video'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 显示选择的文件
            if (_selectedVideoFileName != null)
              Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Video:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedVideoFileName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 播放按钮
                  ElevatedButton.icon(
                    onPressed: _playVideo,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// 选择视频文件
  Future<void> _selectVideo() async {
    final videoPath = await FileService.pickVideoFile();
    if (videoPath != null) {
      setState(() {
        _selectedVideoPath = videoPath;
        _selectedVideoFileName = FileService.getFileName(videoPath);
      });
    }
  }

  /// 播放视频
  void _playVideo() {
    if (_selectedVideoPath != null && _selectedVideoFileName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerScreen(
            videoPath: _selectedVideoPath!,
            videoFileName: _selectedVideoFileName!,
          ),
        ),
      );
    }
  }
}
