import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//firestore instance
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
final uid = _auth.currentUser.uid;

//References
CollectionReference users = firestore.collection("users");

//Add to the route collection
Future<void> routeSetup(String origin, String destination, String fare) async {
  users.doc(uid).collection("routes").doc(origin + " - " + destination).set({
    "origin": origin,
    "destination": destination,
    "fare": fare,
  });
}

//Store printed ticket data
Future<void> printSummary(
    String car, route, fare, prints, String date, String time) async {
  users.doc(uid).collection("prints").doc(date).set({});
  users.doc(uid).collection("prints").doc(date).collection(car).add({
    "car": car,
    "route": route,
    "date": date,
    "fare": fare,
    "time": time,
    "prints": prints,
  });
}

Future<void> stationDetails(String station, String phone) async {
  users.doc(uid).collection("station").add({
    "station": station,
    "phone": phone,
  });
}

//Add to vehicle collection
Future<void> vehicleSetup(
    String vehicleNumber, String seats, String driver) async {
  users
      .doc(uid)
      .collection("vehicles")
      .doc(vehicleNumber)
      .set({"vehicle": vehicleNumber, "driver": driver, "seats": seats});
}

//Customer data
Future<void> addPassenger(String passName, String passNumber, String relNumber,
    String date, String vehicle, String depTime) async {
  users.doc(uid).collection("passengers").doc(date).set({});
  users
      .doc(uid)
      .collection("passengers")
      .doc(date)
      .collection(vehicle)
      .doc(passName)
      .set({
    "Passenger": passName,
    "car": vehicle,
    "phone": passNumber,
    "relative": relNumber,
    "time": depTime,
  });
}

//Delete from route collection
Future<void> deleteRoute(String route) async {
  users.doc(uid).collection("routes").doc(route).delete();
}

//Delete from vehicle collection
Future<void> deleteVehicle(String vehicle) async {
  users.doc(uid).collection("vehicles").doc(vehicle).delete();
}
