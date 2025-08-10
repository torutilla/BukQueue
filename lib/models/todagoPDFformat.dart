import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class TodagoPdfFormat {
  pw.Font? ttf;
  pw.MemoryImage? image;
  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<pw.Font> useFont(String fontNameInAssets) async {
    final font = await rootBundle.load(fontNameInAssets);
    return pw.Font.ttf(font);
  }

  Future<void> init() async {
    final font = await rootBundle.load("assets/Fonts/futura medium bt.ttf");
    ttf = pw.Font.ttf(font);
    final imageBytes = await loadImageFromAssets('assets/images/BUKYOU.png');
    image = pw.MemoryImage(imageBytes);
  }

  pw.Widget build(pw.Widget childWIdget) {
    return pw.Column(children: [
      pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        // pw.Image(
        //   image!,
        //   height: 60,
        // ),
        pw.Column(children: [
          pw.Text(
            'BukQUEUE',
            style: pw.TextStyle(font: ttf, fontSize: 24),
          ),
          pw.Text(
            'Mobile Booking Application for Bukyo Transportation in Tagaytay City',
          ),
        ])
      ]),
      childWIdget,
    ]);
  }
}
