import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage() async {
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file == null) return null;

  Uint8List bytes = await file.readAsBytes();
  return bytes;
}
