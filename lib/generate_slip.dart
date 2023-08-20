import 'dart:typed_data';
import 'package:collect_toll/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'manage.dart';

class Generate extends StatefulWidget {
  const Generate({super.key});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  // variables and controllers.
  TextEditingController vehicleNumberController = TextEditingController();
  late SharedPreferences prefs;
  late final conn;

  @override
  void initState() {
    // TODO: implement initState
    getVariables().then((value) => {
          if (Variables.dbHost != "" &&
              Variables.dbName != "" &&
              Variables.dbPort != "" &&
              Variables.dbUsername != "" &&
              Variables.dbPassword != "")
            {
              setState(() {
                getConnection();
              })
            }
        });
    super.initState();
  }

  Future<bool?> getVariables() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Variables.dbHost = prefs.getString('host')!;
      Variables.dbPort = prefs.getString('port')!;
      Variables.dbUsername = prefs.getString('dbusername')!;
      Variables.dbPassword = prefs.getString('dbpassword')!;
      Variables.dbName = prefs.getString('dbname')!;
      Variables.endDate = prefs.getString('enddate')!;
    });
  }

  // get SQL connection
  void getConnection() async {
    conn = await MySQLConnection.createConnection(
      host: Variables.dbHost,
      port: int.parse(Variables.dbPort as String),
      userName: Variables.dbUsername as String,
      password: Variables.dbPassword as String,
      databaseName: Variables.dbName, // optional
    );
    await conn.connect();
    Variables.connected = true;
  }

  // each entry row widget
  pw.Container entryWidget(
      String entryName, String? entryData, pw.FontWeight fontWeight) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              entryName,
              style: const pw.TextStyle(
                fontSize: 18,
              ),
            ),
            alignment: pw.Alignment.topLeft,
            width: 250,
          ),
          pw.Container(
            child: pw.Text(
              ':  ',
              style: const pw.TextStyle(
                fontSize: 18,
              ),
            ),
            alignment: pw.Alignment.topRight,
          ),
          pw.Container(
            child: pw.Text(
              entryData!,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: fontWeight,
              ),
            ),
            alignment: pw.Alignment.topLeft,
            width: 250,
          ),
        ],
      ),
    );
  }

  // the whole pdf UI widgets
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.nunitoExtraLight();
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'MPRDC',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'RMN Tollways Ltd.',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('Barwaha-Dhamnod (Barwaha) SH-36 (61.927 \nKM)',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Column(
                      children: [
                        entryWidget(
                            'OPERATOR ID', '1001', pw.FontWeight.normal),
                        entryWidget('TICKET NUMBER', Variables.ticketNumber,
                            pw.FontWeight.normal),
                        entryWidget(
                            'LANE', Variables.lane, pw.FontWeight.normal),
                        entryWidget(
                            'TICKET', 'SINGLE TICKET', pw.FontWeight.bold),
                        entryWidget('VEHICLE NO', Variables.vehicleNumber,
                            pw.FontWeight.normal),
                        entryWidget('VEHICLE CLASS', Variables.vehicleClass,
                            pw.FontWeight.normal),
                        entryWidget(
                            'SHIFT', Variables.shift, pw.FontWeight.normal),
                        entryWidget('TICKET AMOUNT', 'Rs.${Variables.amount}',
                            pw.FontWeight.bold),
                        pw.Row(children: [
                          pw.Text('NON FASTAG VEHICLE CHARGE:  ',
                              style: const pw.TextStyle(
                                fontSize: 18,
                              )),
                          pw.Text('Rs.0',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 18))
                        ])
                      ],
                    ),
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Column(
                    children: [
                      entryWidget('VEHICLE WEIGHT', '0', pw.FontWeight.normal),
                      entryWidget('ALLOWED WEIGHT', Variables.allowedWeight,
                          pw.FontWeight.normal),
                      entryWidget('OVER WEIGHT', '0', pw.FontWeight.normal),
                      entryWidget('O/W AMOUNT', 'Rs.0', pw.FontWeight.bold),
                    ],
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 8),
                  padding: const pw.EdgeInsets.all(5),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(
                    width: 3,
                  ))),
                  child: pw.Column(
                    children: [
                      entryWidget('ISSUE DATE', Variables.dateTime,
                          pw.FontWeight.normal),
                      entryWidget('TOTAL AMOUNT', 'Rs.${Variables.amount}',
                          pw.FontWeight.bold),
                    ],
                  ),
                ),
                pw.Text(
                  'HAPPY JOURNEY',
                  style: const pw.TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 18, 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Background color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text('MANAGE'),
              ),
            ),
          ],
          title: const Text(
            'Generate Slip',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(
                  fontSize: 25,
                  color: Variables.connected ? Colors.black : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                controller: vehicleNumberController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ENTER VEHICLE NUMBER',
                ),
                onChanged: (value) {
                  setState(() {
                    Variables.vehicleNumber = vehicleNumberController.text;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropDown(
                  items: const ["LANE2", "LANE3"],
                  hint: const Text(
                    'LANE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (value) {
                    var val = value;
                    setState(() {
                      Variables.lane = val!;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropDown(
                items: const ["Lcv/Lmv", "Mav", "Truck"],
                hint: const Text(
                  'VEHICLE CLASS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onChanged: (value) {
                  Variables.dateTime = DateTime.now().toString().split('.')[0];
                  String currDate = DateTime.now().toString().split(' ')[0];
                  DateTime firstShift = DateTime.parse("$currDate 00:00:00");
                  DateTime secondShift = DateTime.parse("$currDate 08:00:00");
                  DateTime thirdShift = DateTime.parse("$currDate 16:00:00");
                  DateTime currDateTime = DateTime.parse(Variables.dateTime);

                  if (currDateTime.isAfter(firstShift) &&
                      currDateTime.isBefore(secondShift)) {
                    setState(() {
                      Variables.shift = "FIRST SHIFT";
                    });
                  } else if (currDateTime.isAfter(secondShift) &&
                      currDateTime.isBefore(thirdShift)) {
                    setState(() {
                      Variables.shift = "SECOND SHIFT";
                    });
                  } else if (currDateTime.isAfter(thirdShift) &&
                      currDateTime
                          .isBefore(firstShift.add(Duration(days: 1)))) {
                    setState(() {
                      Variables.shift = "THIRD SHIFT";
                    });
                  }

                  if (value == 'Lcv/Lmv') {
                    setState(() {
                      Variables.vehicleClass = value!;
                      Variables.amount = '105';
                      Variables.allowedWeight = '12590';
                    });
                  } else if (value == 'Mav') {
                    setState(() {
                      Variables.vehicleClass = value!;
                      Variables.amount = '510';
                      Variables.allowedWeight = '29400';
                    });
                  } else if (value == 'Truck') {
                    setState(() {
                      Variables.vehicleClass = value!;
                      Variables.amount = '225';
                      Variables.allowedWeight = '19425';
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  primary: Colors.black, // Background color
                ),
                onPressed: () async {
                  if (Variables.connected &&
                      DateTime.now().isBefore(DateTime.parse(
                          Variables.endDate == ""
                              ? "2050-12-12 00:00:00"
                              : Variables.endDate))) {
                    var res = await conn.execute("SELECT * FROM entries;");
                    Variables.lastSerial = res.numOfRows;
                    await conn.execute(
                      "INSERT INTO entries (SerialNumber, VehicleNumber, VehicleCategory, Amount, DateTime) VALUES (:serial, :number, :category, :amount, :date)",
                      {
                        "serial": Variables.lastSerial + 1,
                        "number": Variables.vehicleNumber,
                        "category": Variables.vehicleClass,
                        "amount": Variables.amount,
                        "date": Variables.dateTime,
                      },
                    );
                    setState(() {
                      String intFixed(int n, int count) =>
                          n.toString().padLeft(count, "0");
                      var number =
                          intFixed(Variables.lastSerial + 1, 14).toString();
                      Variables.ticketNumber = '1A' + number;
                      vehicleNumberController.text = "";
                    });
                  }
                },
                child: const Text('SAVE'),
              ),
            ),
          ],
          build: (format) => _generatePdf(format, 'slip'),
          allowPrinting: DateTime.now().isBefore(DateTime.parse(
              Variables.endDate == ""
                  ? "2050-12-12 00:00:00"
                  : Variables.endDate)),
        ),
      ),
    );
  }
}
