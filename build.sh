#!/bin/bash

# Flutter Video Player Pro - Linux/Mac 一键编译脚本
# 该脚本会编译 APK 和 EXE 文件

set -e

echo ""
echo "========================================"
echo "Flutter Video Player Pro - Build Script"
echo "========================================"
echo ""

# 检查 Flutter 是否安装
if ! command -v flutter &> /dev/null; then
    echo "[ERROR] Flutter 未安装或不在 PATH 中"
    echo "请先安装 Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "[INFO] Flutter 版本信息："
flutter --version
echo ""

# 检查项目依赖
echo "[INFO] 获取项目依赖..."
flutter pub get
echo "[OK] 依赖获取成功"
echo ""

# 菜单选择
show_menu() {
    echo "请选择要编译的平台："
    echo "1. Android APK (Debug)"
    echo "2. Android APK (Release)"
    echo "3. Windows EXE (Debug)"
    echo "4. Windows EXE (Release)"
    echo "5. 编译所有 (APK Release + EXE Release)"
    echo "6. 退出"
    echo ""
}

build_apk_debug() {
    echo ""
    echo "[INFO] 开始编译 Android APK (Debug)..."
    flutter build apk --debug
    echo "[OK] APK (Debug) 编译成功"
    echo "输出文件: build/app/outputs/flutter-apk/app-debug.apk"
    echo ""
}

build_apk_release() {
    echo ""
    echo "[INFO] 开始编译 Android APK (Release)..."
    flutter build apk --release
    echo "[OK] APK (Release) 编译成功"
    echo "输出文件: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
}

build_exe_debug() {
    echo ""
    echo "[INFO] 开始编译 Windows EXE (Debug)..."
    flutter build windows --debug
    echo "[OK] EXE (Debug) 编译成功"
    echo "输出文件: build/windows/x64/runner/Debug/flutter_video_player_pro.exe"
    echo ""
}

build_exe_release() {
    echo ""
    echo "[INFO] 开始编译 Windows EXE (Release)..."
    flutter build windows --release
    echo "[OK] EXE (Release) 编译成功"
    echo "输出文件: build/windows/x64/runner/Release/flutter_video_player_pro.exe"
    echo ""
}

build_all() {
    echo ""
    echo "[INFO] 开始编译所有平台..."
    echo ""

    echo "[1/2] 编译 Android APK (Release)..."
    flutter build apk --release
    echo "[OK] APK 编译成功"
    echo ""

    echo "[2/2] 编译 Windows EXE (Release)..."
    flutter build windows --release
    echo "[OK] EXE 编译成功"
    echo ""

    echo "========================================"
    echo "[OK] 所有平台编译完成！"
    echo "========================================"
    echo ""
    echo "输出文件："
    echo "- APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "- EXE: build/windows/x64/runner/Release/flutter_video_player_pro.exe"
    echo ""
}

# 主循环
while true; do
    show_menu
    read -p "请输入选择 (1-6): " choice
    
    case $choice in
        1)
            build_apk_debug
            ;;
        2)
            build_apk_release
            ;;
        3)
            build_exe_debug
            ;;
        4)
            build_exe_release
            ;;
        5)
            build_all
            ;;
        6)
            echo ""
            echo "退出编译脚本"
            echo ""
            exit 0
            ;;
        *)
            echo "无效选择，请重试"
            echo ""
            ;;
    esac
done
