import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/pages/OpenPage.dart';

import 'generated/l10n.dart';

void main() {
  /*
  /// STEP 1. Create catcher configuration.
  /// Debug configuration with dialog report mode and console handler. It will show dialog and once user accepts it, error will be shown   /// in console.
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
  ]);

  /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["the-one@with-the-braid.cf"])
  ]);

  /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  Catcher(XournalppMobile(),
      debugConfig: debugOptions, releaseConfig: releaseOptions);*/
  runApp(XournalppMobile());
}

const Color kPrimaryColor = Colors.deepPurple;
const Color kPrimaryColorAccent = Colors.deepPurpleAccent;
const Color kSecondaryColor = Colors.pink;
const Color kSecondaryColorAccent = Colors.pinkAccent;
final Color? kDarkColor = Colors.blueGrey[900];
const Color kLightColor = Colors.white;

const double kFontSizeDivision = 1.6;

const double kHugeFontSize = 72 / kFontSizeDivision;
const double kLargeFontSize = 28 / kFontSizeDivision;
const double kBodyFontSize = 24 / kFontSizeDivision;
const double kEmphasisFontSize = 25.2 / kFontSizeDivision;

const TextStyle kHugeFont = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w800,
    color: kSecondaryColor,
    height: 1.4,
    fontSize: kHugeFontSize);
final TextStyle kLargeFont = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: kLargeFontSize,
  color: kLightColor,
  height: 1.4,
);
const TextStyle kBodyFont = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w300,
    height: 1.4,
    fontSize: kBodyFontSize);
const TextStyle kEmphasisFont = TextStyle(
    fontFamily: 'Glacial Indifference',
    fontSize: kEmphasisFontSize,
    height: 1.22,
    letterSpacing: 1.8);

final kTextTheme = TextTheme(
  headline1: kHugeFont,
  headline2: kHugeFont,
  headline3: kLargeFont
      .copyWith(color: kDarkColor)
      .copyWith(fontSize: kLargeFontSize * kFontSizeDivision),
  headline4: kLargeFont.copyWith(color: kDarkColor),
  headline5: kLargeFont.copyWith(color: kDarkColor),
  headline6: kLargeFont.copyWith(color: kDarkColor),
  bodyText1: kBodyFont,
  bodyText2: kEmphasisFont,
  caption: kEmphasisFont,
  button: kEmphasisFont,
);

final kColorScheme = ColorScheme(
  primary: kPrimaryColor,
  primaryVariant: kPrimaryColorAccent,
  secondary: kSecondaryColor,
  secondaryVariant: kSecondaryColorAccent,
  surface: kDarkColor!,
  background: kDarkColor!,
  error: Colors.deepOrange,
  onPrimary: kLightColor,
  onSecondary: kDarkColor!,
  onSurface: kDarkColor!,
  onBackground: kLightColor,
  onError: kLightColor,
  brightness: Brightness.dark,
);

final kDialogTheme =
    DialogTheme(titleTextStyle: kLargeFont.copyWith(color: kLightColor));

final kSnackBarTheme = SnackBarThemeData(
    backgroundColor: kDarkColor,
    actionTextColor: kSecondaryColorAccent,
    contentTextStyle: kBodyFont);

class XournalppMobile extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kIsWeb ? 'Xournal++ Web' : 'Xournal++ Mobile',
      localizationsDelegates: [
        S.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
          primarySwatch: kPrimaryColor as MaterialColor?,
          accentColor: kSecondaryColor,
          fontFamily: 'Open Sans',
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(brightness: Brightness.light),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogTheme: kDialogTheme,
          snackBarTheme: kSnackBarTheme),
      darkTheme: ThemeData(
          primarySwatch: kPrimaryColor as MaterialColor?,
          accentColor: kSecondaryColor,
          fontFamily: 'Open Sans',
          textTheme: kTextTheme,
          colorScheme: kColorScheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogTheme: kDialogTheme,
          snackBarTheme: kSnackBarTheme),
      home: OpenPage(),
    );
  }
}
