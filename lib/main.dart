import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'models/user.dart';
import 'Home.dart';
import 'auth/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TicketUser>.value(
      value: Authentication().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Tticksy",
        theme: ThemeData(
            accentColor: Color(0xffb33939),
            fontFamily: 'Nunito',
            primaryColor: Color(0xff40407a)),
        home: Loading(),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Splash()));
    });
    return Scaffold(
        backgroundColor: Color(0xff40407a),
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  Text(
                    "Tticksy",
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Color(0xff40407a),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TicketUser>(context);
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
