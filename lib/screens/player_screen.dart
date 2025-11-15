import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/player_model.dart';
import '../services/player_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/performance_monitor.dart';

/// 播放器屏幕
class PlayerScreen extends StatefulWidget {
  final String videoPath;
  final String videoFileName;

  const PlayerScreen({
    required this.videoPath,
    required this.videoFileName,
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _showControls = true;
  bool _showPerformanceMonitor = false;

  @override
  void initState() {
    super.initState();
    // 加载视频
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadVideo(widget.videoPath, widget.videoFileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PlayerProvider>().clearVideo();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<PlayerProvider>(
          builder: (context, playerProvider, _) {
            if (!playerProvider.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              child: Stack(
                children: [
                  // 视频播放器
                  Center(
                    child: AspectRatio(
                      aspectRatio: playerProvider.videoController!.value.aspectRatio,
                      child: VideoPlayer(playerProvider.videoController!),
                    ),
                  ),

                  // 控制条
                  if (_showControls)
                    PlayerControls(
                      onToggleInterpolation: (enabled) async {
                        if (enabled) {
                          await playerProvider.enableInterpolation(
                            InterpolationMode.rife,
                            60,
                          );
                        } else {
                          await playerProvider.disableInterpolation();
                        }
                      },
                      onTogglePerformanceMonitor: () {
                        setState(() {
                          _showPerformanceMonitor = !_showPerformanceMonitor;
                        });
                      },
                    ),

                  // 性能监测面板
                  if (_showPerformanceMonitor)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: PerformanceMonitor(
                        metrics: playerProvider.lastMetrics,
                      ),
                    ),

                  // 返回按钮
                  Positioned(
                    top: 16,
                    left: 16,
                    child: SafeArea(
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.black54,
                        onPressed: () {
                          context.read<PlayerProvider>().clearVideo();
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
