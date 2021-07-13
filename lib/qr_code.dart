import 'package:hive/hive.dart';

part 'qr_code.g.dart';

@HiveType(typeId: 0)
class QrCode extends HiveObject {

  @HiveField(0)
  String? code;

  @HiveField(1)
  int? time;

  @override
  String toString() {
    return 'QrCode{code: $code, time: $time}';
  }
}