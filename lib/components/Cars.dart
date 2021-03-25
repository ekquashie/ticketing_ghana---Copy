import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketing_ghana/services/database.dart';

class Cars extends StatefulWidget {
  @override
  _CarsState createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  Stream vehicles = users.doc(uid).collection("vehicles").snapshots();

  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Station Vehicles"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: vehicles,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Could not get vehicles");
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No cars available",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
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
                    title: Text(document.id.toString() +
                        " (${document.data()['seats']} seats)"),
                    subtitle: Text(
                      "Driver: " + document.data()["driver"],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Color(0xffb33939),
                      onPressed: () {
                        deleteVehicle(document.id);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Car deleted!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Okay"))
                                ],
                              );
                            });
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
