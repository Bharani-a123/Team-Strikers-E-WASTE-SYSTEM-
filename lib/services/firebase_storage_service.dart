import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    try {
      // Create unique filename with timestamp
      String fileName = 'ewaste_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create reference to storage location
      Reference storageRef = _storage.ref().child('uploads/$fileName');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(image);

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      throw Exception('Failed to upload image');
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      // Create reference from download URL
      Reference storageRef = _storage.refFromURL(url);
      await storageRef.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
      throw Exception('Failed to delete image');
    }
  }
}