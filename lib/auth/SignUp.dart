import 'package:flutter/material.dart';
import 'package:ticketing_ghana/auth/Login.dart';
import '../services/auth.dart';
import 'package:ticketing_ghana/Home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ticketing_ghana/services/database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Authentication _auth = Authentication();

  late ProgressDialog progressDialog;

  //field state
  String email = '', password = '', station = '', error = '', phone = '';
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    progressDialog.style(message: 'Creating account');
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tticksy",
                  style: TextStyle(color: Color(0xff40407a), fontSize: 30),
                ),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a valid email' : null,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  validator: (value) => value!.length < 6
                      ? 'Password must be 6 characters long'
                      : null,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: obscurePass,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Station'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter station name' : null,
                  onChanged: (value) {
                    setState(() => station = value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter phone number' : null,
                  onChanged: (value) {
                    setState(() => phone = value);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.reset();
                      progressDialog.show();
                      dynamic result =
                          await _auth.registerEmailAndPass(email, password);
                      if (result != null) {
                        progressDialog.hide();
                      }
                      if (result == null) {
                        setState(() => error = 'Could not register user');
                        progressDialog.hide();
                      } else {
                        stationDetails(station, phone);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                    }
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Color(0xff40407a),
                  textColor: Colors.white,
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text("Already have an account? Login",
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          )),
    );
  }
}
