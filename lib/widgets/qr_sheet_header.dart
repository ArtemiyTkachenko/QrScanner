import 'package:flutter/cupertino.dart';
import 'package:qrscanner/consts/icons.dart';

class QrSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(handleIcon),
      ),
    );
  }

}