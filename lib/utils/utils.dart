import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:qrscanner/generated/locale_keys.g.dart';
import 'package:qrscanner/utils/box_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

Future<void> playVibrate({int repeat = 1}) async {
  final bool vibrationSettingIsSet = await getVibrationPref();
  if (vibrationSettingIsSet) {
    try {
      await Vibration.vibrate(duration: 300, repeat: repeat);
    } on Exception catch (e) {}
  }
}

Future<void> playSound() async {
  final bool soundSettingIsSet = await getSoundPref();
  if (soundSettingIsSet) {
    try {
      await SystemSound.play(SystemSoundType.click);
    } on Exception catch (e) {}
  }
}

void processCopy(BuildContext context, String qrCode) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(tr(LocaleKeys.code_copied, args: [qrCode]))));
  Clipboard.setData(ClipboardData(text: qrCode));
}

void processAutoCopy(BuildContext context, String qrCode) async {
  final bool autoCopyPrefIsSet = await getAutoCopyToBufferPref();
  if (autoCopyPrefIsSet == false) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(tr(LocaleKeys.code_copied, args: [qrCode]))));
  Clipboard.setData(ClipboardData(text: qrCode));
}

void processAutoOpen(String? link, {bool forceOpen = false}) async {
  if (forceOpen == false && await getAutoOpenPref() == false) return;
  if (link == null) return;
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not launch $link';
  }
}

QrTypes getCardType(String qrCode) {
  if (qrCode.startsWith("BEGIN:VCARD")) {
    return QrTypes.contact;
  } else if (qrCode.startsWith("http") || qrCode.startsWith("www")) {
    return QrTypes.url;
  } else if (num.tryParse(qrCode) != null) {
    return QrTypes.barcode;
  } else {
    return QrTypes.text;
  }
}

String parseContact(Contact contact) {
  var buffer = StringBuffer();
  final name = contact.displayName;
  final phones = contact.phones.map((e) => e.number + "\n,").toString();
  final emails = contact.emails.map((e) => e.address + "\n,").toString();
  final addresses = contact.addresses.map((e) => e.address + "\n,").toString();
  if (name.isNotEmpty) buffer.write("Имя: " + name + "\n");
  if (phones.length > 4) buffer.write("Телефоны: " + phones.substring(1, phones.length - 2));
  if (emails.length > 4) buffer.write("Email: " + emails.substring(1, emails.length - 2));
  if (addresses.length > 4) buffer.write("Адреса: " + addresses.substring(1, addresses.length - 2));
  return buffer.toString().trim();
}

enum QrTypes { contact, url, barcode, text }
