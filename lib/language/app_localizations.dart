import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/language/LanguageAf.dart';
import 'package:news_flutter/language/LanguageAr.dart';
import 'package:news_flutter/language/LanguageDe.dart';
import 'package:news_flutter/language/LanguageEn.dart';
import 'package:news_flutter/language/LanguageEs.dart';
import 'package:news_flutter/language/LanguageFr.dart';
import 'package:news_flutter/language/LanguageGu.dart';
import 'package:news_flutter/language/LanguageHi.dart';
import 'package:news_flutter/language/LanguageId.dart';
import 'package:news_flutter/language/LanguageJa.dart';
import 'package:news_flutter/language/LanguageNl.dart';
import 'package:news_flutter/language/LanguagePt.dart';
import 'package:news_flutter/language/LanguageTr.dart';
import 'package:news_flutter/language/LanguageVi.dart';
import 'package:news_flutter/language/LanguageZh.dart';
import 'package:news_flutter/language/languages.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'af':
        return LanguageAf();
      case 'ar':
        return LanguageAr();
      case 'de':
        return LanguageDe();
      case 'es':
        return LanguageEs();
      case 'fr':
        return LanguageFr();
      case 'gu':
        return LanguageGu();
      case 'hi':
        return LanguageHi();
      case 'id':
        return LanguageId();
      case 'ja':
        return LanguageJa();
      case 'nl':
        return LanguageNl();
      case 'pt':
        return LanguagePt();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();
      case 'zh':
        return LanguageZh();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
