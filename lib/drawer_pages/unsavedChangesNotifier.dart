import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UnsavedChangesNotifier extends ChangeNotifier {
  bool unsavedChanges = false;
  bool canEdit = false;
  XFile? image;
  void updateImage(XFile newImage) {
    image = newImage;
    notifyListeners();
  }

  void unsaved(bool state) {
    unsavedChanges = state;
    notifyListeners();
  }

  void editState(bool state) {
    canEdit = state;
    notifyListeners();
  }
}
