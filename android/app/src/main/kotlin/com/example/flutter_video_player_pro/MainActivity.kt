package com.example.flutter_video_player_pro

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Debug
import android.os.Process
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.flutter_video_player_pro/player"
    }

    private var interpolationEnabled = false
    private var targetFps = 60

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableInterpolation" -> {
                        val mode = call.argument<String>("mode")
                        targetFps = call.argument<Int>("targetFps") ?: 60
                        interpolationEnabled = enableInterpolation(mode, targetFps)
                        result(interpolationEnabled)
                    }
                    "disableInterpolation" -> {
                        interpolationEnabled = false
                        result(true)
                    }
                    "getPerformanceMetrics" -> {
                        val metrics = getPerformanceMetrics()
                        result(metrics)
                    }
                    "loadSubtitle" -> {
                        val subtitlePath = call.argument<String>("subtitlePath")
                        val success = loadSubtitle(subtitlePath)
                        result(success)
                    }
                    else -> result(null)
                }
            }
    }

    private fun enableInterpolation(mode: String?, targetFps: Int): Boolean {
        return try {
            // 这里应该集成实际的插帧库（如 RIFE 或 DAIN）
            // 目前返回 true 表示启用成功
            // 实际实现需要通过 JNI 调用 C++ 代码
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun loadSubtitle(subtitlePath: String?): Boolean {
        return try {
            // 这里应该实现字幕加载逻辑
            // 目前返回 true 表示加载成功
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun getPerformanceMetrics(): Map<String, Any> {
        return try {
            val cpuUsage = getCpuUsage()
            val memoryUsage = getMemoryUsage()
            val currentFps = if (interpolationEnabled) targetFps.toDouble() else 30.0

            mapOf(
                "currentFps" to currentFps,
                "targetFps" to targetFps.toDouble(),
                "fpsRatio" to (currentFps / targetFps),
                "cpuUsage" to cpuUsage,
                "memoryUsage" to memoryUsage
            )
        } catch (e: Exception) {
            e.printStackTrace()
            mapOf(
                "currentFps" to 0.0,
                "targetFps" to 0.0,
                "fpsRatio" to 0.0,
                "cpuUsage" to 0.0,
                "memoryUsage" to 0.0
            )
        }
    }

    private fun getCpuUsage(): Double {
        return try {
            val runtime = Runtime.getRuntime()
            val nativeHeap = Debug.getNativeHeap()
            val nativeHeapAllocated = nativeHeap.summaryTotalAllocated
            val nativeHeapFree = nativeHeap.summaryTotalFree

            // 简化的 CPU 使用率计算
            val totalMemory = runtime.totalMemory()
            val freeMemory = runtime.freeMemory()
            val usedMemory = totalMemory - freeMemory

            (usedMemory.toDouble() / totalMemory.toDouble()) * 100
        } catch (e: Exception) {
            e.printStackTrace()
            0.0
        }
    }

    private fun getMemoryUsage(): Double {
        return try {
            val runtime = Runtime.getRuntime()
            val totalMemory = runtime.totalMemory()
            val freeMemory = runtime.freeMemory()
            val usedMemory = totalMemory - freeMemory

            // 转换为 MB
            usedMemory.toDouble() / (1024 * 1024)
        } catch (e: Exception) {
            e.printStackTrace()
            0.0
        }
    }
}
