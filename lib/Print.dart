import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:date_format/date_format.dart';
import 'package:ticketing_ghana/Home.dart';
import 'package:ticketing_ghana/components/AddPassengers.dart';
import 'services/database.dart';

class Print extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  Print(this.data);
  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  var car, route, seats, fare, prints;
  var stationName, stationPhone, result;
  int count = 1;

  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  final date = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  final dateTime = formatDate(DateTime.now(), [
    dd,
    '-',
    mm,
    '-',
    yyyy,
    '  ',
    HH,
    ':',
    nn,
    " ",
  ]);
  var time = formatDate(DateTime.now(), [
    HH,
    ':',
    nn,
    " ",
  ]);
  Stream stationStream = users.doc(uid).collection("station").snapshots();

  List<PrinterBluetooth> _devices = [];
  late String _deviceMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    bluetoothManager.state.listen((val) {
      if (!mounted) return;
      if (val == 12) {
        print('on');
        initPrinter();
      } else if (val == 10) {
        print('off');
        setState(() {
          _deviceMsg = 'Bluetooth device disconnected';
        });
      }
    });
    initPrinter();
    super.initState();
  }

  Future<bool> _backButtonPressed() {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.backspace),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          title: Text(
            "Select bluetooth device",
          ),
          centerTitle: true,
        ),
        body: _devices.isEmpty
            ? Center(child: Text(_deviceMsg ?? ''))
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.print),
                    title: Text(_devices[index].name),
                    subtitle: Text(_devices[index].address),
                    onTap: () {
                      _startPrint(_devices[index]);
                      widget.data.length = 0;
                    },
                  );
                }),
      ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 1));
    _printerManager.scanResults.listen((event) {
      if (!mounted) return;
      setState(() => _devices = event);
      print(_devices);
      if (_devices.isEmpty) {
        setState(() => _deviceMsg = "No device detected!");
      }
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(result.msg),
            ));
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    for (var i = 1; i < widget.data.length; i++, count++) {
      ticket.row([
        PosColumn(
            text: "${widget.data[i]['station']}",
            styles: PosStyles(
              align: PosTextAlign.center,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              bold: true,
            ),
            width: 12),
      ]);
      ticket.row([
        PosColumn(
          text: "${widget.data[i]['phone']}",
          width: 12,
          styles: PosStyles(
            bold: true,
            width: PosTextSize.size2,
            underline: true,
            height: PosTextSize.size2,
            align: PosTextAlign.center,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: "  ",
          width: 12,
          styles: PosStyles(height: PosTextSize.size1),
        ),
      ]);
      ticket.row([
        PosColumn(text: 'Route: ${widget.data[i]['route']}', width: 12),
      ]);
      ticket.row([
        PosColumn(text: 'Vehicle Number: ${widget.data[i]['car']}', width: 12),
      ]);
      ticket.row([
        PosColumn(text: 'Fare: GHS ${widget.data[i]['fare']}', width: 12),
      ]);
      ticket.row([
        PosColumn(text: 'Balance:    ..........', width: 12),
      ]);
      ticket.row([
        PosColumn(
          text: "  ",
          width: 12,
          styles: PosStyles(
            height: PosTextSize.size1,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(text: 'Luggage:    ..........', width: 12),
      ]);
      ticket.row([
        PosColumn(
          text: "  ",
          width: 12,
          styles: PosStyles(
            height: PosTextSize.size1,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: "Powered by ECEE Systems",
          width: 12,
          styles: PosStyles(
            bold: true,
            align: PosTextAlign.center,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: dateTime.toString(),
          width: 12,
          styles: PosStyles(
            align: PosTextAlign.center,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: count.toString(),
          width: 12,
          styles: PosStyles(
            bold: true,
            align: PosTextAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: "---------------",
          width: 12,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
            align: PosTextAlign.center,
          ),
        ),
      ]);
      ticket.row([
        PosColumn(
          text: " ",
          width: 12,
          styles: PosStyles(
            align: PosTextAlign.center,
          ),
        ),
      ]);
      setState(() {
        car = widget.data[i]['car'];
        route = widget.data[i]['route'];
        fare = widget.data[i]['fare'];
        prints = widget.data.length - 1;
      });
    }
    ticket.cut();
    printSummary(car, route, fare, prints, date, time.toString());
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AddPassenger(car, time, prints)));
    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
