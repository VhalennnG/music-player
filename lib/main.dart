import 'package:flutter/material.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/home_page.dart';
import 'package:musicplayer/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(), child: const MyApp()),
      ChangeNotifierProvider(
          create: (context) => PlaylistProvider(), child: const MyApp())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
