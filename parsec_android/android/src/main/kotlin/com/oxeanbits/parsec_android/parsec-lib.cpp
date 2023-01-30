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
Java_com_oxeanbits_parsec_1android_ParsecAndroidPlugin_nativeEval(JNIEnv *env, jobject /* this */, jstring input) {
    const char *inputChars = env->GetStringUTFChars(input, NULL);
    string ans = EquationsParser::Calc(string(inputChars));
    return env->NewStringUTF(ans.c_str());
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_oxeanbits_parsec_1android_ParsecAndroidPlugin_nativeEvalJson(JNIEnv *env, jobject /* this */, jstring input) {
    const char *inputChars = env->GetStringUTFChars(input, NULL);
    string json = CalcJson(string(inputChars));
    return env->NewStringUTF(json.c_str());
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_oxeanbits_parsec_1android_ParsecAndroidPlugin_nativeEvalJsonArray(JNIEnv *env, jobject /* this */, jobjectArray input) {
    int len = env->GetArrayLength(input);
    vector<string> inputStrings;
    for(int i = 0; i < len; i++) {
        auto inputString = (jstring) env->GetObjectArrayElement(input, i);
        inputStrings.push_back(env->GetStringUTFChars(inputString, nullptr));
    }

    vector<string> results;
    CalcArray(inputStrings, results);

    jobjectArray result = env->NewObjectArray(len, env->FindClass("java/lang/String"), nullptr);
    for(int i = 0; i < len; i++) {
        jstring resultString = env->NewStringUTF(results[i].c_str());
        env->SetObjectArrayElement(result, i, resultString);
    }

    return result;
}

