// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get newDocument {
    return Intl.message(
      'New Document',
      name: 'newDocument',
      desc: '',
      args: [],
    );
  }

  String get tools {
    return Intl.message(
      'Tools',
      name: 'tools',
      desc: '',
      args: [],
    );
  }

  String get toolboxNotImplementedYet {
    return Intl.message(
      'Toolbox not implemented yet.',
      name: 'toolboxNotImplementedYet',
      desc: '',
      args: [],
    );
  }

  String get setDocumentTitle {
    return Intl.message(
      'Set document title',
      name: 'setDocumentTitle',
      desc: '',
      args: [],
    );
  }

  String get newTitle {
    return Intl.message(
      'New title',
      name: 'newTitle',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  String get mobileEditionUnofficial {
    return Intl.message(
      'Mobile edition (unofficial)',
      name: 'mobileEditionUnofficial',
      desc: '',
      args: [],
    );
  }

  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  String get newFile {
    return Intl.message(
      'New',
      name: 'newFile',
      desc: '',
      args: [],
    );
  }

  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  String get notImplemented {
    return Intl.message(
      'Not implemented',
      name: 'notImplemented',
      desc: '',
      args: [],
    );
  }

  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  String get aboutXournalMobileEdition {
    return Intl.message(
      'About Xournal++ - Mobile edition',
      name: 'aboutXournalMobileEdition',
      desc: '',
      args: [],
    );
  }

  String get xournalMobileEditionInAnUnofficialProjectTryingToMake {
    return Intl.message(
      'Xournal++ - Mobile edition in an unofficial project trying to make Xournal++ files and features available on different devices.',
      name: 'xournalMobileEditionInAnUnofficialProjectTryingToMake',
      desc: '',
      args: [],
    );
  }

  String get aboutXournal {
    return Intl.message(
      'About Xournal++',
      name: 'aboutXournal',
      desc: '',
      args: [],
    );
  }

  String get sourceCode {
    return Intl.message(
      'Source Code',
      name: 'sourceCode',
      desc: '',
      args: [],
    );
  }

  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}