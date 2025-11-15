# GitHub Actions 自动编译指南

本项目包含 GitHub Actions 工作流配置，可以自动编译 Android APK 和 Windows EXE 文件。

## 📋 前置条件

1. **GitHub 账户** - 免费账户即可
2. **项目上传到 GitHub** - 将项目推送到您的 GitHub 仓库

## 🚀 快速开始

### 步骤 1：上传项目到 GitHub

```bash
# 初始化 Git 仓库（如果还没有的话）
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Initial commit: Flutter Video Player Pro"

# 添加远程仓库（替换 YOUR_USERNAME 和 YOUR_REPO）
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 步骤 2：查看工作流

1. 访问您的 GitHub 仓库
2. 点击 "Actions" 选项卡
3. 您应该看到两个工作流：
   - **Build Android APK** - 编译 Android APK
   - **Build Windows EXE** - 编译 Windows EXE

### 步骤 3：运行工作流

#### 方式 1：自动运行（推荐）
工作流会在以下情况自动运行：
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request 到 `main` 或 `develop` 分支

#### 方式 2：手动运行
1. 在 GitHub 仓库中，点击 "Actions"
2. 选择要运行的工作流（"Build Android APK" 或 "Build Windows EXE"）
3. 点击 "Run workflow" 按钮
4. 选择分支，点击 "Run workflow"

### 步骤 4：下载编译结果

#### 查看编译日志
1. 在 "Actions" 选项卡中，点击最新的工作流运行
2. 您可以看到实时的编译日志

#### 下载编译产物
1. 工作流完成后，点击工作流运行
2. 在 "Artifacts" 部分，您可以看到编译的文件：
   - `app-debug` - Debug 版本 APK
   - `app-release` - Release 版本 APK
   - `flutter_video_player_pro-debug` - Debug 版本 EXE
   - `flutter_video_player_pro-release` - Release 版本 EXE
3. 点击下载

## 📦 工作流详解

### Build Android APK 工作流 (.github/workflows/build-apk.yml)

**触发条件：**
- 推送到 `main` 或 `develop` 分支
- Pull Request 到 `main` 或 `develop` 分支
- 手动触发（workflow_dispatch）

**执行步骤：**
1. 检出代码
2. 设置 Java 环境（Temurin JDK 11）
3. 安装 Flutter 3.38.1
4. 获取项目依赖
5. 编译 Debug APK
6. 编译 Release APK
7. 上传编译产物
8. 如果是标签推送，创建 Release 并上传 APK

**输出文件：**
- `build/app/outputs/flutter-apk/app-debug.apk`
- `build/app/outputs/flutter-apk/app-release.apk`

### Build Windows EXE 工作流 (.github/workflows/build-windows.yml)

**触发条件：**
- 推送到 `main` 或 `develop` 分支
- Pull Request 到 `main` 或 `develop` 分支
- 手动触发（workflow_dispatch）

**执行步骤：**
1. 检出代码
2. 安装 Flutter 3.38.1
3. 获取项目依赖
4. 编译 Debug EXE
5. 编译 Release EXE
6. 上传编译产物
7. 如果是标签推送，创建 Release 并上传 EXE

**输出文件：**
- `build/windows/x64/runner/Debug/flutter_video_player_pro.exe`
- `build/windows/x64/runner/Release/flutter_video_player_pro.exe`

## 🔖 创建发布版本

### 自动创建发布

当您推送一个标签时，GitHub Actions 会自动创建一个 Release 并上传编译的文件：

```bash
# 创建标签
git tag v1.0.0

# 推送标签到 GitHub
git push origin v1.0.0
```

工作流会自动：
1. 编译 APK 和 EXE
2. 创建 GitHub Release
3. 上传编译的文件到 Release

### 手动创建发布

您也可以在 GitHub 网页界面手动创建 Release：

1. 在仓库中，点击 "Releases"
2. 点击 "Create a new release"
3. 输入版本号（如 v1.0.0）
4. 输入发布说明
5. 上传编译的 APK 和 EXE 文件
6. 点击 "Publish release"

## 📊 工作流状态

### 查看工作流状态

在 GitHub 仓库的主页上，您可以看到最新的工作流状态：
- ✅ 成功（绿色）
- ❌ 失败（红色）
- ⏳ 运行中（黄色）

### 查看详细日志

点击工作流运行，可以看到详细的编译日志，包括：
- 每个步骤的执行时间
- 编译输出
- 错误信息（如果有）

## 🔧 自定义工作流

### 修改 Flutter 版本

编辑 `.github/workflows/build-apk.yml` 或 `.github/workflows/build-windows.yml`，修改：

```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.38.1'  # 修改这里
    channel: 'stable'
```

### 修改触发条件

编辑工作流文件的 `on` 部分：

```yaml
on:
  push:
    branches: [ main, develop ]  # 修改分支
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:
```

### 添加环境变量

在工作流中添加环境变量：

```yaml
env:
  FLUTTER_VERSION: '3.38.1'
  JAVA_VERSION: '11'
```

## 🐛 常见问题

### Q: 工作流失败，显示 "Flutter not found"
A: 确保 `subosito/flutter-action@v2` 步骤在其他步骤之前执行。

### Q: APK 编译失败，显示 "Android SDK not found"
A: 这通常是因为 Flutter 的 Android SDK 路径配置问题。工作流会自动下载必要的工具。

### Q: 编译时间很长
A: 第一次编译会比较慢（15-30 分钟），因为需要下载 Android SDK、NDK 等工具。后续编译会快一些。

### Q: 如何只编译 Release 版本？
A: 编辑工作流文件，删除 Debug 编译步骤。

### Q: 如何在编译前运行测试？
A: 在工作流中添加 `flutter test` 步骤。

## 📈 工作流优化

### 缓存依赖

为了加快编译速度，可以添加缓存步骤：

```yaml
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: ~/.flutter
    key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
    restore-keys: |
      ${{ runner.os }}-flutter-
```

### 并行编译

可以创建一个主工作流，同时运行 Android 和 Windows 编译：

```yaml
jobs:
  build-android:
    runs-on: ubuntu-latest
    # ...
  
  build-windows:
    runs-on: windows-latest
    # ...
```

## 🔐 安全考虑

### 保护敏感信息

如果您的项目中有敏感信息（如 API 密钥），请：

1. 使用 GitHub Secrets 存储敏感信息
2. 在工作流中使用 `${{ secrets.SECRET_NAME }}`
3. 不要在代码中硬编码敏感信息

### 限制工作流权限

在工作流文件中添加权限限制：

```yaml
permissions:
  contents: read
  actions: read
```

## 📚 更多资源

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [Flutter 官方 CI/CD 指南](https://flutter.dev/docs/deployment/cd)
- [subosito/flutter-action](https://github.com/subosito/flutter-action)

## 💡 提示

1. **定期更新 Flutter 版本** - 在工作流中更新 Flutter 版本以获得最新功能和修复
2. **使用 Release 版本** - 对于生产环境，始终使用 Release 版本编译
3. **监控编译时间** - 如果编译时间过长，考虑优化依赖或代码
4. **备份编译产物** - 重要的发布版本应该备份编译产物

---

**最后更新：** 2025年11月16日
