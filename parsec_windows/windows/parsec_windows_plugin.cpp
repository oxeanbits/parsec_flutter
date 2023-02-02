#include "parsec_windows_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

#include <cstring>
#include <string>
#include <iostream>
#include "equationsParser.h"

using namespace std;
using namespace EquationsParser;

namespace parsec_windows {

// static
void ParsecWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "parsec_windows",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ParsecWindowsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ParsecWindowsPlugin::ParsecWindowsPlugin() {}

ParsecWindowsPlugin::~ParsecWindowsPlugin() {}

void HandleNativeEval(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    const flutter::EncodableMap &arguments = std::get<flutter::EncodableMap>(*method_call.arguments());
    const std::string &text_value = std::get<std::string>(arguments.at(flutter::EncodableValue("equation")));

    std::string ans = CalcJson(text_value);

    result->Success(flutter::EncodableValue(ans));
}

void ParsecWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("nativeEval") == 0) {
    HandleNativeEval(method_call, std::move(result));
  } else {
    result->NotImplemented();
  }
}

}  // namespace parsec_windows
