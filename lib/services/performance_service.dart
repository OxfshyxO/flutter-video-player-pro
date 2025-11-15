import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/player_model.dart';

/// 性能监测服务
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  
  factory PerformanceService() {
    return _instance;
  }
  
  PerformanceService._internal();

  Timer? _monitoringTimer;
  final List<PerformanceMetrics> _metricsHistory = [];
  final ValueNotifier<PerformanceMetrics?> metricsNotifier = ValueNotifier(null);

  /// 启动性能监测
  void startMonitoring({Duration interval = const Duration(milliseconds: 500)}) {
    if (_monitoringTimer != null) {
      return; // 已经在监测中
    }

    _monitoringTimer = Timer.periodic(interval, (_) async {
      final metrics = await _collectMetrics();
      if (metrics != null) {
        _metricsHistory.add(metrics);
        metricsNotifier.value = metrics;
        
        // 只保留最近100条记录
        if (_metricsHistory.length > 100) {
          _metricsHistory.removeAt(0);
        }
      }
    });
  }

  /// 停止性能监测
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  /// 收集性能指标
  Future<PerformanceMetrics?> _collectMetrics() async {
    try {
      final cpuUsage = await _getCpuUsage();
      final memoryUsage = await _getMemoryUsage();
      
      // 这里的 FPS 数据应该从播放器获取
      // 目前使用模拟数据，实际应该从原生代码获取
      const currentFps = 60.0;
      const targetFps = 60.0;
      
      return PerformanceMetrics(
        currentFps: currentFps,
        targetFps: targetFps,
        fpsRatio: currentFps / targetFps,
        cpuUsage: cpuUsage,
        memoryUsage: memoryUsage,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error collecting metrics: $e');
      return null;
    }
  }

  /// 获取 CPU 使用率
  Future<double> _getCpuUsage() async {
    try {
      if (Platform.isAndroid) {
        // Android: 读取 /proc/stat 文件
        return await _getAndroidCpuUsage();
      } else if (Platform.isWindows) {
        // Windows: 使用 WMI 或其他方法
        return await _getWindowsCpuUsage();
      }
      return 0.0;
    } catch (e) {
      print('Error getting CPU usage: $e');
      return 0.0;
    }
  }

  /// 获取 Android CPU 使用率
  Future<double> _getAndroidCpuUsage() async {
    try {
      final result = await Process.run('cat', ['/proc/stat']);
      if (result.exitCode == 0) {
        final lines = (result.stdout as String).split('\n');
        if (lines.isNotEmpty) {
          final cpuLine = lines.first.split(RegExp(r'\s+'));
          if (cpuLine.length >= 5) {
            final user = int.parse(cpuLine[1]);
            final nice = int.parse(cpuLine[2]);
            final system = int.parse(cpuLine[3]);
            final idle = int.parse(cpuLine[4]);
            
            final total = user + nice + system + idle;
            final used = user + nice + system;
            
            return (used / total) * 100;
          }
        }
      }
      return 0.0;
    } catch (e) {
      print('Error getting Android CPU usage: $e');
      return 0.0;
    }
  }

  /// 获取 Windows CPU 使用率
  Future<double> _getWindowsCpuUsage() async {
    try {
      // Windows 可以使用 tasklist 或其他命令获取 CPU 使用率
      // 这里是一个简化的实现
      return 0.0;
    } catch (e) {
      print('Error getting Windows CPU usage: $e');
      return 0.0;
    }
  }

  /// 获取内存使用率
  Future<double> _getMemoryUsage() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidMemoryUsage();
      } else if (Platform.isWindows) {
        return await _getWindowsMemoryUsage();
      }
      return 0.0;
    } catch (e) {
      print('Error getting memory usage: $e');
      return 0.0;
    }
  }

  /// 获取 Android 内存使用率
  Future<double> _getAndroidMemoryUsage() async {
    try {
      final result = await Process.run('cat', ['/proc/meminfo']);
      if (result.exitCode == 0) {
        final lines = (result.stdout as String).split('\n');
        int memTotal = 0;
        int memAvailable = 0;
        
        for (final line in lines) {
          if (line.startsWith('MemTotal:')) {
            memTotal = int.parse(line.split(RegExp(r'\s+')).elementAt(1));
          } else if (line.startsWith('MemAvailable:')) {
            memAvailable = int.parse(line.split(RegExp(r'\s+')).elementAt(1));
          }
        }
        
        if (memTotal > 0) {
          final memUsed = memTotal - memAvailable;
          return (memUsed / memTotal) * 100;
        }
      }
      return 0.0;
    } catch (e) {
      print('Error getting Android memory usage: $e');
      return 0.0;
    }
  }

  /// 获取 Windows 内存使用率
  Future<double> _getWindowsMemoryUsage() async {
    try {
      // Windows 可以使用 wmic 命令获取内存使用率
      final result = await Process.run('wmic', [
        'OS',
        'get',
        'TotalVisibleMemorySize,FreePhysicalMemory',
        '/value'
      ]);
      
      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final lines = output.split('\n');
        
        int totalMemory = 0;
        int freeMemory = 0;
        
        for (final line in lines) {
          if (line.contains('TotalVisibleMemorySize')) {
            totalMemory = int.tryParse(line.split('=').last.trim()) ?? 0;
          } else if (line.contains('FreePhysicalMemory')) {
            freeMemory = int.tryParse(line.split('=').last.trim()) ?? 0;
          }
        }
        
        if (totalMemory > 0) {
          final usedMemory = totalMemory - freeMemory;
          return (usedMemory / totalMemory) * 100;
        }
      }
      return 0.0;
    } catch (e) {
      print('Error getting Windows memory usage: $e');
      return 0.0;
    }
  }

  /// 获取指标历史
  List<PerformanceMetrics> getMetricsHistory() {
    return List.from(_metricsHistory);
  }

  /// 清空历史记录
  void clearHistory() {
    _metricsHistory.clear();
  }

  /// 获取平均 FPS
  double getAverageFps() {
    if (_metricsHistory.isEmpty) return 0;
    final sum = _metricsHistory.fold<double>(0, (prev, metric) => prev + metric.currentFps);
    return sum / _metricsHistory.length;
  }

  /// 获取平均 CPU 使用率
  double getAverageCpuUsage() {
    if (_metricsHistory.isEmpty) return 0;
    final sum = _metricsHistory.fold<double>(0, (prev, metric) => prev + metric.cpuUsage);
    return sum / _metricsHistory.length;
  }

  /// 释放资源
  void dispose() {
    stopMonitoring();
    metricsNotifier.dispose();
  }
}
