import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Reset"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "A password reset link will be sent to your email!",
                  style: TextStyle(color: Color(0xff40407a), fontSize: 20),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) =>
                      value.isEmpty ? 'Enter your email' : null,
                ),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      _formKey.currentState.reset();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Password reset link has been sent!"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Okay"))
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    'Send link',
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Color(0xff40407a),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
