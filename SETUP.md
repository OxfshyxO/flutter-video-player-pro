# Flutter Video Player Pro - 项目设置和使用说明

## 项目概述

这是一个完整的 Flutter 跨平台视频播放器项目，包含以下核心功能：

1. **基础播放功能** - 支持多种视频格式的播放、暂停、快进等
2. **外挂字幕** - 支持加载和显示多种格式的字幕文件
3. **实时插帧** - 将视频插帧到 60fps 或更高帧率（需要集成 RIFE/DAIN）
4. **性能监测** - 实时显示 FPS、CPU 占用、内存使用等指标

## 项目文件说明

### Dart 源代码 (`lib/`)

| 文件 | 说明 |
|------|------|
| `main.dart` | 应用入口，配置 Provider 和主题 |
| `models/player_model.dart` | 数据模型：播放器状态、配置、性能指标等 |
| `screens/home_screen.dart` | 主屏幕：文件浏览和选择 |
| `screens/player_screen.dart` | 播放器屏幕：视频播放和控制 |
| `services/player_service.dart` | 播放器核心服务：调用原生方法 |
| `services/file_service.dart` | 文件管理：文件选择和浏览 |
| `services/performance_service.dart` | 性能监测：收集 CPU、内存、FPS 数据 |
| `services/player_provider.dart` | 状态管理：使用 ChangeNotifier 管理应用状态 |
| `widgets/player_controls.dart` | 播放器控制条 UI |
| `widgets/performance_monitor.dart` | 性能监测面板 UI |

### Android 原生代码 (`android/`)

| 文件 | 说明 |
|------|------|
| `MainActivity.kt` | Android 主活动，实现 MethodChannel 通信 |

**关键方法：**
- `enableInterpolation(mode, targetFps)` - 启用视频插帧
- `disableInterpolation()` - 禁用视频插帧
- `getPerformanceMetrics()` - 获取性能指标
- `loadSubtitle(subtitlePath)` - 加载字幕文件

### Windows 原生代码 (`windows/`)

| 文件 | 说明 |
|------|------|
| `runner/player_channel.h` | Windows 平台通道头文件 |
| `runner/player_channel.cpp` | Windows 平台通道实现 |
| `runner/flutter_window.h` | Flutter 窗口头文件（已修改） |
| `runner/flutter_window.cpp` | Flutter 窗口实现（已修改） |

## 依赖包说明

### Flutter 依赖 (`pubspec.yaml`)

```yaml
dependencies:
  video_player: ^2.8.0        # 视频播放核心库
  chewie: ^1.8.0              # 播放器 UI 框架
  file_picker: ^6.1.0         # 文件选择器
  path_provider: ^2.1.0       # 路径获取
  subtitle: ^0.1.4            # 字幕支持
  device_info_plus: ^10.0.0   # 设备信息
  provider: ^6.1.0            # 状态管理
  intl: ^0.19.0               # 国际化
  get_it: ^7.6.0              # 服务定位器
```

## 编译和运行

### 前置条件

1. **安装 Flutter**
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:$(pwd)/flutter/bin"
   ```

2. **验证环境**
   ```bash
   flutter doctor
   ```

### 获取依赖

```bash
cd flutter_video_player_pro
flutter pub get
```

### 开发运行

```bash
# 运行到 Android 设备/模拟器
flutter run

# 运行到 Windows
flutter run -d windows

# 运行到特定设备
flutter run -d <device_id>
```

### 编译发布

#### Android APK
```bash
# Debug 版本
flutter build apk --debug

# Release 版本
flutter build apk --release

# 输出位置：build/app/outputs/flutter-apk/
```

#### Windows EXE
```bash
# Debug 版本
flutter build windows --debug

# Release 版本
flutter build windows --release

# 输出位置：build/windows/x64/runner/Release/
```

## 功能使用指南

### 1. 播放视频

1. 启动应用
2. 点击 "Select Video" 按钮
3. 选择要播放的视频文件
4. 点击 "Play" 开始播放

### 2. 播放控制

在播放器屏幕上，可以进行以下操作：

- **点击屏幕** - 显示/隐藏控制条
- **播放/暂停** - 点击播放按钮
- **停止** - 点击停止按钮
- **快进/快退** - 拖动进度条
- **调整音量** - 使用设备音量键

### 3. 启用插帧功能

1. 在播放器屏幕上，点击速度图标（⚡）
2. 选择目标帧率（30、60、120、144 fps）
3. 插帧功能启用后，图标会变为绿色

### 4. 查看性能监测

1. 在播放器屏幕上，点击性能监测按钮（📊）
2. 右上角会显示实时性能数据：
   - **FPS** - 当前帧率 / 目标帧率
   - **Ratio** - 帧率比率
   - **CPU** - CPU 占用率
   - **Memory** - 内存使用量

### 5. 加载字幕

1. 在播放器屏幕上，点击字幕按钮（📝）
2. 选择 "Load Subtitle"
3. 选择字幕文件
4. 字幕将自动显示

## 原生代码集成说明

### Android 集成

**文件位置：** `android/app/src/main/kotlin/com/example/flutter_video_player_pro/MainActivity.kt`

**集成步骤：**

1. 在 `MainActivity` 中创建 MethodChannel
2. 实现各个方法的处理逻辑
3. 通过 JNI 调用 C++ 代码（如需要）
4. 返回结果给 Dart 层

**示例：** 启用插帧功能
```kotlin
"enableInterpolation" -> {
    val mode = call.argument<String>("mode")
    val targetFps = call.argument<Int>("targetFps") ?: 60
    val success = enableInterpolation(mode, targetFps)
    result(success)
}
```

### Windows 集成

**文件位置：** `windows/runner/player_channel.cpp`

**集成步骤：**

1. 创建 MethodChannel 并注册处理函数
2. 在处理函数中实现各个方法
3. 使用 Windows API 获取系统信息
4. 返回结果给 Dart 层

**示例：** 获取性能指标
```cpp
flutter::EncodableMap metrics;
metrics[flutter::EncodableValue("currentFps")] = 
    flutter::EncodableValue(current_fps);
result->Success(flutter::EncodableValue(metrics));
```

## 集成真实的插帧库

### 步骤 1：获取 RIFE 模型

1. 从 GitHub 下载 RIFE 模型：https://github.com/hzwer/ECCV2022-RIFE
2. 转换模型格式（ONNX 或 TensorRT）

### 步骤 2：Android 集成

1. 使用 NCNN 框架编译 RIFE 模型
2. 创建 JNI 接口调用 C++ 代码
3. 在 `MainActivity.kt` 中调用 JNI 方法

### 步骤 3：Windows 集成

1. 使用 ONNX Runtime 或 TensorRT
2. 在 `player_channel.cpp` 中集成推理代码
3. 处理视频帧并返回插帧后的结果

## 常见问题解答

**Q: 如何修改应用名称？**
A: 编辑 `pubspec.yaml` 中的 `name` 字段，然后运行 `flutter pub get`

**Q: 如何添加应用图标？**
A: 使用 `flutter_launcher_icons` 包，参考官方文档

**Q: 如何支持更多视频格式？**
A: 修改 `file_service.dart` 中的 `videoExtensions` 列表

**Q: 性能监测数据不准确怎么办？**
A: 检查原生代码中的性能数据收集逻辑，可能需要调整采样间隔

**Q: 如何在真机上测试？**
A: 
- Android：连接设备，运行 `flutter run`
- Windows：在 Windows 机器上运行 `flutter run -d windows`

## 项目扩展建议

1. **添加播放列表** - 支持连续播放多个视频
2. **实现快捷键** - 添加键盘快捷键支持
3. **字幕编辑** - 支持字幕位置和样式调整
4. **视频转码** - 集成 FFmpeg 进行视频格式转换
5. **云存储支持** - 支持从云端加载视频
6. **录制功能** - 支持录制播放过程
7. **截图功能** - 支持视频截图

## 许可证

MIT License

## 联系方式

如有问题或建议，请提交 Issue 或 Pull Request。

---

**最后更新：** 2025年11月16日
