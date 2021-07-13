import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:qrscanner/consts/icons.dart';
import 'package:qrscanner/generated/locale_keys.g.dart';
import 'package:qrscanner/hive/hive_data_provider.dart';
import 'package:qrscanner/interactor/qr_code_interactor.dart';
import 'package:qrscanner/main.dart';
import 'package:qrscanner/repository/qr_code_repository.dart';
import 'package:qrscanner/widgets/qr_camera.dart';
import 'package:qrscanner/widgets/qr_code_card.dart';
import 'package:qrscanner/widgets/qr_sheet_header.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../qr_code.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with WidgetsBindingObserver, RouteAware {
  final onResumeController = StreamController<bool>.broadcast();
  final onPauseController = StreamController<bool>.broadcast();

  late QrCodeInteractor _interactor;
  ScrollPhysics _physics = NeverScrollableScrollPhysics();
  final PanelController _controller = PanelController();
  var bottomSheetPulledTwice = false;
  var maxHeight = 270.0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumeController.add(true);
        break;
      case AppLifecycleState.inactive:
        onPauseController.add(true);
        break;
      case AppLifecycleState.paused:
        onPauseController.add(true);
        break;
      case AppLifecycleState.detached:
        onPauseController.add(true);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didPushNext() {
    onPauseController.add(true);
    super.didPushNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    onResumeController.add(true);
    super.didPopNext();
  }

  @override
  void initState() {
    final HiveDataProvider qrCodeBoxProvider = HiveDataProvider();
    final QrCodeRepository qrCodeRepository =
        QrCodeRepository(qrCodeBoxProvider.qrCodesBoxProvider);
    _interactor = QrCodeInteractor(qrCodeRepository);
    super.initState();
    setMaxHeight();
  }

  void setMaxHeight() async {
    final isNotEmpty = await _interactor.getQrCodeSize();
    setState(() {
      maxHeight = isNotEmpty ? 500.0 : 338.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: maxHeight,
        backdropEnabled: true,
        body: CameraWidget(
          interactor: _interactor,
          onPause: onPauseController.stream,
          onResume: onResumeController.stream,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        header: QrSheetHeader(),
        controller: _controller,
        onPanelClosed: () {
          setState(() {
            _physics = NeverScrollableScrollPhysics();
          });
        },
        onPanelOpened: () {
          setState(() {
            _physics = AlwaysScrollableScrollPhysics();
          });
        },
        panel: StreamBuilder<List<QrCode>>(
            stream: _interactor.observeQrCodes(),
            builder:
                (BuildContext context, AsyncSnapshot<List<QrCode>> snapshot) {
              if (snapshot.data == null || snapshot.data?.length == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        tr(LocaleKeys.scanner),
                        style: TextStyle(
                            fontSize: 26.0,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          tr(LocaleKeys.scan_instruction),
                          style: TextStyle(fontSize: 14.0, color: primaryText),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 166,
                            child: SvgPicture.asset(scanHistoryPlaceholder)),
                      ),
                    ],
                  ),
                );
              }
              return _buildList(snapshot.data, context);
            }),
      ),
    );
  }

  Widget _buildList(List<QrCode>? list, BuildContext context) {
    if (list == null) return Text("List is null for some reason");
    return SafeArea(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          var metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            if (metrics.pixels == 0) {
              print('At top');
              if (bottomSheetPulledTwice == true) {
                _controller.close();
                bottomSheetPulledTwice = false;
              } else {
                bottomSheetPulledTwice = true;
              }
            } else {
              bottomSheetPulledTwice = false;
              print('At bottom');
            }
          }
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: _physics,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final QrCode item = list[index];
                  final String code =
                      item.code == null ? "Something went wrong" : item.code!;
                  return QrCodeCard(code);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future checkForPermissions(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();

      var allPermissionsGiven = true;

      statuses.forEach((key, value) {
        if (!value.isGranted) allPermissionsGiven = false;
      });

      if (allPermissionsGiven) {}
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    onPauseController.close();
    onResumeController.close();
    super.dispose();
  }
}
