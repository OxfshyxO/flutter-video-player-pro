import 'package:flutter/foundation.dart';

/// 播放器状态枚举
enum PlayerState {
  idle,
  loading,
  playing,
  paused,
  stopped,
  error,
}

/// 插帧模式枚举
enum InterpolationMode {
  none,
  rife,
  dain,
}

/// 播放器配置模型
class PlayerConfig {
  final bool enableInterpolation;
  final InterpolationMode interpolationMode;
  final int targetFps;
  final bool enableSubtitles;
  final bool enablePerformanceMonitoring;

  PlayerConfig({
    this.enableInterpolation = false,
    this.interpolationMode = InterpolationMode.rife,
    this.targetFps = 60,
    this.enableSubtitles = true,
    this.enablePerformanceMonitoring = true,
  });

  PlayerConfig copyWith({
    bool? enableInterpolation,
    InterpolationMode? interpolationMode,
    int? targetFps,
    bool? enableSubtitles,
    bool? enablePerformanceMonitoring,
  }) {
    return PlayerConfig(
      enableInterpolation: enableInterpolation ?? this.enableInterpolation,
      interpolationMode: interpolationMode ?? this.interpolationMode,
      targetFps: targetFps ?? this.targetFps,
      enableSubtitles: enableSubtitles ?? this.enableSubtitles,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
    );
  }
}

/// 性能监测数据模型
class PerformanceMetrics {
  final double currentFps;
  final double targetFps;
  final double fpsRatio;
  final double cpuUsage;
  final double memoryUsage;
  final DateTime timestamp;

  PerformanceMetrics({
    required this.currentFps,
    required this.targetFps,
    required this.fpsRatio,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'PerformanceMetrics(currentFps: $currentFps, targetFps: $targetFps, '
        'fpsRatio: ${fpsRatio.toStringAsFixed(2)}x, cpuUsage: ${cpuUsage.toStringAsFixed(2)}%, '
        'memoryUsage: ${memoryUsage.toStringAsFixed(2)}MB)';
  }
}

/// 视频信息模型
class VideoInfo {
  final String filePath;
  final String fileName;
  final Duration duration;
  final int width;
  final int height;
  final double frameRate;

  VideoInfo({
    required this.filePath,
    required this.fileName,
    required this.duration,
    required this.width,
    required this.height,
    required this.frameRate,
  });

  @override
  String toString() {
    return 'VideoInfo(fileName: $fileName, duration: $duration, '
        'resolution: ${width}x$height, frameRate: ${frameRate.toStringAsFixed(2)}fps)';
  }
}

/// 字幕信息模型
class SubtitleInfo {
  final String filePath;
  final String fileName;
  final String language;
  final bool isLoaded;

  SubtitleInfo({
    required this.filePath,
    required this.fileName,
    required this.language,
    this.isLoaded = false,
  });

  @override
  String toString() {
    return 'SubtitleInfo(fileName: $fileName, language: $language, isLoaded: $isLoaded)';
  }
}
