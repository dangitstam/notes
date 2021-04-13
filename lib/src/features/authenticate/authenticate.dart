import 'package:flutter/material.dart';
import 'package:notes/src/features/authenticate/register.dart';
import 'package:notes/src/features/authenticate/sign_in.dart';

// Authenication and login flow adopted from this awesome tutorial:
// https://github.com/iamshaunjp/flutter-firebase/tree/master
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
