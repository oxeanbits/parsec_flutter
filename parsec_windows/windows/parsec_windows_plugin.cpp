#include "parsec_windows_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "mpParser.h"
#include "mpDefines.h"

#include <memory>
#include <sstream>

#include <cstring>
#include <string>
#include <iostream>

using namespace std;
using namespace mup;

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

void replaceAll(std::string& source, const std::string& from, const std::string& to) {
    std::string newString;
    newString.reserve(source.length());  // avoids a few memory allocations

    std::string::size_type lastPos = 0;
    std::string::size_type findPos;

    while(std::string::npos != (findPos = source.find(from, lastPos)))
    {
        newString.append(source, lastPos, findPos - lastPos);
        newString += to;
        lastPos = findPos + from.length();
    }

    // Care for the rest after last occurrence
    newString += source.substr(lastPos);

    source.swap(newString);
}

std::string CalcJson(std::string& input) {
    ParserX parser(pckALL_NON_COMPLEX);

    Value ans;
    parser.DefineVar(_T("ans"), Variable(&ans));

    stringstream_type ss;

    ss << _T("{");

    try
    {
        parser.SetExpr(input);
        ans = parser.Eval();

        std::string ansString = ans.AsString();

        replaceAll(ansString, "\"", "\\\"");

        ss << _T("\"val\": \"") << ansString << _T("\"");
        ss << _T(",\"type\": \"") << ans.GetType() << _T("\"");
    }
    catch(ParserError &e)
    {
        if (e.GetPos() != -1) {
            string_type error = e.GetMsg();
            ss << _T("\"error\": \"") << error << _T("\"");
        }
    }
    catch(std::runtime_error &)
    {
        string_type error = "Error: Runtime error";
        ss << _T("\"error\": \"") << error << _T("\"");
    }

    ss << _T("}");

    return ss.str();
}


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
