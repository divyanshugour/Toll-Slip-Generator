import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Generate extends StatefulWidget {
  const Generate({super.key});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {

  // variables and controllers.
  TextEditingController vehicleNumberController = TextEditingController();
  String? lane = "CHANGEABLE";
  String? ticketNumber = "CHANGEABLE";
  String? vehicleNumber = "CHANGEABLE";
  String? vehicleClass = "CHANGEABLE";
  String? shift = "CHANGEABLE";
  String? amount = "CHANGEABLE";
  String? allowedWeight = "CHANGEABLE";
  String? dateTime = "CHANGEABLE";


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
              mainAxisAlignment: pw.MainAxisAlignment.center,
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
                        entryWidget('TICKET NUMBER', ticketNumber,
                            pw.FontWeight.normal),
                        entryWidget('LANE', lane, pw.FontWeight.normal),
                        entryWidget(
                            'TICKET', 'SINGLE TICKET', pw.FontWeight.bold),
                        entryWidget(
                            'VEHICLE NO', vehicleNumber, pw.FontWeight.normal),
                        entryWidget('VEHICLE CLASS', vehicleClass,
                            pw.FontWeight.normal),
                        entryWidget('SHIFT', shift, pw.FontWeight.normal),
                        entryWidget(
                            'TICKET AMOUNT', 'Rs.$amount', pw.FontWeight.bold),
                        entryWidget('NON FASTAG VEHICLE CHARGE', 'Rs.0',
                            pw.FontWeight.bold),
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
                      entryWidget('ALLOWED WEIGHT', allowedWeight,
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
                      entryWidget('ISSUE DATE', dateTime, pw.FontWeight.normal),
                      entryWidget(
                          'TOTAL AMOUNT', 'Rs.$amount', pw.FontWeight.bold),
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
          title: const Text(
            'Generate Slip',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.blueAccent,
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          actions: [
            Container(
              child: TextField(
                controller: vehicleNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ENTER VEHICLE NUMBER',
                ),
              ),
            ),
            DropDown(
              items: const ["LANE2", "LANE3"],
              hint: const Text('LANE'),
              onChanged: (value) {
                lane = value;
              },
            ),
            DropDown(
              items: const ["Lcv/Lmv", "Mav", "Truck"],
              hint: const Text('VEHICLE CLASS'),
              onChanged: (value) {
                if (value == 'Lcv/Lmv') {
                  vehicleClass = value;
                  amount = '105';
                  allowedWeight = '12590';
                } else if (value == 'Mav') {
                  vehicleClass = value;
                  amount = '510';
                  allowedWeight = '29400';
                } else if (value == 'Truck') {
                  vehicleClass = value;
                  amount = '225';
                  allowedWeight = '19425';
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  vehicleNumber = vehicleNumberController.text;
                  dateTime = DateTime.now().toString().split('.')[0];
                });
              },
              child: const Text('SAVE'),
            ),
          ],
          build: (format) => _generatePdf(format, 'slip'),
        ),
      ),
    );
  }
}
