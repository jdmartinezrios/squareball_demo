import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squareball_demo/models/user.dart';
import 'package:localstorage/localstorage.dart';

class Welcome extends StatefulWidget {
  WelcomePage createState() => WelcomePage();
}

class WelcomePage extends State<Welcome> with SingleTickerProviderStateMixin {

  final LocalStorage storage = new LocalStorage('messages');

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.decelerate,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  User appUser;
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: getEmail()),
        Container(
          child: RaisedButton(
              onPressed: () {
                logout();
              },
              child: Text('Logout'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              textColor: Colors.white),
        ),
      ],
    );
  }

  Widget getEmail() {
    return Text("Welcome",
        style: TextStyle(
            fontSize: _iconAnimation.value * 30.0,
            color: Colors.black.withOpacity(0.8)));
  }

  Future<void> logout() async {
    try {
      // Navigator.pop(context, 'Correct Logout!');
      storage.setItem('message', 'Correct logout!');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message, textAlign: TextAlign.center)));
    }
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }
}
