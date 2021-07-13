import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrscanner/consts/icons.dart';
import 'package:qrscanner/interactor/qr_code_interactor.dart';
import 'package:qrscanner/utils/utils.dart';
import 'package:qrscanner/widgets/reusable/aligned_action_button.dart';
import 'package:qrscanner/widgets/settings_page.dart';
import 'package:scan/scan.dart';

import '../qr_code.dart';

class OnPause extends ChangeNotifier {

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class CameraWidget extends StatefulWidget {
  final QrCodeInteractor interactor;
  final Stream<bool> onPause;
  final Stream<bool> onResume;

  const CameraWidget({Key? key, required  this.interactor,  required  this.onPause, required this.onResume}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CameraState( interactor );
}

class CameraState extends State<CameraWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final QrCodeInteractor _interactor;
  QRViewController? controller;
  String? qrCode;

  StreamSubscription? onPauseSubscription;
  StreamSubscription? onResumeSubscription;

  var isTorchOn = false;

  CameraState(this._interactor);

  @override
  void initState() {
    onPauseSubscription = widget.onPause.listen((event) {
      controller?.pauseCamera();
    });
    onResumeSubscription = widget.onResume.listen((event) {
      controller?.resumeCamera();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: Center(
              child: Container(
                color: Colors.black,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 56.0),
          child: Center(
            child: Container(
              width: 242,
              height: 242,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
            ),
          ),
        ),
        AlignedActionButton(
            isTorchOn ? flashOffPath : flashOnPath,
            const EdgeInsets.fromLTRB(16, 40, 0, 0),
            Alignment.topLeft,
            () => processTorchChange()),
        AlignedActionButton(
            storagePath,
            const EdgeInsets.fromLTRB(72, 40.0, 0.0, 0.0),
            Alignment.topLeft,
            () => imageGallery()),
        AlignedActionButton(morePath, const EdgeInsets.fromLTRB(0, 40, 16, 0),
            Alignment.topRight, () => _navigateToSettings(context)),
      ],
    );
  }

  void _navigateToSettings(BuildContext context) {
    controller?.pauseCamera();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsPage()));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      processQrCode(code);
      setState(() {
        qrCode = code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    onPauseSubscription?.cancel();
    onResumeSubscription?.cancel();
    super.dispose();
  }

  void processQrCode(String? code) {
    if (code == qrCode || code == null) return;
    playVibrate();
    playSound();
    processAutoCopy(context, code);
    processAutoOpen(code);
    var qrBoxModel = QrCode();
    qrBoxModel.code = code;
    qrBoxModel.time = DateTime.now().millisecondsSinceEpoch;
    print(
        "qrCode is $code, and model is ${qrBoxModel.code} ${qrBoxModel.time}");

    _interactor.addQrCode(qrBoxModel);
  }

  void processTorchChange() {
    var tempTorch = !isTorchOn;
    changeTorchState(tempTorch);
    setState(() {
      print("torch is $isTorchOn");
      isTorchOn = tempTorch;
    });
  }

  void changeTorchState(bool torch) async {
    await controller?.toggleFlash();
    print("processed method");
  }

  void imageGallery() async {
    PickedFile? image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image?.path == null) return;
    print("image path is ${image!.path}");
    final decoded = await Scan.parse(image.path);
    print("decoded barcode is $decoded");
    final qrCode = QrCode();
    qrCode.code = decoded;
    qrCode.time = DateTime.now().millisecondsSinceEpoch;
    playVibrate();
    playSound();
    processAutoOpen(decoded);
    _interactor.addQrCode(qrCode);
  }
}
