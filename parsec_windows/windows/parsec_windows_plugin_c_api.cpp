#include "include/parsec_windows/parsec_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "parsec_windows_plugin.h"

void ParsecWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  parsec_windows::ParsecWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
