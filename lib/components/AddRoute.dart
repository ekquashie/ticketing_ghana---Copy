import 'package:flutter/material.dart';
import 'package:ticketing_ghana/services/database.dart';

class AddRoute extends StatefulWidget {
  @override
  _AddRouteState createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String origin = '', destination = '';
  var fare = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set up your route"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) => value!.isEmpty ? 'Enter origin' : null,
                onChanged: (value) {
                  setState(() => origin = value);
                },
                decoration: InputDecoration(
                  labelText: 'Origin',
                ),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Enter destination' : null,
                onChanged: (value) {
                  setState(() => destination = value);
                },
                decoration: InputDecoration(
                  labelText: 'Destination',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter fare' : null,
                onChanged: (value) {
                  setState(() => fare = value);
                },
                decoration: InputDecoration(
                  labelText: 'Fare',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.reset();
                    routeSetup(origin, destination, fare);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Route added successfully!"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay")),
                            ],
                          );
                        });
                  }
                },
                child: Text(
                  'Add route',
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
