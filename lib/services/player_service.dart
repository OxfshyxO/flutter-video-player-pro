import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/player_model.dart';

/// 播放器服务 - 管理视频播放的核心逻辑
class PlayerService {
  static const platform = MethodChannel('com.example.flutter_video_player_pro/player');
  
  late VideoPlayerController _controller;
  PlayerState _state = PlayerState.idle;
  PlayerConfig _config = PlayerConfig();
  
  bool get isInitialized => _controller.value.isInitialized;
  bool get isPlaying => _controller.value.isPlaying;
  PlayerState get state => _state;
  PlayerConfig get config => _config;

  /// 初始化播放器
  Future<bool> initialize(String videoPath) async {
    try {
      _state = PlayerState.loading;
      
      final file = File(videoPath);
      _controller = VideoPlayerController.file(file);
      await _controller.initialize();
      
      _state = PlayerState.idle;
      return true;
    } catch (e) {
      _state = PlayerState.error;
      print('Error initializing player: $e');
      return false;
    }
  }

  /// 播放视频
  Future<void> play() async {
    try {
      if (_controller.value.isInitialized) {
        await _controller.play();
        _state = PlayerState.playing;
      }
    } catch (e) {
      _state = PlayerState.error;
      print('Error playing video: $e');
    }
  }

  /// 暂停视频
  Future<void> pause() async {
    try {
      if (_controller.value.isInitialized) {
        await _controller.pause();
        _state = PlayerState.paused;
      }
    } catch (e) {
      _state = PlayerState.error;
      print('Error pausing video: $e');
    }
  }

  /// 停止播放
  Future<void> stop() async {
    try {
      if (_controller.value.isInitialized) {
        await _controller.pause();
        await _controller.seekTo(Duration.zero);
        _state = PlayerState.stopped;
      }
    } catch (e) {
      _state = PlayerState.error;
      print('Error stopping video: $e');
    }
  }

  /// 跳转到指定位置
  Future<void> seekTo(Duration position) async {
    try {
      if (_controller.value.isInitialized) {
        await _controller.seekTo(position);
      }
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  /// 获取当前播放位置
  Duration getCurrentPosition() {
    if (_controller.value.isInitialized) {
      return _controller.value.position;
    }
    return Duration.zero;
  }

  /// 获取视频总时长
  Duration getDuration() {
    if (_controller.value.isInitialized) {
      return _controller.value.duration;
    }
    return Duration.zero;
  }

  /// 获取视频控制器
  VideoPlayerController getController() {
    return _controller;
  }

  /// 更新配置
  void updateConfig(PlayerConfig newConfig) {
    _config = newConfig;
  }

  /// 启用插帧功能（调用原生代码）
  Future<bool> enableInterpolation(InterpolationMode mode, int targetFps) async {
    try {
      final result = await platform.invokeMethod('enableInterpolation', {
        'mode': mode.toString(),
        'targetFps': targetFps,
      });
      return result as bool;
    } on PlatformException catch (e) {
      print('Error enabling interpolation: ${e.message}');
      return false;
    }
  }

  /// 禁用插帧功能
  Future<bool> disableInterpolation() async {
    try {
      final result = await platform.invokeMethod('disableInterpolation');
      return result as bool;
    } on PlatformException catch (e) {
      print('Error disabling interpolation: ${e.message}');
      return false;
    }
  }

  /// 获取性能指标
  Future<PerformanceMetrics?> getPerformanceMetrics() async {
    try {
      final result = await platform.invokeMethod('getPerformanceMetrics');
      if (result != null) {
        return PerformanceMetrics(
          currentFps: (result['currentFps'] as num).toDouble(),
          targetFps: (result['targetFps'] as num).toDouble(),
          fpsRatio: (result['fpsRatio'] as num).toDouble(),
          cpuUsage: (result['cpuUsage'] as num).toDouble(),
          memoryUsage: (result['memoryUsage'] as num).toDouble(),
          timestamp: DateTime.now(),
        );
      }
      return null;
    } on PlatformException catch (e) {
      print('Error getting performance metrics: ${e.message}');
      return null;
    }
  }

  /// 加载字幕
  Future<bool> loadSubtitle(String subtitlePath) async {
    try {
      final result = await platform.invokeMethod('loadSubtitle', {
        'subtitlePath': subtitlePath,
      });
      return result as bool;
    } on PlatformException catch (e) {
      print('Error loading subtitle: ${e.message}');
      return false;
    }
  }

  /// 释放资源
  Future<void> dispose() async {
    try {
      await _controller.dispose();
      _state = PlayerState.idle;
    } catch (e) {
      print('Error disposing player: $e');
    }
  }
}
