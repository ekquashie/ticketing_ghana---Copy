import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ticketing_ghana/services/database.dart';

class Passengers extends StatefulWidget {
  @override
  _PassengersState createState() => _PassengersState();
}

class _PassengersState extends State<Passengers> {
  MaskedTextController _dayController = MaskedTextController(mask: "00");
  MaskedTextController _monthController = MaskedTextController(mask: "00");
  MaskedTextController _yearController = MaskedTextController(mask: "0000");
  List<Map<String, dynamic>> passengers = [{}];
  Map<String, dynamic> passengerMap = {};

  var dateSelect = formatDate(DateTime.now(), [dd, "-", mm, "-", yyyy]);
  var carSelect = " ";
  Stream<QuerySnapshot> vehicleStream =
      users.doc(uid).collection('vehicles').snapshots();
  Stream<QuerySnapshot> passStream =
      users.doc(uid).collection('passengers').snapshots();
  CollectionReference passengerRef = users.doc(uid).collection('passengers');
  var tempCar, tempDate, newDay, newMonth, newYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passengers"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: users
              .doc(uid)
              .collection("passengers")
              .doc(dateSelect)
              .collection(carSelect)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Could not get reports");
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (carSelect == " ") {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Select a car to view passengers")),
                ],
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text("${document.id}" + " (${document.data()['car']})"),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text("Phone number: ${document.data()['phone']}"),
                            Text(
                                "Relative's Contact: ${document.data()['relative']}"),
                          ],
                        ),
                        Text(" ${document.data()['time']}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "date",
            child: Icon(Icons.calendar_today),
            backgroundColor: Color(0xff40407a),
            onPressed: () {
              dateDialog(context);
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "car",
            onPressed: () {
              carDialog(context);
            },
            child: Icon(Icons.directions_bus),
            backgroundColor: Color(0xff40407a),
          ),
        ],
      ),
    );
  }

  dateDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Date"),
            content: Form(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                        controller: _dayController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => newDay = value);
                        },
                        decoration: InputDecoration(
                            hintText: "Day",
                            contentPadding: EdgeInsets.all(10))),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Flexible(
                    child: TextFormField(
                        controller: _monthController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => newMonth = value);
                        },
                        decoration: InputDecoration(
                            hintText: "Month",
                            contentPadding: EdgeInsets.all(10))),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Flexible(
                    child: TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => newYear = value);
                        },
                        decoration: InputDecoration(
                            hintText: "Year",
                            contentPadding: EdgeInsets.all(10))),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("CANCEL",
                        style: TextStyle(color: Color(0xff40407a))),
                  ),
                  SizedBox(width: 40),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          dateSelect = newDay + "-" + newMonth + "-" + newYear;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "CHANGE",
                        style: TextStyle(color: Color(0xffb33939)),
                      )),
                ],
              )
            ],
          );
        });
  }

  carDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StreamBuilder<QuerySnapshot>(
                stream: vehicleStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    List<DropdownMenuItem> cars = [];
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[i];
                      cars.add(DropdownMenuItem(
                        child: Text(documentSnapshot.id),
                        value: "${documentSnapshot.id}",
                      ));
                    }
                    return DropdownButtonFormField<dynamic>(
                      hint: Text("Select vehicle",
                          style: TextStyle(color: Color(0xff40407a))),
                      items: cars,
                      onChanged: (car) {
                        setState(() {
                          tempCar = car;
                        });
                      },
                      value: tempCar,
                      isExpanded: false,
                    );
                  }
                }),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: TextStyle(color: Color(0xffb33939))),
                  ),
                  SizedBox(width: 40),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          carSelect = tempCar.toString();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Select",
                        style: TextStyle(color: Color(0xff40407a)),
                      )),
                ],
              )
            ],
          );
        });
  }
}
