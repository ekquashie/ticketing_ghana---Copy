import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketing_ghana/services/database.dart';

class Routes extends StatefulWidget {
  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  Stream routes = users.doc(uid).collection("routes").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Station Routes"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: routes,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Could not get routes");
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No routes available",
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
                    title: Text(document.id.toString()),
                    subtitle: Text(
                      "Fare: ${document.data()['fare']}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Color(0xffb33939),
                      onPressed: () {
                        deleteRoute(document.id);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Route deleted!"),
                                actions: [
                                  FlatButton(
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
