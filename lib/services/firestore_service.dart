import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewaste_manager/models/upload_history.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch upload history for the current user
  Future<List<UploadHistory>> getUploadHistory() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('uploads')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UploadHistory.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get upload history: $e');
    }
  }

  // Delete a specific upload history record
  Future<void> deleteUploadHistory(String id) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('uploads')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete upload history: $e');
    }
  }

  // Add a new upload history record for the current user
  Future<void> addUploadHistory({
    required String imageUrl,
    required String wasteType,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('uploads')
          .add({
        'imageUrl': imageUrl,
        'wasteType': wasteType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add upload history: $e');
    }
  }

  // Delete user data from Firestore (called when a user deletes their account)
  Future<void> deleteUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Delete user uploads (could be extended to other user-related data)
      await _deleteUserUploads(userId);

      // Optionally, delete the user document from Firestore if needed
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  // Helper function to delete all uploads related to the current user
  Future<void> _deleteUserUploads(String userId) async {
    try {
      final uploadsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('uploads')
          .get();

      for (var doc in uploadsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user uploads: $e');
    }
  }
}
