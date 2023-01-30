#include <jni.h>
#include <string>
#include <iostream>
#include <cmath>
#include "mpParser.h"
#include "mpDefines.h"
#include "equationsParser.h"

using namespace std;
using namespace mup;
using namespace EquationsParser;

extern "C" JNIEXPORT jstring JNICALL
Java_com_oxeanbits_parsec_1android_ParsecAndroidPlugin_nativeEvalJson(JNIEnv *env, jobject /* this */, jstring input) {
    const char *inputChars = env->GetStringUTFChars(input, NULL);
    string json = CalcJson(string(inputChars));
    return env->NewStringUTF(json.c_str());
}

