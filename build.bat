@echo off
REM Flutter Video Player Pro - Windows 一键编译脚本
REM 该脚本会编译 APK 和 EXE 文件

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Flutter Video Player Pro - Build Script
echo ========================================
echo.

REM 检查 Flutter 是否安装
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter 未安装或不在 PATH 中
    echo 请先安装 Flutter: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo [INFO] Flutter 版本信息：
flutter --version
echo.

REM 检查项目依赖
echo [INFO] 获取项目依赖...
call flutter pub get
if errorlevel 1 (
    echo [ERROR] 获取依赖失败
    pause
    exit /b 1
)
echo [OK] 依赖获取成功
echo.

REM 菜单选择
:menu
echo 请选择要编译的平台：
echo 1. Android APK (Debug)
echo 2. Android APK (Release)
echo 3. Windows EXE (Debug)
echo 4. Windows EXE (Release)
echo 5. 编译所有 (APK Release + EXE Release)
echo 6. 退出
echo.
set /p choice="请输入选择 (1-6): "

if "%choice%"=="1" goto build_apk_debug
if "%choice%"=="2" goto build_apk_release
if "%choice%"=="3" goto build_exe_debug
if "%choice%"=="4" goto build_exe_release
if "%choice%"=="5" goto build_all
if "%choice%"=="6" goto end
goto menu

:build_apk_debug
echo.
echo [INFO] 开始编译 Android APK (Debug)...
call flutter build apk --debug
if errorlevel 1 (
    echo [ERROR] APK 编译失败
    pause
    exit /b 1
)
echo [OK] APK (Debug) 编译成功
echo 输出文件: build\app\outputs\flutter-apk\app-debug.apk
pause
goto menu

:build_apk_release
echo.
echo [INFO] 开始编译 Android APK (Release)...
call flutter build apk --release
if errorlevel 1 (
    echo [ERROR] APK 编译失败
    pause
    exit /b 1
)
echo [OK] APK (Release) 编译成功
echo 输出文件: build\app\outputs\flutter-apk\app-release.apk
pause
goto menu

:build_exe_debug
echo.
echo [INFO] 开始编译 Windows EXE (Debug)...
call flutter build windows --debug
if errorlevel 1 (
    echo [ERROR] EXE 编译失败
    pause
    exit /b 1
)
echo [OK] EXE (Debug) 编译成功
echo 输出文件: build\windows\x64\runner\Debug\flutter_video_player_pro.exe
pause
goto menu

:build_exe_release
echo.
echo [INFO] 开始编译 Windows EXE (Release)...
call flutter build windows --release
if errorlevel 1 (
    echo [ERROR] EXE 编译失败
    pause
    exit /b 1
)
echo [OK] EXE (Release) 编译成功
echo 输出文件: build\windows\x64\runner\Release\flutter_video_player_pro.exe
pause
goto menu

:build_all
echo.
echo [INFO] 开始编译所有平台...
echo.

echo [1/2] 编译 Android APK (Release)...
call flutter build apk --release
if errorlevel 1 (
    echo [ERROR] APK 编译失败
    pause
    exit /b 1
)
echo [OK] APK 编译成功
echo.

echo [2/2] 编译 Windows EXE (Release)...
call flutter build windows --release
if errorlevel 1 (
    echo [ERROR] EXE 编译失败
    pause
    exit /b 1
)
echo [OK] EXE 编译成功
echo.

echo ========================================
echo [OK] 所有平台编译完成！
echo ========================================
echo.
echo 输出文件：
echo - APK: build\app\outputs\flutter-apk\app-release.apk
echo - EXE: build\windows\x64\runner\Release\flutter_video_player_pro.exe
echo.
pause
goto menu

:end
echo.
echo 退出编译脚本
echo.
endlocal
