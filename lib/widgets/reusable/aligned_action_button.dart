import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrscanner/consts/colors.dart';

class AlignedActionButton extends StatelessWidget {
  final String assetName;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final VoidCallback callback;

  AlignedActionButton(
      this.assetName, this.padding, this.alignment, this.callback);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: padding,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: grayTransparent, shape: BoxShape.circle),
          child: InkResponse(
            radius: 24,
            onTap: callback,
            child: SvgPicture.asset(
              assetName,
              fit: BoxFit.none,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      alignment: alignment,
    );
  }
}
