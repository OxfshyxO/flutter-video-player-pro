import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_provider.dart';

/// 播放器控制条 Widget
class PlayerControls extends StatefulWidget {
  final Function(bool) onToggleInterpolation;
  final VoidCallback onTogglePerformanceMonitor;

  const PlayerControls({
    required this.onToggleInterpolation,
    required this.onTogglePerformanceMonitor,
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool _interpolationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, _) {
        return Stack(
          children: [
            // 底部渐变背景
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // 控制条内容
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 进度条
                    _buildProgressBar(playerProvider),
                    const SizedBox(height: 16),

                    // 控制按钮行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左侧：播放/暂停按钮
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                playerProvider.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                if (playerProvider.isPlaying) {
                                  playerProvider.pause();
                                } else {
                                  playerProvider.play();
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.stop),
                              color: Colors.white,
                              onPressed: () {
                                playerProvider.stop();
                              },
                            ),
                          ],
                        ),

                        // 右侧：功能按钮
                        Row(
                          children: [
                            // 插帧按钮
                            IconButton(
                              icon: Icon(
                                _interpolationEnabled
                                    ? Icons.speed
                                    : Icons.speed_outlined,
                                color: _interpolationEnabled
                                    ? Colors.green
                                    : Colors.white,
                              ),
                              tooltip: 'Frame Interpolation',
                              onPressed: () {
                                setState(() {
                                  _interpolationEnabled = !_interpolationEnabled;
                                });
                                widget.onToggleInterpolation(_interpolationEnabled);
                              },
                            ),

                            // 性能监测按钮
                            IconButton(
                              icon: const Icon(Icons.assessment),
                              color: Colors.white,
                              tooltip: 'Performance Monitor',
                              onPressed: widget.onTogglePerformanceMonitor,
                            ),

                            // 字幕按钮
                            IconButton(
                              icon: const Icon(Icons.subtitles),
                              color: Colors.white,
                              tooltip: 'Subtitles',
                              onPressed: () {
                                _showSubtitleMenu(context, playerProvider);
                              },
                            ),

                            // 设置按钮
                            IconButton(
                              icon: const Icon(Icons.settings),
                              color: Colors.white,
                              tooltip: 'Settings',
                              onPressed: () {
                                _showSettingsMenu(context, playerProvider);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(PlayerProvider playerProvider) {
    final controller = playerProvider.videoController;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
          ),
          child: Slider(
            value: controller.value.position.inMilliseconds.toDouble(),
            max: controller.value.duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              playerProvider.seekTo(Duration(milliseconds: value.toInt()));
            },
            activeColor: Colors.red,
            inactiveColor: Colors.grey[600],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(controller.value.position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                _formatDuration(controller.value.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示字幕菜单
  void _showSubtitleMenu(BuildContext context, PlayerProvider playerProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Subtitles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Load Subtitle'),
              onTap: () {
                Navigator.pop(context);
                // 加载字幕逻辑
              },
            ),
            if (playerProvider.currentSubtitle != null)
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Remove Subtitle'),
                onTap: () {
                  Navigator.pop(context);
                  // 移除字幕逻辑
                },
              ),
          ],
        ),
      ),
    );
  }

  /// 显示设置菜单
  void _showSettingsMenu(BuildContext context, PlayerProvider playerProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Target FPS'),
              subtitle: Text('${playerProvider.config.targetFps} FPS'),
              onTap: () {
                Navigator.pop(context);
                _showFpsSelector(context, playerProvider);
              },
            ),
            ListTile(
              title: const Text('Interpolation Mode'),
              subtitle: Text(playerProvider.config.interpolationMode.toString()),
              onTap: () {
                Navigator.pop(context);
                // 选择插帧模式
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示 FPS 选择器
  void _showFpsSelector(BuildContext context, PlayerProvider playerProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Target FPS'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [30, 60, 120, 144]
              .map((fps) => ListTile(
                    title: Text('$fps FPS'),
                    onTap: () {
                      Navigator.pop(context);
                      playerProvider.updateConfig(
                        playerProvider.config.copyWith(targetFps: fps),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  /// 格式化时长
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
