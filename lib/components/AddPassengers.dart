import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_ghana/Home.dart';
import 'package:ticketing_ghana/services/database.dart';

class AddPassenger extends StatefulWidget {
  final car, time, prints;
  AddPassenger(this.car, this.time, this.prints);
  @override
  _AddPassengerState createState() => _AddPassengerState();
}

class _AddPassengerState extends State<AddPassenger> {
  final date = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  GlobalKey<FormState> _formKey = GlobalKey();
  var passName, passNumber, relNumber;
  int count = 0;

  checkSeats(counter) {
    if (counter == widget.prints) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  Future<bool> _backButtonPressed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to exit"),
            actions: [
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text("NO", style: TextStyle(color: Color(0xff40407a))),
                  ),
                  SizedBox(width: 50),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text(
                        "YES",
                        style: TextStyle(color: Color(0xffb33939)),
                      )),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              warningDialog(context);
            },
          ),
          title: Text(
            "Passengers",
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) =>
                        value.isEmpty ? 'Enter passenger name' : null,
                    onChanged: (value) {
                      setState(() => passName = value);
                    },
                    decoration: InputDecoration(
                      labelText: "Passenger's Name",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value.isEmpty ? "Enter passenger's phone number" : null,
                    onChanged: (value) {
                      setState(() => passNumber = value);
                    },
                    decoration: InputDecoration(
                      labelText: "Passenger's phone number",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value.isEmpty ? "Enter relative's phone number" : null,
                    onChanged: (value) {
                      setState(() => relNumber = value);
                    },
                    decoration: InputDecoration(
                      labelText: "Relative's phone number",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.reset();
                        passAlert(context);
                        addPassenger(passName, passNumber, relNumber, date,
                            widget.car, widget.time);
                        count++;
                        checkSeats(count);
                      }
                    },
                    child: Text(
                      'Save',
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
      ),
    );
  }

  warningDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to exit"),
            actions: [
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text("NO", style: TextStyle(color: Color(0xff40407a))),
                  ),
                  SizedBox(width: 50),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text(
                        "YES",
                        style: TextStyle(color: Color(0xffb33939)),
                      )),
                ],
              )
            ],
          );
        });
  }

  passAlert(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Passenger added successfully!"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          );
        });
  }
}
