import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrscanner/consts/dimens.dart';

import '../../consts.dart';

class SettingsSwitch extends StatelessWidget {
  final String _icon;
  final String _text;
  final String _prefKey;

  SettingsSwitch(this._text, this._icon, this._prefKey);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SvgPicture.asset(
              _icon,
              color: Colors.black,
              width: 24,
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                tr(_text),
                style: TextStyle(fontSize: size16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(settings).listenable(),
                  builder: (context, Box box, widget) {
                    return Switch(
                        inactiveTrackColor: switchInactiveColor,
                        activeColor: accentColor,
                        activeTrackColor: accentColor56,
                        value: box.get(_prefKey, defaultValue: false),
                        onChanged: (val) {
                          box.put(_prefKey, val);
                        });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}