import 'package:flutter/foundation.dart';

/// G COUNT Logger — for ADB Logcat debugging
/// Tag format: G_COUNT/[TAG]
/// Filter in adb: adb logcat -s G_COUNT
class GLog {
  static const String _appTag = 'G_COUNT';

  // INFO
  static void i(String tag, String message) {
    debugPrint('[$_appTag/INFO/$tag] $message');
  }

  // DEBUG
  static void d(String tag, String message) {
    debugPrint('[$_appTag/DEBUG/$tag] $message');
  }

  // WARNING
  static void w(String tag, String message) {
    debugPrint('[$_appTag/WARN/$tag] ⚠️ $message');
  }

  // ERROR
  static void e(String tag, String message) {
    debugPrint('[$_appTag/ERROR/$tag] ❌ $message');
  }

  // SUCCESS
  static void s(String tag, String message) {
    debugPrint('[$_appTag/SUCCESS/$tag] ✅ $message');
  }
}