import 'package:flutter/material.dart';
import 'package:squareball_demo/models/user.dart';
import 'package:squareball_demo/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  @override
  State createState() => new LoginPage();
}

class LoginPage extends State<Login> with SingleTickerProviderStateMixin {
  final LocalStorage storage = new LocalStorage('messages');

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 1)).then((_) => showMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) => showMessage());
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.decelerate,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  void showMessage() {
    final String message = storage.getItem('message');
    print(message);
    if (message != 'Correct logout!') {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text('Welcome', textAlign: TextAlign.center)));
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(message, textAlign: TextAlign.center)));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottomOpacity: 0,
          backgroundColor: const Color(0xFFFFFFFF),
          leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: _iconAnimation.value * 50.0,
                  width: _iconAnimation.value * 50.0,
                  child: Image(
                    image: AssetImage('assets/icon.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ]),
          //Put to left side in the appBar shomething (IMPORTANT)
          centerTitle: true,
          title: Text('Squareball Studios ™',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: _iconAnimation.value * 20.0)),
        ),
        body: new FormLogin());
  }
}

class FormLogin extends StatefulWidget {
  FormLoginState createState() {
    return FormLoginState();
  }
}

class FormLoginState extends State<FormLogin>
    with SingleTickerProviderStateMixin {
      
  final LocalStorage storage = new LocalStorage('user');

  String _username, _password;

  bool showPassword;

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    showPassword = false;
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

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: _iconAnimation.value * 200.0,
            width: _iconAnimation.value * 200.0,
            child: Image(
              image: AssetImage('assets/2160by3840.png'),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            width: 300.0,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your email';
                } else if (!validateEmail(value)) {
                  return 'Invalid Email';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'username'),
              onSaved: (value) => _username = value,
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 40.0),
              width: 300.0,
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )),
                onSaved: (value) => _password = value,
                obscureText: !showPassword,
              )),
          Center(
            child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    login();
                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(content: Text('Processing Data...')));
                    // Future.delayed(const Duration(milliseconds: 4500), () {
                    //   afterLoginAction();
                    //   //  Navigator.pushNamed(context, '/home').then((_) => afterLoginAction());
                    // });
                  }
                },
                child: Text('Login'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                textColor: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(top: 80.0),
            child: Text('© Squareball Studios 2019'),
          )
        ],
      ),
    );
  }

  void afterLoginAction(AuthResult data) {
    // new User(data.user.email);
    storage.setItem('email', data.user.email);
    _formKey.currentState.reset();
    Scaffold.of(context)..removeCurrentSnackBar();
    // navigateAndDisplaySelection(context);
  }

  Future<void> login() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Processing Data...', textAlign: TextAlign.center)));
      try {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _username, password: _password);
        afterLoginAction(user);
      } catch (e) {
        print(e.message);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Invalid information', textAlign: TextAlign.center)));
      }
    }
  }

  navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
    setState(() {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text("$result", textAlign: TextAlign.center)));
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }
}
