# 快速开始 - 使用 GitHub Actions 编译 APK

本指南将帮助您快速使用 GitHub Actions 编译 Android APK 文件。

## ⚡ 5 分钟快速开始

### 步骤 1：创建 GitHub 仓库

1. 访问 [GitHub](https://github.com)
2. 点击右上角 "+" → "New repository"
3. 输入仓库名称（如 `flutter-video-player-pro`）
4. 选择 "Public" 或 "Private"
5. 点击 "Create repository"

### 步骤 2：上传项目

```bash
# 进入项目目录
cd flutter_video_player_pro

# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Initial commit"

# 添加远程仓库（替换 YOUR_USERNAME 和 YOUR_REPO）
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 步骤 3：查看编译结果

1. 访问您的 GitHub 仓库
2. 点击 "Actions" 选项卡
3. 等待工作流完成（通常需要 15-30 分钟）
4. 点击工作流运行，查看详细日志

### 步骤 4：下载 APK

1. 在工作流运行页面，向下滚动到 "Artifacts" 部分
2. 下载 `app-release` 文件（这是编译好的 APK）
3. 将 APK 安装到您的 Android 设备

## 📱 安装 APK 到 Android 设备

### 方式 1：使用 ADB（推荐）

```bash
# 连接 Android 设备
adb devices

# 安装 APK
adb install app-release.apk
```

### 方式 2：直接传输

1. 将 APK 文件复制到 Android 设备
2. 使用文件管理器打开 APK 文件
3. 点击安装

### 方式 3：使用 Android Studio

1. 打开 Android Studio
2. 点击 "File" → "Open"
3. 选择 APK 文件
4. 点击 "Install"

## 🔄 自动编译流程

工作流会在以下情况自动编译：

1. **推送到 main 分支** - 每次推送都会自动编译
2. **创建 Pull Request** - 每个 PR 都会自动编译
3. **手动触发** - 在 Actions 页面手动运行

## 📦 编译产物

工作流会生成以下文件：

| 文件 | 说明 |
|------|------|
| `app-debug.apk` | Debug 版本（用于开发和测试） |
| `app-release.apk` | Release 版本（用于生产环境） |

**推荐使用 Release 版本**，因为它经过优化和签名。

## 🔖 创建发布版本

要创建官方发布版本，只需推送一个标签：

```bash
# 创建标签
git tag v1.0.0

# 推送标签
git push origin v1.0.0
```

工作流会自动：
1. 编译 APK
2. 创建 GitHub Release
3. 上传 APK 到 Release

## 🐛 常见问题

### Q: 工作流运行失败
A: 查看工作流日志：
1. 点击 Actions
2. 点击失败的工作流运行
3. 查看详细日志找出错误原因

### Q: 编译时间太长
A: 第一次编译会比较慢（15-30 分钟），后续编译会快一些。

### Q: 如何修改编译配置
A: 编辑 `.github/workflows/build-apk.yml` 文件，修改后推送即可。

### Q: APK 无法安装
A: 确保：
1. Android 设备已启用"未知来源"安装
2. Android 版本不低于 API 21（Android 5.0）
3. APK 是 Release 版本

## 📊 工作流状态

在 GitHub 仓库主页，您可以看到最新的工作流状态：

- ✅ **成功** - 编译完成，可以下载
- ❌ **失败** - 编译出错，查看日志
- ⏳ **运行中** - 正在编译，请等待

## 💡 提示

1. **定期更新** - 定期推送更新，保持最新版本
2. **使用标签** - 为重要版本创建标签，方便管理
3. **备份 APK** - 重要版本的 APK 应该备份
4. **测试 APK** - 在发布前在真机上测试

## 🔐 安全建议

1. 不要在代码中硬编码敏感信息
2. 使用 GitHub Secrets 存储 API 密钥等
3. 定期审查工作流日志
4. 只在信任的分支上启用自动编译

## 📚 更多资源

- [完整的 GitHub Actions 指南](GITHUB_ACTIONS_GUIDE.md)
- [项目设置说明](SETUP.md)
- [编译指南](BUILD_GUIDE.md)

## 🎯 下一步

1. ✅ 上传项目到 GitHub
2. ✅ 等待工作流完成
3. ✅ 下载 APK 文件
4. ✅ 安装到 Android 设备
5. ✅ 测试应用功能

---

**需要帮助？** 查看完整的 [GitHub Actions 指南](GITHUB_ACTIONS_GUIDE.md)

**最后更新：** 2025年11月16日
