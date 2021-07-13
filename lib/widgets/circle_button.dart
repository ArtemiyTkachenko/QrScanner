import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrscanner/consts/colors.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String iconData;

  CircleButton(this.iconData, this.onTap);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return Container(
      width: size,
      height: size,
      child: RawMaterialButton(
        onPressed: onTap,
        elevation: 2.0,
        fillColor: Colors.grey.shade200.withOpacity(0.3),
        child: SvgPicture.asset(
          iconData,
          width: 24.0,
          height: 24.0
        ),
        shape: CircleBorder(),
      ),
    );
  }
}
