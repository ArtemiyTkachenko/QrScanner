import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:qrscanner/consts/dimens.dart';

class ActionIconButton extends StatelessWidget {

  final String title;
  final String iconData;
  final VoidCallback onTapCallback;

  ActionIconButton(this.title, this.iconData, this.onTapCallback);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            onTap: onTapCallback,
            child: Row(
              children: [
                SvgPicture.asset(
                  iconData,
                  color: primaryTextColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(color: primaryTextColor, fontSize: size14, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
