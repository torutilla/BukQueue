import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class GeneratePDF {
  final pw.Widget? childWidget;
  GeneratePDF({this.childWidget});

  Future<Uint8List> createPDF() {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) {
        return pw.Center(child: childWidget);
      },
    ));
    return pdf.save();
  }

  Future<void> savePDF(Uint8List pdfData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');

    await file.writeAsBytes(pdfData);
    print('PDF saved to: ${file.path}');
  }
}
