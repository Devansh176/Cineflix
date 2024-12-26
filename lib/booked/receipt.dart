import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptPage extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  const ReceiptPage({super.key, required this.bookingDetails});

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool _shouldPrint = false;

  String generateRandomSeat() {
    const rows = 'ABCDEFGHIJKLMNOPQRST';
    final random = Random();
    String row = rows[random.nextInt(rows.length)];
    int seatNumber = random.nextInt(50) + 1;
    return '$row$seatNumber';
  }

  Future<void> _generateAndPrintPDF(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              margin: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey300,
                borderRadius: pw.BorderRadius.circular(18),
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 2,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    "Your Ticket",
                    style: pw.TextStyle(
                      fontSize: 24,
                      decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),

                  pw.SizedBox(height: 30),
                  pw.Text(
                    "Title: ",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "${widget.bookingDetails['title'] ?? 'N/A'}",
                    style: pw.TextStyle(fontSize: 18),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 25),
                  pw.Text(
                    "Date: ",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "${widget.bookingDetails['date'] ?? 'N/A'}",
                    style: pw.TextStyle(fontSize: 18),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 25),
                  pw.Text(
                    "Time: ",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "${widget.bookingDetails['time'] ?? 'N/A'}",
                    style: pw.TextStyle(fontSize: 18),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 25),
                  pw.Text(
                    "Seat: ",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "${widget.bookingDetails['seats'] ?? generateRandomSeat()}",
                    style: pw.TextStyle(fontSize: 18),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 25),
                  pw.Text(
                    "Total Cost: ",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "${widget.bookingDetails['cost'] ?? '0'}",
                    style: pw.TextStyle(fontSize: 18),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 25),
                  pw.Text(
                    "Status: ${widget.bookingDetails['status'] ?? 'N/A'}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: widget.bookingDetails['status'] == 'Success'
                          ? PdfColors.green
                          : PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    // textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (_shouldPrint) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return pdf.save();
        },
      );
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/ticket.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is your movie ticket!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.05;
    final double fontSize = screenSize.width * 0.05;
    final double height = screenSize.height;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.getTheme() ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.17),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Your Ticket",
                  style: GoogleFonts.afacad(
                    fontSize: fontSize * 1.3,
                    color: themeProvider.getTheme() ? Colors.white : Colors.black,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _shouldPrint = false;
                  });
                  await _generateAndPrintPDF(context);
                },
                icon: Icon(
                  Icons.share,
                  color: themeProvider.getTheme() ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Card(
              color: themeProvider.getTheme() ? Colors.white10 : Colors.white70,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.01),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${widget.bookingDetails['title'] ?? 'N/A'}",
                        style: GoogleFonts.afacad(
                          fontSize: fontSize * 1.9,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTheme()
                              ? Colors.amber
                              : Colors.yellow[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      "Date: ${widget.bookingDetails['date'] ?? 'N/A'}",
                      style: GoogleFonts.afacad(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color:
                        themeProvider.getTheme() ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "Time: ${widget.bookingDetails['time'] ?? 'N/A'}",
                      style: GoogleFonts.afacad(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color:
                        themeProvider.getTheme() ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "Seat: ${widget.bookingDetails['seats'] ?? generateRandomSeat()}",
                      style: GoogleFonts.afacad(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color:
                        themeProvider.getTheme() ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "Total Cost: ₹${widget.bookingDetails['cost'] ?? '0'}",
                      style: GoogleFonts.afacad(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color:
                        themeProvider.getTheme() ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.08),
                    Text(
                      "Status: ${widget.bookingDetails['status'] ?? 'N/A'}",
                      style: GoogleFonts.afacad(
                        color: widget.bookingDetails['status'] == 'Success'
                            ? Colors.green
                            : Colors.red[700],
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _shouldPrint = true;
              });
              _generateAndPrintPDF(context);
            },
            child: Text(
              "Print",
              style: GoogleFonts.afacad(
                color: themeProvider.getTheme() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: fontSize * 0.9,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.getTheme() ? Colors.black : Colors.white,
              textStyle: TextStyle(
                fontSize: fontSize * 0.85,
                fontWeight: FontWeight.bold,
              ),
              side: BorderSide(
                color: themeProvider.getTheme() ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
