import 'package:flutter/material.dart';
import 'package:ewaste_manager/models/upload_history.dart';
import 'package:ewaste_manager/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<UploadHistory>> _historyFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      _historyFuture = firestoreService.getUploadHistory();
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<UploadHistory>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No upload history found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final history = snapshot.data![index];
                    return _buildHistoryItem(history);
                  },
                );
              },
            ),
    );
  }

  Widget _buildHistoryItem(UploadHistory history) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: history.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        title: Text(
          history.wasteType ?? 'Unknown E-Waste',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a').format(history.timestamp),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteHistoryItem(history.id),
        ),
        onTap: () {
          // Navigate to detailed view
        },
      ),
    );
  }

  Future<void> _deleteHistoryItem(String? id) async {
    if (id == null) return;

    setState(() => _isLoading = true);
    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      await firestoreService.deleteUploadHistory(id);
      _loadHistory(); // Refresh the list
    } catch (e) {
      // Show error message
    } finally {
      setState(() => _isLoading = false);
    }
  }
}