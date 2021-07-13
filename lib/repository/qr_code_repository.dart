import 'package:hive/hive.dart';
import 'package:qrscanner/qr_code.dart';
import 'package:qrscanner/hive/hive_data_provider.dart';

class QrCodeRepository {
  final HiveBoxProvider<QrCode> _qrCodeBoxProvider;

  QrCodeRepository(this._qrCodeBoxProvider);

  Stream<List<QrCode>> observeQrCodes() async* {
    final Box<QrCode> box = await _qrCodeBoxProvider();
    var list = box.values.toList();
    yield list;
    await for (BoxEvent _ in box.watch()) {
      yield list;
    }
  }

  Future<List<QrCode>> getQrCodes() async {
    final Box<QrCode> box = await _qrCodeBoxProvider();
    return box.values.toList();
  }

  Future<void> addQrCode(final QrCode qrCode) async {
    final Box<QrCode> box = await _qrCodeBoxProvider();
    box.add(qrCode);
  }

  Future<void> removeAt(final int index) async {
    final Box<QrCode> box = await _qrCodeBoxProvider();
    box.deleteAt(index);
  }
}