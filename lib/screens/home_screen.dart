import 'package:flutter/material.dart';
import 'package:ewaste_manager/screens/upload_screen.dart';
import 'package:ewaste_manager/screens/profile_screen.dart';
import 'package:ewaste_manager/screens/history_screen.dart';
import 'package:ewaste_manager/screens/settings_screen.dart';
import 'package:ewaste_manager/screens/settings/help_support_screen.dart';
import 'package:ewaste_manager/screens/settings/privacy_policy_screen.dart';
import 'package:ewaste_manager/screens/about_us_screen.dart';
import 'package:ewaste_manager/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({Key? key, this.username}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeContentScreen(username: widget.username),
      const HistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username != null ? 'Welcome, ${widget.username}!' : 'E-Waste Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = Provider.of<FirebaseAuthService>(context, listen: false);
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  final String? username;

  const HomeContentScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username != null ? 'Welcome, $username!' : 'Welcome to E-Waste Manager!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.upload, size: 50, color: Colors.green),
                  const SizedBox(height: 10),
                  const Text(
                    'Upload your e-waste easily and responsibly.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadScreen()),
                      );
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Upload Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            children: [
              _buildActionButton(context, Icons.history, 'Upload History', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              }),
              _buildActionButton(context, Icons.info_outline, 'About E-Waste', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              }),
              _buildActionButton(context, Icons.help_outline, 'Help & Support', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              }),
              _buildActionButton(context, Icons.share, 'Share App', () {
                Share.share('Check out the E-Waste Manager app to dispose of your e-waste responsibly!');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}