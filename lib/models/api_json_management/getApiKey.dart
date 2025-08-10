import 'package:flutter/services.dart';

Future<String> getApiKey() async {
  const platform = MethodChannel('com.example.flu/api_key');
  try {
    final String apiKey = await platform.invokeMethod('getApiKey');
    return apiKey;
  } on PlatformException catch (e) {
    print("Failed to get API key: '${e.message}'.");
    return '';
  }
}
