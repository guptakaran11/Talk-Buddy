// ignore_for_file: file_names

import 'dart:developer';

import 'package:file_picker/file_picker.dart';

class MediaServices {
  MediaServices(); // i have change this line with MediaServices(){} to MediaServices();

  Future<PlatformFile?> pickImageFromLibrary() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.isNotEmpty) {
        return result.files[0];
      } else {
        return null; // No file picked or operation canceled
      }
    } catch (e) {
      log('Error picking image: $e'); // Handle and log errors
      return null; // Return null in case of error
    }
  }
}
