import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpUtility {
  static Future<String?> networkUtilityFetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<String?> postUrl(Uri uri, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            "HTTP POST Error for ${uri.path}: ${response.statusCode} - ${response.body}");
        print("Request Body: ${jsonEncode(body)}");
        return null;
      }
    } catch (e) {
      print("Network Utility POST Exception for ${uri.path}: $e");
      return null;
    }
  }
}
