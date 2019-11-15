import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget{
  NavigationBarComponent createState() => NavigationBarComponent();
}

class NavigationBarComponent extends State<NavigationBar> {

  int _curIndex = 0;
  String contents = 'Welcome';

  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
              icon: Icon(Icons.person),
              title: Text('Profile')
            )
          ],
          onTap: (index) {
            setState(() {
               _curIndex = index;
              switch (_curIndex) {
                case 0:
                  contents = "Home";
                  break;
                case 1:
                  contents = "Messages";
                  break;
                case 2:
                  contents = "Proflle";
                  break;
              }
            });
          },
      );
  }
  
}