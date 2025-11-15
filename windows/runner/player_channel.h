#ifndef FLUTTER_PLUGIN_PLAYER_CHANNEL_H_
#define FLUTTER_PLUGIN_PLAYER_CHANNEL_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_engine.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <string>

class PlayerChannel {
 public:
  explicit PlayerChannel(flutter::FlutterEngine* engine);
  virtual ~PlayerChannel();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  bool EnableInterpolation(const std::string& mode, int target_fps);
  bool DisableInterpolation();
  flutter::EncodableMap GetPerformanceMetrics();
  bool LoadSubtitle(const std::string& subtitle_path);

  double GetCpuUsage();
  double GetMemoryUsage();

  flutter::FlutterEngine* engine_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      method_channel_;

  bool interpolation_enabled_ = false;
  int target_fps_ = 60;
};

#endif  // FLUTTER_PLUGIN_PLAYER_CHANNEL_H_
