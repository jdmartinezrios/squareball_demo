import 'package:flutter/material.dart';
import 'package:squareball_demo/views/landingPage.dart';

void main() => runApp(MyAppSquareballStudios());

class MyAppSquareballStudios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            // primaryColor: Colors.black,
            primarySwatch: Colors.primaryBlack,
            buttonColor: Colors.redAccent),
        home: new LandingPage());
    // initialRoute: '/',
    // routes: {'/': (context) => Login()});
    // , '/home': (context) => Home()
  }
}
