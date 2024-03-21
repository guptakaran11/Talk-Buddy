// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';

class MediaServices {
  MediaServices(); // i have change this line with MediaServices(){} to MediaServices();

  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files[0];
    } else {
      return null;
    }
  }
}
