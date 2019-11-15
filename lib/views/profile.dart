import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squareball_demo/models/user.dart';
import 'package:localstorage/localstorage.dart';

class Profile extends StatefulWidget {
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  final LocalStorage storage = new LocalStorage('user');

  String _email, _password;
  bool showPassword;

  @override
  void initState() {
    showPassword = false;
    super.initState();
  }

  final _formKeyProfile = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _buildStack(),
          )
        ],
        // Text('Profile'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKeyProfile,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: getEmailUser(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              } else if (!validateEmail(value)) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Email: '),
                            onSaved: (value) => _email = value,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'This field is required';
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'password: ',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  )),
                              onSaved: (value) => _password = value,
                              obscureText: !showPassword),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            textColor: Colors.white,
                            child: Text("Update"),
                            onPressed: () {
                              updateProfile();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildStack() => Stack(
        alignment: const Alignment(0.0, 0.0),
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/2160by3840.png'),
            radius: 100,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
          ),
        ],
      );

  void updateProfile() async {
    final formState = _formKeyProfile.currentState;
    if (formState.validate()) {
      formState.save();
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Processing Data...', textAlign: TextAlign.center)));
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user
          .updateEmail(_email)
          .then((_) => {
                user
                    .updatePassword(_password)
                    .then((_) => {_dismiss()})
                    .catchError((error) {
                  print(error.toString());
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                          Text(error.toString(), textAlign: TextAlign.center)));
                }),
              })
          .catchError((error) {
        print(error.toString());
      });
    }
  }

  void _dismiss() {
    storage.setItem('email', _email);
    Navigator.pop(context);
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated!', textAlign: TextAlign.center)));
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  String getEmailUser() {
    final email = storage.getItem('email');
    return email;
  }
}
