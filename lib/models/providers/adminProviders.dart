import 'package:flutter/foundation.dart';

class AdminProvider extends ChangeNotifier {
  List<dynamic> values = [];
  List<String> fieldNames = [];

  void addToValues(dynamic dbValue) {
    values.add(dbValue);
  }

  void addToFieldNames(String field) {
    fieldNames.add(field);
  }
}
