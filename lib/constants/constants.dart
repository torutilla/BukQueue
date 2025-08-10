import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

final pdfHeaderColor = PdfColor.fromHex('#89CFF0');
const primaryColor = Color.fromRGBO(5, 99, 47, 1);
const secondaryColor = Color.fromARGB(255, 12, 196, 95);
const grayColor = Color.fromARGB(255, 124, 124, 124);
const blackColor = Color.fromARGB(255, 31, 31, 31);
const grayInputBox = Color.fromARGB(255, 224, 224, 224);
const invalidInput = Color.fromARGB(255, 252, 14, 14);
const accentColor = Color.fromARGB(255, 221, 147, 36);
const errorColor = Color.fromARGB(255, 187, 3, 3);
const warningColor = Color.fromARGB(255, 223, 145, 1);
const successColor = Color.fromARGB(255, 0, 236, 106);
const adminGradientColor1 = Color(0xFF444C5B);
const adminGradientColor2 = Color(0xFF1D2128);
const adminGradientColor3 = Color.fromARGB(255, 40, 48, 63);
const adminGradientColor4 = Color.fromARGB(255, 26, 30, 37);
const softWhite = Color.fromARGB(255, 236, 236, 236);

const Gradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);
