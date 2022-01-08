import 'package:flutter/material.dart';
import 'package:music_app_ui/src/pages/main_page.dart';
import 'package:music_app_ui/src/providers/player_provider.dart';
import 'package:music_app_ui/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioPlayerProvider(),
      child: MaterialApp(
        title: 'Music App UI',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: MainPage(),
      ),
    );
  }
}
