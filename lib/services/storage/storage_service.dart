import 'package:flutter/material.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Phương thức chọn ảnh từ thư viện
  Future<File?> pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Phương thức tải lên hình ảnh lên Firebase Storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Lấy tên tệp ảnh để tải lên
      String fileName = basename(imageFile.path);

      // Tạo tham chiếu đến Firebase Storage
      Reference storageRef = _storage.ref().child('images/$fileName');

      // Tải lên ảnh
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Chờ quá trình tải lên hoàn thành
      TaskSnapshot snapshot = await uploadTask;

      // Lấy URL hình ảnh sau khi tải lên
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
