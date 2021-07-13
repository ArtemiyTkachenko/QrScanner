// @dart=2.9
import 'package:qrscanner/widgets/qr_scanner_page.dart';

import 'consts.dart';
import 'generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive/reverse_comparator.dart';
import 'qr_code.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  await Hive.initFlutter();
  Hive.registerAdapter<QrCode>(QrCodeAdapter());
  await Hive.openBox<QrCode>(boxName, keyComparator: reverseOrder);
  await Hive.openBox(settings);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      assetLoader: CodegenLoader(),
      child: ScannerApp(),
    ),
  );
}

class ScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: ThemeData(brightness: Brightness.light, fontFamily: 'OpenSans'),
        darkTheme:
            ThemeData(brightness: Brightness.dark, fontFamily: 'OpenSans'),
        navigatorObservers: [routeObserver],
        themeMode: ThemeMode.dark,
        locale: context.locale,
        home: QrScannerPage());
  }
}
