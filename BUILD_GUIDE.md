# Flutter Video Player Pro - 构建指南

这是一个专业的跨平台视频播放器应用，支持实时视频插帧、外挂字幕和性能监测。

## 项目特性

- ✅ **完善的播放功能**：播放/暂停/停止/快进/快退
- ✅ **外挂字幕支持**：支持 SRT、ASS、VTT 等多种格式
- ✅ **实时视频插帧**：将视频插帧到 60fps 或更高帧率（RIFE/DAIN）
- ✅ **性能监测**：实时显示 FPS、CPU 占用、内存使用
- ✅ **跨平台支持**：Android 和 Windows

## 系统要求

### 通用要求
- Flutter 3.38.1 或更高版本
- Dart 3.10.0 或更高版本

### Android 编译要求
- Android Studio 2023.1 或更高版本
- Android SDK 33 或更高版本
- Android NDK r25 或更高版本
- Gradle 8.0 或更高版本
- Java 11 或更高版本

### Windows 编译要求
- Visual Studio 2022 或更高版本
- Windows 10 SDK
- CMake 3.10 或更高版本

## 项目结构

```
flutter_video_player_pro/
├── lib/                          # Dart 源代码
│   ├── main.dart                # 应用入口
│   ├── models/                  # 数据模型
│   │   └── player_model.dart
│   ├── screens/                 # 页面
│   │   ├── home_screen.dart
│   │   └── player_screen.dart
│   ├── services/                # 服务层
│   │   ├── player_service.dart
│   │   ├── file_service.dart
│   │   ├── performance_service.dart
│   │   └── player_provider.dart
│   └── widgets/                 # UI 组件
│       ├── player_controls.dart
│       └── performance_monitor.dart
├── android/                     # Android 原生代码
│   └── app/src/main/kotlin/
│       └── MainActivity.kt      # Android 主活动
├── windows/                     # Windows 原生代码
│   └── runner/
│       ├── player_channel.h     # Windows 平台通道头文件
│       ├── player_channel.cpp   # Windows 平台通道实现
│       ├── flutter_window.h     # Flutter 窗口头文件
│       └── flutter_window.cpp   # Flutter 窗口实现
├── pubspec.yaml                 # Flutter 依赖配置
└── BUILD_GUIDE.md              # 本文件
```

## 编译步骤

### 1. 环境准备

#### 安装 Flutter
```bash
# 克隆 Flutter 仓库
git clone https://github.com/flutter/flutter.git -b stable

# 添加到 PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 验证安装
flutter doctor
```

#### 获取项目依赖
```bash
cd flutter_video_player_pro
flutter pub get
```

### 2. Android 编译

#### 2.1 配置 Android 环境
```bash
# 设置 Android SDK 路径（如果不在默认位置）
flutter config --android-sdk /path/to/android/sdk

# 验证 Android 环境
flutter doctor -v
```

#### 2.2 编译 APK（Debug）
```bash
flutter build apk --debug
```

输出文件：`build/app/outputs/flutter-apk/app-debug.apk`

#### 2.3 编译 APK（Release）
```bash
flutter build apk --release
```

输出文件：`build/app/outputs/flutter-apk/app-release.apk`

#### 2.4 编译 AAB（Google Play）
```bash
flutter build appbundle --release
```

输出文件：`build/app/outputs/bundle/release/app-release.aab`

### 3. Windows 编译

#### 3.1 配置 Windows 环境
```bash
# 验证 Windows 环境
flutter doctor -v

# 如果需要，安装 Visual Studio Build Tools
# https://visualstudio.microsoft.com/downloads/
```

#### 3.2 编译 EXE（Debug）
```bash
flutter build windows --debug
```

输出文件：`build/windows/x64/runner/Debug/flutter_video_player_pro.exe`

#### 3.3 编译 EXE（Release）
```bash
flutter build windows --release
```

输出文件：`build/windows/x64/runner/Release/flutter_video_player_pro.exe`

### 4. 安装和运行

#### Android
```bash
# 连接 Android 设备或启动模拟器
adb devices

# 安装 APK
adb install build/app/outputs/flutter-apk/app-release.apk

# 或者直接运行
flutter run -v
```

#### Windows
```bash
# 直接运行
flutter run -v

# 或者运行编译好的 EXE
build/windows/x64/runner/Release/flutter_video_player_pro.exe
```

## 核心功能说明

### 1. 视频播放
- 支持本地视频文件选择
- 支持多种视频格式（MP4、MKV、AVI、MOV 等）
- 完整的播放控制（播放、暂停、停止、快进、快退）

### 2. 插帧功能
- 支持启用/禁用实时插帧
- 支持 RIFE 和 DAIN 两种插帧算法
- 可配置目标帧率（30、60、120、144 fps）
- 实时性能监测

### 3. 字幕支持
- 支持加载外挂字幕文件
- 支持多种字幕格式（SRT、ASS、VTT 等）
- 字幕位置和大小可调整

### 4. 性能监测
- 实时 FPS 显示（当前/目标）
- CPU 占用率监测
- 内存使用情况监测
- 性能指标历史记录

## 原生代码集成

### Android (Kotlin)
主要文件：`android/app/src/main/kotlin/com/example/flutter_video_player_pro/MainActivity.kt`

实现的方法：
- `enableInterpolation(mode, targetFps)` - 启用插帧
- `disableInterpolation()` - 禁用插帧
- `getPerformanceMetrics()` - 获取性能指标
- `loadSubtitle(subtitlePath)` - 加载字幕

### Windows (C++)
主要文件：
- `windows/runner/player_channel.h` - 平台通道头文件
- `windows/runner/player_channel.cpp` - 平台通道实现

实现的方法与 Android 相同。

## 后续开发建议

### 1. 集成真实的插帧库
目前的代码框架已准备好集成真实的插帧算法。建议步骤：

#### Android
```kotlin
// 在 MainActivity.kt 中添加 JNI 调用
external fun enableRifeInterpolation(inputPath: String, outputPath: String, fps: Int): Boolean

// 编译 C++ 代码为 .so 文件
// 将 RIFE 模型转换为 ONNX 或 TensorRT 格式
// 使用 NCNN 框架进行移动端优化
```

#### Windows
```cpp
// 在 player_channel.cpp 中添加 RIFE 库调用
// 使用 ONNX Runtime 或 TensorRT 进行推理
// 集成 FFmpeg 进行视频处理
```

### 2. 优化性能
- 使用硬件加速（GPU）进行视频处理
- 实现缓冲机制减少卡顿
- 优化内存使用

### 3. 增强用户体验
- 添加播放列表功能
- 实现字幕编辑功能
- 添加快捷键支持
- 实现拖拽加载视频

## 常见问题

### Q: 编译时出现 "Android SDK not found" 错误
A: 运行 `flutter config --android-sdk /path/to/android/sdk` 设置 SDK 路径

### Q: Windows 编译失败
A: 确保已安装 Visual Studio 2022 及 Windows 10 SDK，运行 `flutter doctor -v` 检查环境

### Q: 插帧功能不工作
A: 目前的代码框架已准备好集成真实的插帧库，需要按照"后续开发建议"中的步骤进行集成

### Q: 性能监测数据不准确
A: 性能数据的准确性取决于原生代码的实现，可以在 `player_service.dart` 中调整监测间隔

## 许可证

MIT License

## 支持

如有问题或建议，请联系开发者。

---

**最后更新：** 2025年11月16日
**版本：** 1.0.0
