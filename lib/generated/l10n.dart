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

  /// `official mobile app`
  String get mobileEditionUnofficial {
    return Intl.message(
      'official mobile app',
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

  /// ` (not implemented)`
  String get notImplemented {
    return Intl.message(
      ' (not implemented)',
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

  /// `About Xournal++ Mobile`
  String get aboutXournalMobileEdition {
    return Intl.message(
      'About Xournal++ Mobile',
      name: 'aboutXournalMobileEdition',
      desc: '',
      args: [],
    );
  }

  /// `Xournal++ Mobile is a project trying to make Xournal++ files and features available on different devices.`
  String get xournalMobileEditionIsAnUnofficialProjectTryingToMake {
    return Intl.message(
      'Xournal++ Mobile is a project trying to make Xournal++ files and features available on different devices.',
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

  /// `Tool`
  String get tool {
    return Intl.message(
      'Tool',
      name: 'tool',
      desc: '',
      args: [],
    );
  }

  /// `Pen`
  String get pen {
    return Intl.message(
      'Pen',
      name: 'pen',
      desc: '',
      args: [],
    );
  }

  /// `Highlighter (not implemented)`
  String get highlighterNotImplemented {
    return Intl.message(
      'Highlighter (not implemented)',
      name: 'highlighterNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Move`
  String get move {
    return Intl.message(
      'Move',
      name: 'move',
      desc: '',
      args: [],
    );
  }

  /// `Text (not implemented)`
  String get textNotImplemented {
    return Intl.message(
      'Text (not implemented)',
      name: 'textNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `LaTeX (not implemented)`
  String get latexNotImplemented {
    return Intl.message(
      'LaTeX (not implemented)',
      name: 'latexNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Eraser (not implemented)`
  String get eraserNotImplemented {
    return Intl.message(
      'Eraser (not implemented)',
      name: 'eraserNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Select (not implemented)`
  String get selectNotImplemented {
    return Intl.message(
      'Select (not implemented)',
      name: 'selectNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Stroke width:`
  String get strokeWidth {
    return Intl.message(
      'Stroke width:',
      name: 'strokeWidth',
      desc: '',
      args: [],
    );
  }

  /// `Select color`
  String get selectColor {
    return Intl.message(
      'Select color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Whiteout eraser (not implemented)`
  String get whiteoutEraserNotImplemented {
    return Intl.message(
      'Whiteout eraser (not implemented)',
      name: 'whiteoutEraserNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Add page`
  String get addPage {
    return Intl.message(
      'Add page',
      name: 'addPage',
      desc: '',
      args: [],
    );
  }

  /// `There were no more pages. We added one.`
  String get thereWereNoMorePagesWeAddedOne {
    return Intl.message(
      'There were no more pages. We added one.',
      name: 'thereWereNoMorePagesWeAddedOne',
      desc: '',
      args: [],
    );
  }

  /// `PDF`
  String get pdf {
    return Intl.message(
      'PDF',
      name: 'pdf',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Dotted`
  String get dotted {
    return Intl.message(
      'Dotted',
      name: 'dotted',
      desc: '',
      args: [],
    );
  }

  /// `Ruled`
  String get ruled {
    return Intl.message(
      'Ruled',
      name: 'ruled',
      desc: '',
      args: [],
    );
  }

  /// `Graph`
  String get graph {
    return Intl.message(
      'Graph',
      name: 'graph',
      desc: '',
      args: [],
    );
  }

  /// `Page background`
  String get pageBackground {
    return Intl.message(
      'Page background',
      name: 'pageBackground',
      desc: '',
      args: [],
    );
  }

  /// `Lined`
  String get lined {
    return Intl.message(
      'Lined',
      name: 'lined',
      desc: '',
      args: [],
    );
  }

  /// `Delete page`
  String get deletePage {
    return Intl.message(
      'Delete page',
      name: 'deletePage',
      desc: '',
      args: [],
    );
  }

  /// `Move page`
  String get movePage {
    return Intl.message(
      'Move page',
      name: 'movePage',
      desc: '',
      args: [],
    );
  }

  /// `New page index`
  String get newPageIndex {
    return Intl.message(
      'New page index',
      name: 'newPageIndex',
      desc: '',
      args: [],
    );
  }

  /// `Between 1 and`
  String get between1And {
    return Intl.message(
      'Between 1 and',
      name: 'between1And',
      desc: '',
      args: [],
    );
  }

  /// `Saving file...`
  String get savingFile {
    return Intl.message(
      'Saving file...',
      name: 'savingFile',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately, there was an error saving this file.`
  String get unfortunatelyThereWasAnErrorSavingThisFile {
    return Intl.message(
      'Unfortunately, there was an error saving this file.',
      name: 'unfortunatelyThereWasAnErrorSavingThisFile',
      desc: '',
      args: [],
    );
  }

  /// `Successfully saved.`
  String get successfullySaved {
    return Intl.message(
      'Successfully saved.',
      name: 'successfullySaved',
      desc: '',
      args: [],
    );
  }

  /// `Save as...`
  String get saveAs {
    return Intl.message(
      'Save as...',
      name: 'saveAs',
      desc: '',
      args: [],
    );
  }

  /// `Confirm delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete the selected file? This cannot be undone.`
  String get areYouSureToDeleteTheSelectedFileThisCannot {
    return Intl.message(
      'Are you sure to delete the selected file? This cannot be undone.',
      name: 'areYouSureToDeleteTheSelectedFileThisCannot',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Quota`
  String get quota {
    return Intl.message(
      'Quota',
      name: 'quota',
      desc: '',
      args: [],
    );
  }

  /// `used`
  String get used {
    return Intl.message(
      'used',
      name: 'used',
      desc: '',
      args: [],
    );
  }

  /// `MB`
  String get mb {
    return Intl.message(
      'MB',
      name: 'mb',
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