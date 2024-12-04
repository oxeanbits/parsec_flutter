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
#include <Windows.h>

std::wstring ConvertToWString(const std::string &str) {
    if (str.empty()) {
        return std::wstring();
    }

    int size_needed = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, nullptr, 0);
    if (size_needed <= 0) {
        throw std::runtime_error("Failed to convert string to wstring");
    }

    std::wstring wstr(size_needed - 1, L'\0'); // Exclude null terminator
    MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, &wstr[0], size_needed);
    return wstr;
}

std::string ConvertFromWString(const std::wstring &wstr) {
    if (wstr.empty()) {
        return std::string();
    }

    int size_needed = WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), -1, nullptr, 0, nullptr, nullptr);
    if (size_needed <= 0) {
        throw std::runtime_error("Failed to convert wstring to string");
    }

    std::string str(size_needed - 1, '\0'); // Exclude null terminator
    WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), -1, &str[0], size_needed, nullptr, nullptr);
    return str;
}

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

void HandleNativeEval(const flutter::MethodCall<flutter::EncodableValue> &method_call,
                      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    const flutter::EncodableMap &arguments = std::get<flutter::EncodableMap>(*method_call.arguments());
    const std::string &text_value = std::get<std::string>(arguments.at(flutter::EncodableValue("equation")));

    mup::string_type mup_text_value = ConvertToWString(text_value);

    mup::string_type ans = CalcJson(mup_text_value);

    std::string ans_str = ConvertFromWString(ans);

    result->Success(flutter::EncodableValue(ans_str));
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
