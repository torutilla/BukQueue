import 'dart:typed_data';
import 'package:flutter_try_thesis/admin/generateBoookingHistory.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/models/todagoPDFformat.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/models/dateTimeConverter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTable {
  final GetPhotoLinkOfUser getPhotoLink = GetPhotoLinkOfUser();
  final GetBookingHistoryofUser getHistory = GetBookingHistoryofUser();
  final TodagoPdfFormat pdfFormatTodago = TodagoPdfFormat();
  pw.Table createTable(List<List<dynamic>> data,
      {PdfColor? headerColor,
      Map<int, pw.TableColumnWidth>? columnWidths,
      bool noBorder = false}) {
    return pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(
          color: PdfColors.black,
          width: noBorder ? 0 : 0.5,
        ),
        columnWidths: columnWidths,
        headerDecoration: pw.BoxDecoration(color: headerColor),
        data: data);
  }

  Future<pw.Widget> userInfo(
    Map<String, dynamic> userInfo, {
    bool isDriver = false,
    int historyLimit = 5,
  }) async {
    pw.MemoryImage? image;
    final userUID = userInfo['UID'];
    if (userInfo['Photo Link'] != null) {
      String photoLink = await getPhotoLink.getPhotoLink(userUID);
      final imageBytes = await loadImageFromNetwork(photoLink);
      image = pw.MemoryImage(imageBytes);
    }
    await pdfFormatTodago.init();
    final bookings = await getHistory.generateUserBookingHistory(userUID,
        isDriver: isDriver);
    final fontBody =
        await pdfFormatTodago.useFont('assets/Fonts/Inter_28pt-Light.ttf');
    final fontTitle =
        await pdfFormatTodago.useFont('assets/Fonts/futura medium bt.ttf');
    final titleStyle = pw.TextStyle(font: fontTitle, fontSize: 14);
    final bodyStyle = pw.TextStyle(font: fontBody);
    PdfTable pdfTable = PdfTable();
    List<List<String>> tableData = List.generate(bookings.length, (index) {
      final columns = [
        'Booking Status',
        'Time Stamp',
        'Pickup Location',
        'Dropoff Location',
      ];
      return columns.map((e) {
        var value = bookings[index][e];
        if (value is Timestamp) {
          value = DateTimeConvert().convertTimeStampToDate(value);
        }

        return value.toString();
      }).toList();
    });

    return pw.Container(
      margin: pw.EdgeInsets.all(16),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  margin: pw.EdgeInsets.only(top: 16, right: 8),
                  child: image != null
                      ? pw.Image(image,
                          height: 160, width: 120, fit: pw.BoxFit.cover)
                      : pw.Container(
                          height: 160,
                          width: 120,
                          child: pw.Center(
                              child: pw.Text('No data.', style: bodyStyle)),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#f1f1f1'),
                          ),
                        )),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('User Information', style: titleStyle),
                  pdfTable.createTable([
                    isDriver
                        ? ['Full Name', 'Contact Number', 'Verification Status']
                        : [
                            'Full Name',
                            'Contact Number',
                          ],
                    isDriver
                        ? [
                            userInfo['Full Name'],
                            userInfo['Contact Number'],
                            userInfo['Verification Status'],
                          ]
                        : [
                            userInfo['Full Name'],
                            userInfo['Contact Number'],
                          ],
                  ], headerColor: pdfHeaderColor, noBorder: true),
                  if (isDriver)
                    pw.Text('Vehicle Information', style: titleStyle),
                  if (isDriver)
                    pdfTable.createTable([
                      ['Vehicle Type', 'Body Number', 'Plate Number', 'Zone'],
                      [
                        userInfo['Vehicle Type'],
                        userInfo['Body Number'],
                        userInfo['Plate Number'],
                        userInfo['Zone Number'],
                      ],
                    ], headerColor: pdfHeaderColor),
                  if (isDriver)
                    pdfTable.createTable([
                      ['Operator Name', 'Chassis Number', 'MTOP Number'],
                      [
                        userInfo['Operator Name'],
                        userInfo['Chassis Number'],
                        userInfo['MTOP Number'],
                      ],
                    ], headerColor: pdfHeaderColor),
                ],
              )
            ],
          ),
          pw.Padding(padding: pw.EdgeInsets.all(16)),
          pw.Text('Recent Bookings', style: titleStyle),
          bookings.isEmpty
              ? pw.Text('No bookings made.', style: titleStyle)
              : pdfTable.createTable(columnWidths: {
                  0: pw.FixedColumnWidth(160),
                  1: pw.FixedColumnWidth(160),
                }, [
                  [
                    'Status',
                    'Date',
                    'Pickup',
                    'Dropoff',
                  ],
                  ...tableData.take(historyLimit)
                ])

          // pw.Table(

          //   children: [
          //   pw.TableRow(children: [pw.Text('')])
          // ])
        ],
      ),
    );
  }

  Future<Uint8List> loadImageFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}
