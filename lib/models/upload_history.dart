import 'package:cloud_firestore/cloud_firestore.dart';

class UploadHistory {
  final String? id;
  final String imageUrl;
  final String? wasteType;
  final DateTime timestamp;

  UploadHistory({
    this.id,
    required this.imageUrl,
    this.wasteType,
    required this.timestamp,
  });

  factory UploadHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UploadHistory(
      id: doc.id,
      imageUrl: data['imageUrl'],
      wasteType: data['wasteType'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'wasteType': wasteType,
      'timestamp': timestamp,
    };
  }
}