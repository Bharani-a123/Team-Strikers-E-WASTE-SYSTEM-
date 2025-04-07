import 'package:flutter/material.dart';
import 'package:ewaste_manager/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ewaste_manager/screens/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'about_us_screen.dart';
import 'auth/signup_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfileImage());
  }

  Future<void> _loadProfileImage() async {
    final user = Provider.of<FirebaseAuthService>(context, listen: false).getCurrentUser();
    if (user == null) return;

    final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
    try {
      final imageUrl = await storageRef.getDownloadURL();
      print("Fetched Profile Image URL: $imageUrl");
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      print("No profile image found: $e");
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final user = Provider.of<FirebaseAuthService>(context, listen: false).getCurrentUser();
    if (user == null) return;

    final file = File(pickedFile.path);
    final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');

    try {
      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();
      print("Uploaded Image URL: $imageUrl");
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Image upload failed: ${e.toString()}");
    }
  }

  Future<void> _logout() async {
    final confirm = await _showLogoutDialog();
    if (!confirm) return;

    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<FirebaseAuthService>(context, listen: false);
      await authService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Logout failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _showLogoutDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseAuthService>(context).getCurrentUser();
    final email = user?.email ?? 'No email';
    final joinDate = user?.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade100,
                backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.green)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              email,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Member since $joinDate',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildProfileItem('Edit Profile', () {}),
            _buildProfileItem('My Upload History', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            }),
            _buildProfileItem('Help & Support', () {}),
            _buildProfileItem('About App', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            }),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: _isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}