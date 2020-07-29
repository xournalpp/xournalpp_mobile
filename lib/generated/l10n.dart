// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `New Document`
  String get newDocument {
    return Intl.message(
      'New Document',
      name: 'newDocument',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get tools {
    return Intl.message(
      'Tools',
      name: 'tools',
      desc: '',
      args: [],
    );
  }

  /// `Toolbox not implemented yet.`
  String get toolboxNotImplementedYet {
    return Intl.message(
      'Toolbox not implemented yet.',
      name: 'toolboxNotImplementedYet',
      desc: '',
      args: [],
    );
  }

  /// `Set document title`
  String get setDocumentTitle {
    return Intl.message(
      'Set document title',
      name: 'setDocumentTitle',
      desc: '',
      args: [],
    );
  }

  /// `New title`
  String get newTitle {
    return Intl.message(
      'New title',
      name: 'newTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Mobile edition (unofficial)`
  String get mobileEditionUnofficial {
    return Intl.message(
      'Mobile edition (unofficial)',
      name: 'mobileEditionUnofficial',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newFile {
    return Intl.message(
      'New',
      name: 'newFile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Not implemented`
  String get notImplemented {
    return Intl.message(
      'Not implemented',
      name: 'notImplemented',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `About Xournal++ - Mobile edition`
  String get aboutXournalMobileEdition {
    return Intl.message(
      'About Xournal++ - Mobile edition',
      name: 'aboutXournalMobileEdition',
      desc: '',
      args: [],
    );
  }

  /// `Xournal++ - Mobile edition is an unofficial project trying to make Xournal++ files and features available on different devices.`
  String get xournalMobileEditionIsAnUnofficialProjectTryingToMake {
    return Intl.message(
      'Xournal++ - Mobile edition is an unofficial project trying to make Xournal++ files and features available on different devices.',
      name: 'xournalMobileEditionIsAnUnofficialProjectTryingToMake',
      desc: '',
      args: [],
    );
  }

  /// `About Xournal++`
  String get aboutXournal {
    return Intl.message(
      'About Xournal++',
      name: 'aboutXournal',
      desc: '',
      args: [],
    );
  }

  /// `Source Code`
  String get sourceCode {
    return Intl.message(
      'Source Code',
      name: 'sourceCode',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to change.`
  String get doubleTapToChange {
    return Intl.message(
      'Double tap to change.',
      name: 'doubleTapToChange',
      desc: '',
      args: [],
    );
  }

  /// `Not working yet.`
  String get notWorkingYet {
    return Intl.message(
      'Not working yet.',
      name: 'notWorkingYet',
      desc: '',
      args: [],
    );
  }

  /// `Loading file...`
  String get loadingFile {
    return Intl.message(
      'Loading file...',
      name: 'loadingFile',
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