import 'package:flutter/material.dart';
import '../models/player_model.dart';

/// 性能监测面板 Widget
class PerformanceMonitor extends StatelessWidget {
  final PerformanceMetrics? metrics;

  const PerformanceMonitor({
    required this.metrics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (metrics == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: const Text(
          'Waiting for metrics...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor(metrics!),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          const Text(
            'Performance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // FPS 信息
          _buildMetricRow(
            label: 'FPS',
            value: '${metrics!.currentFps.toStringAsFixed(1)} / ${metrics!.targetFps.toStringAsFixed(0)}',
            color: _getFpsColor(metrics!.currentFps, metrics!.targetFps),
          ),

          // FPS 比率
          _buildMetricRow(
            label: 'Ratio',
            value: '${metrics!.fpsRatio.toStringAsFixed(2)}x',
            color: _getRatioColor(metrics!.fpsRatio),
          ),

          // CPU 使用率
          _buildMetricRow(
            label: 'CPU',
            value: '${metrics!.cpuUsage.toStringAsFixed(1)}%',
            color: _getCpuColor(metrics!.cpuUsage),
          ),

          // 内存使用率
          _buildMetricRow(
            label: 'Memory',
            value: '${metrics!.memoryUsage.toStringAsFixed(1)}MB',
            color: _getMemoryColor(metrics!.memoryUsage),
          ),
        ],
      ),
    );
  }

  /// 构建指标行
  Widget _buildMetricRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 获取状态颜色
  Color _getStatusColor(PerformanceMetrics metrics) {
    if (metrics.currentFps >= metrics.targetFps * 0.9) {
      return Colors.green;
    } else if (metrics.currentFps >= metrics.targetFps * 0.7) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  /// 获取 FPS 颜色
  Color _getFpsColor(double currentFps, double targetFps) {
    if (currentFps >= targetFps * 0.95) {
      return Colors.green;
    } else if (currentFps >= targetFps * 0.8) {
      return Colors.yellow;
    } else if (currentFps >= targetFps * 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  /// 获取比率颜色
  Color _getRatioColor(double ratio) {
    if (ratio >= 0.95) {
      return Colors.green;
    } else if (ratio >= 0.8) {
      return Colors.yellow;
    } else if (ratio >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  /// 获取 CPU 颜色
  Color _getCpuColor(double cpuUsage) {
    if (cpuUsage < 50) {
      return Colors.green;
    } else if (cpuUsage < 75) {
      return Colors.yellow;
    } else if (cpuUsage < 90) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  /// 获取内存颜色
  Color _getMemoryColor(double memoryUsage) {
    if (memoryUsage < 500) {
      return Colors.green;
    } else if (memoryUsage < 1000) {
      return Colors.yellow;
    } else if (memoryUsage < 1500) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
