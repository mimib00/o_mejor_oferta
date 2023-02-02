import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translation/en.dart';
import 'translation/es.dart';

class LocalizationService extends Translations {
  static const fallbackLocale = Locale('en');

  static const locales = [
    Locale('en'),
    Locale('es'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'es': es,
      };
}
