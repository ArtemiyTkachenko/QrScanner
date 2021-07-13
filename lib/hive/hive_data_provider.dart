import 'package:hive/hive.dart';

import '../qr_code.dart';
import '../consts.dart';

class HiveDataProvider {
  HiveBoxProvider<QrCode> get qrCodesBoxProvider => () => Hive.openBox<QrCode>(boxName);
}

typedef HiveBoxProvider<T extends HiveObject> = Future<Box<T>> Function();