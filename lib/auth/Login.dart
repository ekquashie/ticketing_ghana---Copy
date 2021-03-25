import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_ghana/ForgotScreen.dart';
import '../services/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Authentication _auth = Authentication();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String email = '', password = '', error = '';
  late ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, isDismissible: false);
    progressDialog.style(message: 'Logging in');
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onChanged: (value) {
                  setState(() => email = value);
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Enter a valid password' : null,
                onChanged: (value) {
                  setState(() => password = value);
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotScreen()),
                    );
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color(0xff40407a),
                    ),
                    textAlign: TextAlign.right,
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.clearPersistence();
                    progressDialog.show();
                    dynamic result =
                        await _auth.signInEmailAndPass(email, password);
                    if (result != null) {
                      progressDialog.hide();
                    }
                    if (result == null) {
                      setState(() => error = 'Invalid Credentials');
                      progressDialog.hide();
                    }
                  }
                },
                child: Text(
                  'Login',
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
    );
  }
}
