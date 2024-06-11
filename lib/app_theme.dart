import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/colors.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white_color,
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    hoverColor: Colors.grey,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      surfaceTintColor: white_color,
      color: app_Background,
      iconTheme: IconThemeData(color: textColorPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: Colors.transparent),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.light(primary: primaryColor, primaryContainer: primaryColor, error: Colors.red),
    cardTheme: CardTheme(color: Colors.white),
    cardColor: scaffoldBackgroundLightColor,
    iconTheme: IconThemeData(color: textColorPrimary),
    dividerTheme: DividerThemeData(color: Colors.grey.shade300),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: primaryColor),
      labelMedium: TextStyle(color: textColorPrimary),
      labelSmall: TextStyle(color: textColorSecondary),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: appBackGroundColor,
    highlightColor: app_background_black,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appBackGroundColor,
      color: app_background_black,
      iconTheme: IconThemeData(color: white_color),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: appBackGroundColor, statusBarBrightness: Brightness.light),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    primaryColor: color_primary_black,
    primaryColorDark: color_primary_black,
    hoverColor: Colors.black,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.light(primary: app_background_black, onPrimary: card_background_black, primaryContainer: color_primary_black, error: Color(0xFFCF6676)),
    cardTheme: CardTheme(color: scaffoldBackgroundDarkColor),
    cardColor: card_color_dark,
    iconTheme: IconThemeData(color: white_color),
    dividerTheme: DividerThemeData(color: Colors.grey.shade800),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: white_color),
      labelMedium: TextStyle(color: white_color),
      labelSmall: TextStyle(color: Colors.white54),
      bodyLarge: TextStyle(color: Colors.white54),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
  );
}
