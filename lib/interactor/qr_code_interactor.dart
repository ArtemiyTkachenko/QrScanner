import 'package:qrscanner/repository/qr_code_repository.dart';

import '../qr_code.dart';

class QrCodeInteractor {

  final QrCodeRepository _qrCodeRepository;

  QrCodeInteractor(this._qrCodeRepository);

  Stream<List<QrCode>> observeQrCodes() => _qrCodeRepository.observeQrCodes();

  Future<bool> getQrCodeSize() async {
    final list = await _qrCodeRepository.getQrCodes();
    return list.isNotEmpty;
  }

  Future<void> addQrCode(final QrCode qrCode) async {
    await _qrCodeRepository.addQrCode(qrCode);
  }
}