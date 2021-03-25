import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ticketing_ghana/services/database.dart';

class AddCar extends StatefulWidget {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  GlobalKey<FormState> _formKey = GlobalKey();

  String vehicleNumber = '', driver = '', seats = '';
  MaskedTextController _maskedTextController =
      MaskedTextController(mask: 'AA-0000-00');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Station Vehicles"),
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
                controller: _maskedTextController,
                validator: (value) =>
                    value!.isEmpty ? 'Enter vehicle number' : null,
                onChanged: (value) {
                  setState(() => vehicleNumber = value);
                },
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
                ),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Enter driver's name" : null,
                onChanged: (value) {
                  setState(() => driver = value);
                },
                decoration: InputDecoration(
                  labelText: 'Driver',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter number of seats' : null,
                onChanged: (value) {
                  setState(() => seats = value);
                },
                decoration: InputDecoration(
                  labelText: 'Seats',
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
                    setState(() => vehicleNumber = '');
                    vehicleSetup(vehicleNumber, seats, driver);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Vehicle added successfully!"),
                            actions: [
                              TextButton(
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
                  'Add vehicle',
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
