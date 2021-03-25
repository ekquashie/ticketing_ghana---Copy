import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:ticketing_ghana/Help.dart';
import 'package:ticketing_ghana/components/Passengers.dart';
import 'package:ticketing_ghana/components/Summary.dart';
import 'package:ticketing_ghana/components/AddCar.dart';
import 'package:ticketing_ghana/components/AddRoute.dart';
import 'components/Cars.dart';
import 'components/Routes.dart';
import 'services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Print.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey();

  String carSelect, routeSelect, stationName, stationPhone;
  var fare, seats, _timer;
  int fareSelect;

  BluetoothManager _bluetoothManager = BluetoothManager.instance;

  List<Map<String, dynamic>> data = [{}];
  Map<String, dynamic> ticketMap = {};

  Stream routeStream = users.doc(uid).collection("routes").snapshots();
  Stream vehicleStream = users.doc(uid).collection("vehicles").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tticksy'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: Icon(
              Icons.power_settings_new_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  stationName.toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                accountEmail: null,
              ),
            ),
            Divider(color: Colors.black),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Station Setup",
                  style: TextStyle(color: Color(0xff40407a)),
                ),
              ],
            ),
            Divider(color: Colors.black),
            ListTile(
                leading: Icon(
                  Icons.add_road,
                  color: Color(0xff40407a),
                ),
                title: Text(
                  'Register Routes',
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddRoute()));
                }),
            ListTile(
                leading: Icon(
                  Icons.bus_alert,
                  color: Color(0xff40407a),
                ),
                title: Text('Register Cars'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCar()));
                }),
            Divider(color: Colors.black),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Routes & Vehicles",
                  style: TextStyle(color: Color(0xff40407a)),
                ),
              ],
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(
                Icons.map,
                color: Color(0xff40407a),
              ),
              title: Text('Registered Routes'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Routes()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.directions_bus_rounded,
                color: Color(0xff40407a),
              ),
              title: Text('Registered Cars'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cars()));
              },
            ),
            Divider(color: Colors.black),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Passengers & Reports",
                  style: TextStyle(color: Color(0xff40407a)),
                ),
              ],
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: Color(0xff40407a),
              ),
              title: Text('Passengers'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Passengers()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: Color(0xff40407a)),
              title: Text('Ticket Reports'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Summary()));
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(Icons.report, color: Color(0xffb33939)),
              title: Text(
                'Help',
                style: TextStyle(color: Color(0xffb33939)),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Help()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: vehicleStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        List<DropdownMenuItem> cars = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.docs[i];
                          cars.add(DropdownMenuItem(
                            child: Text(
                              documentSnapshot.id +
                                  " (" +
                                  documentSnapshot.data()['driver'] +
                                  ")",
                            ),
                            value: "${documentSnapshot.id}",
                          ));
                        }
                        return DropdownButtonFormField(
                          hint: Text("Select vehicle",
                              style: TextStyle(color: Color(0xff40407a))),
                          items: cars,
                          onChanged: (car) {
                            final snackBar = SnackBar(
                              content: Text("You selected $car"),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              carSelect = car;
                            });
                          },
                          value: carSelect,
                          isExpanded: false,
                        );
                      }
                    }),
                Builder(builder: (context) {
                  if (carSelect == null) {
                    return Text("");
                  } else {
                    users
                        .doc(uid)
                        .collection("vehicles")
                        .doc(carSelect)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        setState(() {
                          seats = documentSnapshot.data()['seats'];
                        });
                      } else {
                        print('Car does not exist');
                      }
                    });
                    return Text(seats.toString() + " seats");
                  }
                }),
                SizedBox(
                  height: 25,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: routeStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        List<DropdownMenuItem> routes = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.docs[i];
                          String id = documentSnapshot.id;
                          routes.add(DropdownMenuItem(
                            child: Text(id),
                            value: id,
                          ));
                        }
                        return DropdownButtonFormField(
                          hint: Text("Select route",
                              style: TextStyle(color: Color(0xff40407a))),
                          items: routes,
                          onChanged: (route) {
                            final snackBar = SnackBar(
                              content: Text("You selected $route"),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              routeSelect = route;
                            });
                          },
                          value: routeSelect,
                          isExpanded: false,
                        );
                      }
                    }),
                Builder(builder: (context) {
                  if (routeSelect == null) {
                    return Text('');
                  } else {
                    users
                        .doc(uid)
                        .collection("routes")
                        .doc(routeSelect)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        setState(() {
                          fare = documentSnapshot.data()['fare'];
                          fareSelect = int.parse(fare);
                        });
                      } else {
                        print('No route');
                      }
                    });
                    return Text("Fare is GHS " + fareSelect.toString());
                  }
                }),
                Builder(builder: (context) {
                  users
                      .doc(uid)
                      .collection("station")
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      setState(() {
                        stationName = doc['station'];
                        stationPhone = doc['phone'];
                      });
                    });
                  });
                  return Text("");
                }),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  onPressed: () {
                    _bluetoothManager.state.listen((val) {
                      if (val == 12 && _formKey.currentState.validate()) {
                        if (routeSelect != null &&
                            carSelect != null &&
                            fareSelect != null) {
                          ticketMap = {
                            "route": routeSelect,
                            "car": carSelect,
                            "fare": fareSelect,
                            "station": stationName,
                            "phone": stationPhone,
                          };
                        }
                        for (int i = 0; i < int.parse(seats); i++) {
                          setState(() {
                            data.add(ticketMap);
                          });
                        }
                        if (routeSelect != null &&
                            carSelect != null &&
                            fareSelect != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Print(data)));
                        }
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext builderContext) {
                              _timer = Timer(Duration(seconds: 5), () {
                                Navigator.of(context).pop();
                              });
                              return AlertDialog(
                                title: Text('Loading printers...'),
                              );
                            }).then((val) {
                          if (_timer.isActive) {
                            _timer.cancel();
                          }
                        });
                      } else if (val == 10) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Bluetooth Disconnected!"),
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
                    });
                  },
                  child: Text(
                    'Print Ticket',
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
