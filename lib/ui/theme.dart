import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: 'Glacial Indifference',
          fontSize: 40.0,
          color: const Color.fromRGBO(58, 66, 86, 1.0),
        ),
        // Used for the recipes' title:
        title: base.title.copyWith(
          fontFamily: 'League Spartan',
          fontSize: 15.0,
          color: const Color.fromRGBO(58, 66, 86, 1.0),
        ),
        // Used for the recipes' duration:
        caption: base.caption.copyWith(
          color: const Color(0xFF7a84f1),
        ),
        body1: base.body1.copyWith(color: const Color.fromRGBO(58, 66, 86, 1.0))
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      primaryColor: const Color(0xFF4458be),
      primaryColorDark: const Color(0xFF00308d),
      primaryColorLight: const Color(0xFF7a84f1),
      indicatorColor: const Color(0xFF7a84f1),
      //scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      scaffoldBackgroundColor: Colors.white,
      accentColor: const Color(0xFF00308d),
      iconTheme: IconThemeData(
        color: const Color(0xFF4458be),
        size: 20.0,
      ),
      buttonColor: const Color(0xFF4458be),
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xFF807A6B),
        unselectedLabelColor: const Color(0xFFCCC5AF),

      )
  );
}
