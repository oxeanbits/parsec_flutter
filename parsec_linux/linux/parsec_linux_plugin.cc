#include "include/parsec_linux/parsec_linux_plugin.h"
//#include "ext/equations-parser/parser/mpParser.h"
#include "mpParser.h"
#include "mpDefines.h"
//#include "ext/equations-parser/parser/mpDefines.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include <string>
#include <iostream>
using namespace std;
using namespace mup;

#define PARSEC_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), parsec_linux_plugin_get_type(), \
                              ParsecLinuxPlugin))

struct _ParsecLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(ParsecLinuxPlugin, parsec_linux_plugin, g_object_get_type())

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

Value Calc(string input) {
    ParserX parser(pckALL_NON_COMPLEX);

    Value ans;
    parser.DefineVar(_T("ans"), Variable(&ans));

    try
    {
        parser.SetExpr(input);
        ans = parser.Eval();

        return ans;
    }
    catch(ParserError &e)
    {
        if (e.GetPos() != -1) {
            string_type error = "Error: ";
            error.append(e.GetMsg());
            return error;
        }
    }
    catch(std::runtime_error &)
    {
        string_type error = "Error: Runtime error";
        return error;
    }
    return ans;
}

string CalcJson(string input) {
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

// Called when a method call is received from Flutter.
static void parsec_linux_plugin_handle_method_call(
    ParsecLinuxPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "nativeEval") == 0) {
    // Get Dart arguments
    FlValue* args = fl_method_call_get_args(method_call);
    // Fetch string value named "name"
    FlValue *text_value = fl_value_lookup_string(args, "equation");

    // Check if returned value is either null or string
    if (text_value == nullptr || fl_value_get_type(text_value) != FL_VALUE_TYPE_STRING) {
      // Return error
      g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

      // Create error, in this case null
      g_autoptr(GError) error = nullptr;

      // Send response back to dart
      fl_method_call_respond(method_call, response, &error);
      return;
    }

    string formula = fl_value_get_string(text_value);
    string ans = CalcJson(formula);

    g_autofree gchar *answer = g_strdup_printf("Linux %s", ans.c_str());
    g_autoptr(FlValue) result = fl_value_new_string(answer);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void parsec_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(parsec_linux_plugin_parent_class)->dispose(object);
}

static void parsec_linux_plugin_class_init(ParsecLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = parsec_linux_plugin_dispose;
}

static void parsec_linux_plugin_init(ParsecLinuxPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  ParsecLinuxPlugin* plugin = PARSEC_LINUX_PLUGIN(user_data);
  parsec_linux_plugin_handle_method_call(plugin, method_call);
}

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
