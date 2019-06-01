import 'package:flutter/material.dart';
import 'package:themoviedb/screen/nowplaying.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        canvasColor: Colors.white
      ),
      home: NowPlaying(),
    );
  }
}
