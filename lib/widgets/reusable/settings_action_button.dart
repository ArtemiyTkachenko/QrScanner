import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:qrscanner/consts/dimens.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsActionButton extends StatelessWidget {
  final String _iconPath;
  final String _text;
  final VoidCallback callback;
  final String? secondaryText;

  SettingsActionButton(
      this._iconPath, this._text, this.secondaryText, this.callback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    _iconPath,
                    width: 24,
                    height: 24,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(_text),
                        style: TextStyle(
                            fontSize: size16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      secondaryText != null
                          ? Text(
                              tr(secondaryText!),
                              style: TextStyle(
                                  fontSize: size12,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                    size: 24.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
