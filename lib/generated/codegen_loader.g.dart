// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en_US = {
  "scanner": "Scanner",
  "scan_instruction": "Point your camera at the QR-code",
  "settings": "Settings",
  "remove_adds": "Remove ADs",
  "url": "URL",
  "text": "Text",
  "contact": "Contact",
  "barcode": "Barcode",
  "share": "Share",
  "copy": "Copy",
  "show_all": "Show",
  "sound": "Sound",
  "vibration": "Vibration",
  "auto_copy": "Autocopy to clipboard",
  "auto_open": "Open link automatically",
  "report": "Report a bug",
  "main_app_title": "Our main app",
  "main_app_secondary": "Goods reviews, barcode scanning\nand much more",
  "code_copied": "Code copied to clipboard: {}"
};
static const Map<String,dynamic> ru_RU = {
  "scanner": "Сканнер",
  "scan_instruction": "Наведите камеру на QR-код",
  "settings": "Настройки",
  "remove_adds": "Убрать рекламу",
  "url": "URL",
  "text": "Текст",
  "contact": "Контакт",
  "barcode": "Штрихкод",
  "share": "Поделиться",
  "copy": "Копировать",
  "show_all": "Показать всё",
  "sound": "Звук",
  "vibration": "Вибрация",
  "auto_copy": "Автокопирование\nв буфер обмена",
  "auto_open": "Автоматическое\nоткрытие ссылок",
  "report": "Сообщить об ошибке",
  "main_app_title": "Наше основное приложение",
  "main_app_secondary": "Отзывы на товары, скан штрихкодов\nи многое другое",
  "code_copied": "Код скопирован в буфер: {}"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "ru_RU": ru_RU};
}
