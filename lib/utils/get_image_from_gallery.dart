import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getImageFromGallery() async {
  return await ImagePicker()
      .pickImage(source: ImageSource.gallery)
      .then((tempImg) => cropImage(imgFile: File(tempImg!.path)));
}

Future<File?> cropImage({required File imgFile}) async {
  CroppedFile? croppedImg =
      await ImageCropper().cropImage(sourcePath: imgFile.path);
  if (croppedImg == null) return null;
  return File(croppedImg.path);
}
