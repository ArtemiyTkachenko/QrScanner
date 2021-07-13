import 'package:hive/hive.dart';

import '../consts.dart';

Future<bool> getSoundPref() async {
  return Hive.box(settings).get(soundSettings, defaultValue: false);
}

Future<bool> getVibrationPref() async {
  return Hive.box(settings).get(vibration, defaultValue: false);
}

Future<bool> getAutoCopyToBufferPref() async {
  return Hive.box(settings).get(autoCopy, defaultValue: false);
}

Future<bool> getAutoOpenPref() async {
  return Hive.box(settings).get(autoOpen, defaultValue: false);
}