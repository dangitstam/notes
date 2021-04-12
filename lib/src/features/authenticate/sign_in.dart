import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/services/auth_service.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text('loading')
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false, // Prevents widget movement when pulling up keyboard.
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Notes'.toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        'Sign into your account',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 17),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      ),
                      const SizedBox(height: 17),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (val) => val.isEmpty ? 'Enter a password' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      const SizedBox(height: 17),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: Theme.of(context).outlinedButtonTheme.style,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(
                                  () {
                                    loading = false;
                                    error = 'Could not sign in with those credentials';
                                  },
                                );
                              }
                            }
                          },
                          child: Text('Sign in'.toUpperCase()),
                        ),
                      ),
                      const SizedBox(height: 17),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.caption,
                          children: [
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        error,
                        style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
