import 'package:flutter/material.dart';
import 'package:ticketing_ghana/auth/Login.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Login(),
    );
  }
}
