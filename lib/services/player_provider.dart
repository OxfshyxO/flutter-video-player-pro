import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../models/player_model.dart';
import 'player_service.dart';
import 'performance_service.dart';

/// 播放器提供者 - 使用 ChangeNotifier 进行状态管理
class PlayerProvider extends ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  final PerformanceService _performanceService = PerformanceService();

  VideoInfo? _currentVideo;
  SubtitleInfo? _currentSubtitle;
  PlayerState _state = PlayerState.idle;
  PlayerConfig _config = PlayerConfig();
  PerformanceMetrics? _lastMetrics;

  // Getters
  VideoInfo? get currentVideo => _currentVideo;
  SubtitleInfo? get currentSubtitle => _currentSubtitle;
  PlayerState get state => _state;
  PlayerConfig get config => _config;
  PerformanceMetrics? get lastMetrics => _lastMetrics;
  bool get isPlaying => _state == PlayerState.playing;
  bool get isInitialized => _playerService.isInitialized;
  VideoPlayerController? get videoController {
    if (_playerService.isInitialized) {
      return _playerService.getController();
    }
    return null;
  }

  /// 加载视频
  Future<bool> loadVideo(String videoPath, String fileName) async {
    try {
      _state = PlayerState.loading;
      notifyListeners();

      final success = await _playerService.initialize(videoPath);
      if (success) {
        final controller = _playerService.getController();
        _currentVideo = VideoInfo(
          filePath: videoPath,
          fileName: fileName,
          duration: controller.value.duration,
          width: controller.value.size.width.toInt(),
          height: controller.value.size.height.toInt(),
          frameRate: 30.0, // 默认值，实际应该从视频元数据获取
        );
        _state = PlayerState.idle;
        _performanceService.startMonitoring();
      } else {
        _state = PlayerState.error;
      }
    } catch (e) {
      _state = PlayerState.error;
      print('Error loading video: $e');
    }
    notifyListeners();
    return _state != PlayerState.error;
  }

  /// 播放视频
  Future<void> play() async {
    try {
      await _playerService.play();
      _state = PlayerState.playing;
    } catch (e) {
      _state = PlayerState.error;
      print('Error playing: $e');
    }
    notifyListeners();
  }

  /// 暂停视频
  Future<void> pause() async {
    try {
      await _playerService.pause();
      _state = PlayerState.paused;
    } catch (e) {
      _state = PlayerState.error;
      print('Error pausing: $e');
    }
    notifyListeners();
  }

  /// 停止播放
  Future<void> stop() async {
    try {
      await _playerService.stop();
      _state = PlayerState.stopped;
    } catch (e) {
      _state = PlayerState.error;
      print('Error stopping: $e');
    }
    notifyListeners();
  }

  /// 跳转到指定位置
  Future<void> seekTo(Duration position) async {
    try {
      await _playerService.seekTo(position);
    } catch (e) {
      print('Error seeking: $e');
    }
    notifyListeners();
  }

  /// 更新配置
  void updateConfig(PlayerConfig newConfig) {
    _config = newConfig;
    _playerService.updateConfig(newConfig);
    notifyListeners();
  }

  /// 启用插帧
  Future<bool> enableInterpolation(InterpolationMode mode, int targetFps) async {
    try {
      final success = await _playerService.enableInterpolation(mode, targetFps);
      if (success) {
        _config = _config.copyWith(
          enableInterpolation: true,
          interpolationMode: mode,
          targetFps: targetFps,
        );
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error enabling interpolation: $e');
      return false;
    }
  }

  /// 禁用插帧
  Future<bool> disableInterpolation() async {
    try {
      final success = await _playerService.disableInterpolation();
      if (success) {
        _config = _config.copyWith(enableInterpolation: false);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error disabling interpolation: $e');
      return false;
    }
  }

  /// 加载字幕
  Future<bool> loadSubtitle(String subtitlePath, String fileName) async {
    try {
      final success = await _playerService.loadSubtitle(subtitlePath);
      if (success) {
        _currentSubtitle = SubtitleInfo(
          filePath: subtitlePath,
          fileName: fileName,
          language: 'Unknown',
          isLoaded: true,
        );
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error loading subtitle: $e');
      return false;
    }
  }

  /// 更新性能指标
  void updatePerformanceMetrics(PerformanceMetrics metrics) {
    _lastMetrics = metrics;
    notifyListeners();
  }

  /// 清除当前视频
  void clearVideo() {
    _currentVideo = null;
    _currentSubtitle = null;
    _state = PlayerState.idle;
    _performanceService.stopMonitoring();
    notifyListeners();
  }

  /// 释放资源
  @override
  void dispose() {
    _performanceService.dispose();
    _playerService.dispose();
    super.dispose();
  }
}
