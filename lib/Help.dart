import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tticksy Help Page"),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 25),
                Text(
                  "Adding a route to your account",
                  style: TextStyle(
                    color: Color(0xff40407a),
                    fontSize: 20,
                  ),
                ),
                Text(
                    "Tap on the menu icon and tap on 'Add Route'. Enter the origin, destination and the fare of the route and tap on 'Add route'."),
                SizedBox(height: 15),
                Text(
                  "Adding a vehicle to your account",
                  style: TextStyle(
                    color: Color(0xff40407a),
                    fontSize: 20,
                  ),
                ),
                Text(
                    "Tap on the menu icon and tap on 'Add Vehicle'. Enter the vehicle number, driver's name and the number of seats in the vehicle and tap on 'Add vehicle'."),
                SizedBox(height: 15),
                Text(
                  "Printing a Ticket",
                  style: TextStyle(
                    color: Color(0xff40407a),
                    fontSize: 20,
                  ),
                ),
                Text("(Make sure your device's bluetooth is turned on)",
                    style: TextStyle(
                      color: Color(0xffb33939),
                    )),
                Text(
                    "On the home page, select a vehicle from the dropdown and select a route and tap on 'Print Ticket'. You will be routed to the print page. Tap on the bluetooth printer to print your ticket."),
                Text(
                  "View Ticket Reports",
                  style: TextStyle(
                    color: Color(0xff40407a),
                    fontSize: 20,
                  ),
                ),
                Text(
                    "Tap on the menu icon and tap on 'Ticket Reports' to view list of printed tickets."),
              ],
            ),
          )),
    );
  }
}
