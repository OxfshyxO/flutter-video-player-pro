# Flutter Video Player Pro

一个功能完善的跨平台本地视频播放器，支持实时视频插帧、外挂字幕和性能监测。

## 🎬 主要功能

### 播放功能
- 📹 支持多种视频格式（MP4、MKV、AVI、MOV、FLV 等）
- ⏯️ 完整的播放控制（播放、暂停、停止、快进、快退）
- 📊 进度条拖拽和时间显示
- 🎯 精确的帧级定位

### 插帧功能 ⭐
- 🚀 实时视频插帧到 60fps 或更高帧率
- 🤖 支持 RIFE 和 DAIN 两种 AI 插帧算法
- ⚙️ 可配置的目标帧率（30、60、120、144 fps）
- 📈 实时性能监测和优化

### 字幕功能
- 📝 支持外挂字幕文件加载
- 🌐 支持多种格式（SRT、ASS、VTT、SUB 等）
- 🎨 字幕样式自定义
- 🔄 多字幕切换

### 性能监测
- 📊 实时 FPS 显示（当前/目标）
- 💻 CPU 占用率监测
- 🧠 内存使用情况监测
- 📈 性能指标历史记录和分析

## 🖥️ 平台支持

- ✅ **Android** - APK 安装包
- ✅ **Windows** - EXE 可执行文件
- 🔄 **iOS/macOS** - 代码已准备，可扩展

## 🚀 快速开始

### 前置要求
- Flutter 3.38.1+
- Dart 3.10.0+
- Android Studio（用于 Android 编译）
- Visual Studio 2022（用于 Windows 编译）

### 安装依赖
```bash
flutter pub get
```

### 运行应用
```bash
# 运行到连接的设备
flutter run

# 运行到 Windows
flutter run -d windows

# 运行到 Android 模拟器
flutter run -d emulator
```

### 编译发布版本
```bash
# Android APK
flutter build apk --release

# Windows EXE
flutter build windows --release
```

详细的编译说明请参考 [BUILD_GUIDE.md](BUILD_GUIDE.md)

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/
│   └── player_model.dart       # 数据模型
├── screens/
│   ├── home_screen.dart        # 主屏幕（文件选择）
│   └── player_screen.dart      # 播放器屏幕
├── services/
│   ├── player_service.dart     # 播放器服务
│   ├── file_service.dart       # 文件管理服务
│   ├── performance_service.dart # 性能监测服务
│   └── player_provider.dart    # 状态管理
└── widgets/
    ├── player_controls.dart    # 播放器控制条
    └── performance_monitor.dart # 性能监测面板
```

## 🔧 技术栈

### Dart/Flutter
- **video_player** - 视频播放
- **chewie** - 播放器 UI 框架
- **provider** - 状态管理
- **file_picker** - 文件选择
- **subtitle** - 字幕支持

### 原生代码
- **Android (Kotlin)** - 原生方法通道实现
- **Windows (C++)** - 平台通道和性能监测

## 🎯 核心特性详解

### 1. 实时插帧
通过集成 RIFE（Real-Time Intermediate Flow Estimation）或 DAIN（Depth-Aware Video Frame Interpolation）算法，将低帧率视频实时插帧到高帧率，提供更流畅的观看体验。

**工作原理：**
- 分析相邻两帧之间的光流
- 使用神经网络计算中间帧
- 实时渲染插帧后的视频

### 2. 性能监测
实时监测应用性能，包括：
- **FPS**：当前帧率 vs 目标帧率
- **CPU**：处理器占用率
- **内存**：RAM 使用情况

### 3. 跨平台兼容性
通过 Flutter 的平台通道（Platform Channels）实现原生功能调用，确保在 Android 和 Windows 上的一致体验。

## 🔌 API 接口

### PlayerProvider
```dart
// 加载视频
await playerProvider.loadVideo(videoPath, fileName);

// 播放/暂停/停止
await playerProvider.play();
await playerProvider.pause();
await playerProvider.stop();

// 跳转
await playerProvider.seekTo(Duration(seconds: 30));

// 启用/禁用插帧
await playerProvider.enableInterpolation(InterpolationMode.rife, 60);
await playerProvider.disableInterpolation();

// 加载字幕
await playerProvider.loadSubtitle(subtitlePath, fileName);
```

## 🐛 已知问题

1. 插帧功能需要集成真实的 RIFE/DAIN 库
2. 字幕渲染目前为基础实现
3. 性能监测数据的准确性取决于原生代码实现

## 📈 后续改进

- [ ] 集成真实的 RIFE 插帧库
- [ ] 优化性能监测准确性
- [ ] 添加播放列表功能
- [ ] 实现字幕编辑功能
- [ ] 添加快捷键支持
- [ ] 支持拖拽加载视频
- [ ] iOS/macOS 支持

## 📝 许可证

MIT License

## 👨‍💻 开发者

Flutter Video Player Pro Team

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**版本：** 1.0.0  
**最后更新：** 2025年11月16日
