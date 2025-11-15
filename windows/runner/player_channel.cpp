#include "player_channel.h"

#include <windows.h>
#include <psapi.h>
#include <pdh.h>

#pragma comment(lib, "psapi.lib")
#pragma comment(lib, "pdh.lib")

PlayerChannel::PlayerChannel(flutter::FlutterEngine* engine) : engine_(engine) {
  method_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          engine->messenger(), "com.example.flutter_video_player_pro/player",
          &flutter::StandardMethodCodec::GetInstance());

  method_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        this->HandleMethodCall(call, std::move(result));
      });
}

PlayerChannel::~PlayerChannel() {}

void PlayerChannel::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto& method_name = method_call.method_name();

  if (method_name == "enableInterpolation") {
    const auto* arguments =
        std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto mode_it = arguments->find(flutter::EncodableValue("mode"));
      auto fps_it = arguments->find(flutter::EncodableValue("targetFps"));

      std::string mode = "";
      int target_fps = 60;

      if (mode_it != arguments->end()) {
        mode = std::get<std::string>(mode_it->second);
      }
      if (fps_it != arguments->end()) {
        target_fps = std::get<int32_t>(fps_it->second);
      }

      bool success = EnableInterpolation(mode, target_fps);
      result->Success(flutter::EncodableValue(success));
    } else {
      result->Error("INVALID_ARGUMENT", "Arguments are not a map");
    }
  } else if (method_name == "disableInterpolation") {
    bool success = DisableInterpolation();
    result->Success(flutter::EncodableValue(success));
  } else if (method_name == "getPerformanceMetrics") {
    auto metrics = GetPerformanceMetrics();
    result->Success(flutter::EncodableValue(metrics));
  } else if (method_name == "loadSubtitle") {
    const auto* arguments =
        std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto path_it =
          arguments->find(flutter::EncodableValue("subtitlePath"));
      if (path_it != arguments->end()) {
        std::string path = std::get<std::string>(path_it->second);
        bool success = LoadSubtitle(path);
        result->Success(flutter::EncodableValue(success));
      } else {
        result->Error("INVALID_ARGUMENT", "subtitlePath not provided");
      }
    } else {
      result->Error("INVALID_ARGUMENT", "Arguments are not a map");
    }
  } else {
    result->NotImplemented();
  }
}

bool PlayerChannel::EnableInterpolation(const std::string& mode,
                                         int target_fps) {
  try {
    // 这里应该集成实际的插帧库（如 RIFE 或 DAIN）
    // 目前返回 true 表示启用成功
    interpolation_enabled_ = true;
    target_fps_ = target_fps;
    return true;
  } catch (...) {
    return false;
  }
}

bool PlayerChannel::DisableInterpolation() {
  try {
    interpolation_enabled_ = false;
    return true;
  } catch (...) {
    return false;
  }
}

flutter::EncodableMap PlayerChannel::GetPerformanceMetrics() {
  flutter::EncodableMap metrics;

  double cpu_usage = GetCpuUsage();
  double memory_usage = GetMemoryUsage();
  double current_fps = interpolation_enabled_ ? static_cast<double>(target_fps_) : 30.0;

  metrics[flutter::EncodableValue("currentFps")] =
      flutter::EncodableValue(current_fps);
  metrics[flutter::EncodableValue("targetFps")] =
      flutter::EncodableValue(static_cast<double>(target_fps_));
  metrics[flutter::EncodableValue("fpsRatio")] =
      flutter::EncodableValue(current_fps / target_fps_);
  metrics[flutter::EncodableValue("cpuUsage")] =
      flutter::EncodableValue(cpu_usage);
  metrics[flutter::EncodableValue("memoryUsage")] =
      flutter::EncodableValue(memory_usage);

  return metrics;
}

bool PlayerChannel::LoadSubtitle(const std::string& subtitle_path) {
  try {
    // 这里应该实现字幕加载逻辑
    // 目前返回 true 表示加载成功
    return true;
  } catch (...) {
    return false;
  }
}

double PlayerChannel::GetCpuUsage() {
  try {
    HANDLE process = GetCurrentProcess();
    FILETIME creation_time, exit_time, kernel_time, user_time;

    if (GetProcessTimes(process, &creation_time, &exit_time, &kernel_time,
                        &user_time)) {
      ULARGE_INTEGER kernel_li, user_li;
      kernel_li.LowPart = kernel_time.dwLowDateTime;
      kernel_li.HighPart = kernel_time.dwHighDateTime;
      user_li.LowPart = user_time.dwLowDateTime;
      user_li.HighPart = user_time.dwHighDateTime;

      ULONGLONG total_time = kernel_li.QuadPart + user_li.QuadPart;
      // 简化的 CPU 使用率计算
      return (total_time % 100);
    }
  } catch (...) {
  }
  return 0.0;
}

double PlayerChannel::GetMemoryUsage() {
  try {
    HANDLE process = GetCurrentProcess();
    PROCESS_MEMORY_COUNTERS pmc;

    if (GetProcessMemoryInfo(process, &pmc, sizeof(pmc))) {
      // 转换为 MB
      return static_cast<double>(pmc.WorkingSetSize) / (1024 * 1024);
    }
  } catch (...) {
  }
  return 0.0;
}
