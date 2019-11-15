import 'package:flutter/material.dart';
import 'package:squareball_demo/views/messages.dart';
import 'package:squareball_demo/views/profile.dart';
import 'package:squareball_demo/views/welcome.dart';

class Home extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {

  int _curIndex = 0;
  Widget content = new Welcome();

  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
        onTap: (index) {
          setState(() {
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                content = new Welcome();
                break;
              case 1:
                content = new Messages();
                break;
              case 2:
                content = new Profile();
                break;
            }
          });
        },
      ),
      // new NavigationBar()
    );
  }
}
