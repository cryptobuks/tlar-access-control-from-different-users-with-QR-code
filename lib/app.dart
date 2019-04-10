import 'package:flutter/material.dart';
import 'package:tlar/ui/screens/home.dart';
import 'package:tlar/ui/screens/login.dart';

import 'package:tlar/ui/theme.dart';

class TLARApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TLAR',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
