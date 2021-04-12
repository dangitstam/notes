import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/services/auth_service.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                        'Create your account',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 17),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      const SizedBox(height: 17.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter a password';
                          }
                          if (val.length < 6) {
                            return 'Enter a password at least 6 characters long';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      const SizedBox(height: 17.0),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please supply a valid email';
                                });
                              }
                            }
                          },
                          style: Theme.of(context).textButtonTheme.style,
                          child: Text(
                            'Sign up'.toUpperCase(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 17.0),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.caption,
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
