import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:qrscanner/consts/colors.dart';
import 'package:qrscanner/consts/dimens.dart';
import 'package:qrscanner/consts/icons.dart';
import 'package:qrscanner/consts/padding.dart';
import 'package:qrscanner/generated/locale_keys.g.dart';
import 'package:qrscanner/utils/utils.dart';
import 'package:qrscanner/widgets/reusable/action_icon_button.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeCard extends StatelessWidget {
  final String _qrcode;

  QrCodeCard(this._qrcode);

  @override
  Widget build(BuildContext context) {
    String? modifiedText;
    String? header;

    final qrType = getCardType(_qrcode);
    switch (qrType) {
      case QrTypes.contact:
        {
          modifiedText = parseContact(Contact.fromVCard(_qrcode));
          header = tr(LocaleKeys.contact);
          break;
        }
      case QrTypes.url:
        {
          modifiedText = _qrcode;
          header = tr(LocaleKeys.url);
          break;
        }
      case QrTypes.barcode:
        {
          modifiedText = _qrcode;
          header = tr(LocaleKeys.barcode);
          break;
        }
      default:
        {
          modifiedText = _qrcode;
          header = tr(LocaleKeys.text);
        }
    }

    return Padding(
      padding: all8,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: topLeft16,
                child: Text(
                  header,
                  style: TextStyle(color: primaryTextColor, fontSize: size12, fontWeight: FontWeight.w700),
                )),
            Padding(
              padding: top8Left16,
              child: Linkify(
                  onOpen: (link) => processAutoOpen(link.url, forceOpen: true),
                  text: modifiedText,
                  style: TextStyle(color: primaryTextColor, fontSize: size16),
                  linkStyle: TextStyle(color: Colors.blue)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ActionIconButton(
                      tr(LocaleKeys.share), shareIcon, () => {Share.share(_qrcode)}),
                  ActionIconButton(tr(LocaleKeys.copy), copyIcon,
                      () => {processCopy(context, _qrcode)}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
