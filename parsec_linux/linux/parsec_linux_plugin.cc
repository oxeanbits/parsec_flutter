#include "include/parsec_linux/parsec_linux_plugin.h"
#include "mpParser.h"
#include "mpDefines.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include <string>
#include <iostream>
#include "equationsParser.h"

using namespace std;
using namespace mup;
using namespace EquationsParser;

#define PARSEC_LINUX_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), parsec_linux_plugin_get_type(), \
                              ParsecLinuxPlugin))

struct _ParsecLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(ParsecLinuxPlugin, parsec_linux_plugin, g_object_get_type())


/**
 * @text_value: a pointer to the FlValue of the input text
 * @method_call: a pointer to the FlMethodCall object
 *
 * This function checks if the input text is valid, i.e. not null and of type string.
 * If the input is invalid, it sends a not implemented response and sets the error to null.
 * Otherwise, it returns true.
 */
static bool parsec_linux_plugin_check_valid_input(FlMethodCall* method_call, FlValue *text_value) {
    // Check if argument value is either null or string
    if (text_value == nullptr || fl_value_get_type(text_value) != FL_VALUE_TYPE_STRING) {
        // Return error
        g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
        // Create error, in this case null
        g_autoptr(GError) error = nullptr;

        // Send response back to dart
        fl_method_call_respond(method_call, response, &error);
        return false;
    }
    return true;
}

/**

@brief Handles the nativeEval method call.

Extracts the equation passed as an argument, performs the calculation and sends the result back to
the Dart code.

@param[in] method_call The FlMethodCall object representing the method call.
@param[in] text_value The FlValue object containing the "equation" argument passed by the Dart code.
*/
static void parsec_linux_plugin_handle_native_eval(FlMethodCall* method_call) {
    // Get Dart arguments
    FlValue* args = fl_method_call_get_args(method_call);
    // Fetch string value named "equation"
    FlValue *text_value = fl_value_lookup_string(args, "equation");

    if (!parsec_linux_plugin_check_valid_input(method_call, text_value)) return;

    string formula = fl_value_get_string(text_value);
    string ans = CalcJson(formula);

    g_autofree gchar *answer = g_strdup_printf("%s", ans.c_str());
    g_autoptr(FlValue) result = fl_value_new_string(answer);
    g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    fl_method_call_respond(method_call, response, nullptr);
}

/**
 * @brief Handles method calls from the dart side of the plugin
 *
 * @param self Pointer to the ParsecLinuxPlugin object
 * @param method_call FlMethodCall object containing the method call information
 *
 * This function handles method calls from the dart side of the plugin. It checks if the method call
 * is "nativeEval" and if so, it calls the `handle_native_eval` function passing it the
 * `method_call` object.
 */
static void parsec_linux_plugin_handle_method_call(
    ParsecLinuxPlugin* self,
    FlMethodCall* method_call) {

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "nativeEval") == 0) {
    parsec_linux_plugin_handle_native_eval(method_call);
  } else {
    g_autoptr(FlMethodResponse) response = nullptr;
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    fl_method_call_respond(method_call, response, nullptr);
  }
}

/**
 * Clean up any resources held by the GObject.
 * This function is called by the flutter linux plugin system during finalization.
 */
static void parsec_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(parsec_linux_plugin_parent_class)->dispose(object);
}

/**
 * Initialize the class for the ParsecLinuxPlugin.
 */
static void parsec_linux_plugin_class_init(ParsecLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = parsec_linux_plugin_dispose;
}

/**
 * Initialize an instance of the ParsecLinuxPlugin.
 */
static void parsec_linux_plugin_init(ParsecLinuxPlugin* self) {}

/**
 * @channel: A FlMethodChannel
 * @method_call: A FlMethodCall
 * @user_data: user data passed when setting the call handler
 *
 * Callback function that is triggered when a method call is received on the flutter method channel.
 * This function will handle the method call by calling parsec_linux_plugin_handle_method_call.
 */
static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  ParsecLinuxPlugin* plugin = PARSEC_LINUX_PLUGIN(user_data);
  parsec_linux_plugin_handle_method_call(plugin, method_call);
}

/**
 * @registrar: A FlPluginRegistrar
 *
 * Responsible to register the ParsecLinuxPlugin in the flutter plugin ecosystem.
 * This will create a new instance of the plugin, set up a method channel,
 * and set the method call handler to the callback method_call_cb.
 */
void parsec_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  ParsecLinuxPlugin* plugin = PARSEC_LINUX_PLUGIN(
      g_object_new(parsec_linux_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "parsec_linux",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
