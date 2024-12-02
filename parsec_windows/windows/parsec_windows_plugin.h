#ifndef FLUTTER_PLUGIN_PARSEC_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_PARSEC_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace parsec_windows {

class ParsecWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ParsecWindowsPlugin();

  virtual ~ParsecWindowsPlugin();

  // Disallow copy and assign.
  ParsecWindowsPlugin(const ParsecWindowsPlugin&) = delete;
  ParsecWindowsPlugin& operator=(const ParsecWindowsPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace parsec_windows

#endif  // FLUTTER_PLUGIN_PARSEC_WINDOWS_PLUGIN_H_
