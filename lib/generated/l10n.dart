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

  /// `mobile edition (unofficial)`
  String get mobileEditionUnofficial {
    return Intl.message(
      'mobile edition (unofficial)',
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

  /// `About Xournal++ - mobile edition`
  String get aboutXournalMobileEdition {
    return Intl.message(
      'About Xournal++ - mobile edition',
      name: 'aboutXournalMobileEdition',
      desc: '',
      args: [],
    );
  }

  /// `Xournal++ - mobile edition is an unofficial project trying to make Xournal++ files and features available on different devices.`
  String get xournalMobileEditionIsAnUnofficialProjectTryingToMake {
    return Intl.message(
      'Xournal++ - mobile edition is an unofficial project trying to make Xournal++ files and features available on different devices.',
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

  /// `No file selected`
  String get noFileSelected {
    return Intl.message(
      'No file selected',
      name: 'noFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `You did not select any file.`
  String get youDidNotSelectAnyFile {
    return Intl.message(
      'You did not select any file.',
      name: 'youDidNotSelectAnyFile',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Recent files`
  String get recentFiles {
    return Intl.message(
      'Recent files',
      name: 'recentFiles',
      desc: '',
      args: [],
    );
  }

  /// `New Notebook`
  String get newNotebook {
    return Intl.message(
      'New Notebook',
      name: 'newNotebook',
      desc: '',
      args: [],
    );
  }

  /// `No recent files.`
  String get noRecentFiles {
    return Intl.message(
      'No recent files.',
      name: 'noRecentFiles',
      desc: '',
      args: [],
    );
  }

  /// `Opening file`
  String get openingFile {
    return Intl.message(
      'Opening file',
      name: 'openingFile',
      desc: '',
      args: [],
    );
  }

  /// `Error opening file`
  String get errorOpeningFile {
    return Intl.message(
      'Error opening file',
      name: 'errorOpeningFile',
      desc: '',
      args: [],
    );
  }

  /// `Drop files to open`
  String get dropFilesToOpen {
    return Intl.message(
      'Drop files to open',
      name: 'dropFilesToOpen',
      desc: '',
      args: [],
    );
  }

  /// `Error loading file`
  String get errorLoadingFile {
    return Intl.message(
      'Error loading file',
      name: 'errorLoadingFile',
      desc: '',
      args: [],
    );
  }

  /// `The following error was detected:`
  String get theFollowingErrorWasDetected {
    return Intl.message(
      'The following error was detected:',
      name: 'theFollowingErrorWasDetected',
      desc: '',
      args: [],
    );
  }

  /// `Copy error message`
  String get copyErrorMessage {
    return Intl.message(
      'Copy error message',
      name: 'copyErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `I'm very sorry, but I couldn't read the file `
  String get imVerySorryButICouldntReadTheFile {
    return Intl.message(
      'I\'m very sorry, but I couldn\'t read the file ',
      name: 'imVerySorryButICouldntReadTheFile',
      desc: '',
      args: [],
    );
  }

  /// `. Are you sure I have the permission? And are you sure it is a Xournal++ file?`
  String get areYouSureIHaveThePermissionAndAreYou {
    return Intl.message(
      '. Are you sure I have the permission? And are you sure it is a Xournal++ file?',
      name: 'areYouSureIHaveThePermissionAndAreYou',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `You've been redirected to the local app.`
  String get youveBeenRedirectedToTheLocalApp {
    return Intl.message(
      'You\'ve been redirected to the local app.',
      name: 'youveBeenRedirectedToTheLocalApp',
      desc: '',
      args: [],
    );
  }

  /// `Opening`
  String get opening {
    return Intl.message(
      'Opening',
      name: 'opening',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get background {
    return Intl.message(
      'Background',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `Abort`
  String get abort {
    return Intl.message(
      'Abort',
      name: 'abort',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
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