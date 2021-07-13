import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:qrscanner/consts/dimens.dart';
import 'package:qrscanner/consts/icons.dart';
import 'package:qrscanner/widgets/reusable/settings_switch.dart';

import '../consts.dart';

import '../generated/locale_keys.g.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
    initZendesk();
  }

  Future<void> initZendesk() async {
    // if (!mounted) {
    //   return;
    // }
    // await Zendesk.initialize("mobile_sdk_client_29ad986a0f004294d4b6", "baa69dd1d5af04fe90e1e2692169f4a27eb0988ba46f94a8");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 24.0,
        ),
        title: Text(
          tr(LocaleKeys.settings),
          style: TextStyle(
              color: Colors.black,
              fontSize: size16,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            SettingsSwitch(LocaleKeys.sound, settingsSound, SoundOn),
            SettingsSwitch(LocaleKeys.vibration, settingsVibration, vibration),
            SettingsSwitch(LocaleKeys.auto_copy, settingsCopy, autoCopy),
            SettingsSwitch(LocaleKeys.auto_open, settingsAutoOpen, autoOpen),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 48.0, 0.0),
              child: Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                    child: Text(
                      "Version: " + appVersion,
                      style: TextStyle(
                          fontSize: size14,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
