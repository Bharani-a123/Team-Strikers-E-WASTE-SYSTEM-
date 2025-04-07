import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ewaste_manager/services/firebase_auth_service.dart';
import 'package:ewaste_manager/screens/auth/login_screen.dart';
import 'package:ewaste_manager/theme/theme_provider.dart';
import 'package:ewaste_manager/screens/settings/privacy_policy_screen.dart';
import 'package:ewaste_manager/screens/settings/help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _feedbackController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<FirebaseAuthService>(context, listen: false);
      await authService.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Logout failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your feedback");
      return;
    }

    setState(() => _isLoading = true);
    try {
      // TODO: Send feedback to Firestore
      Fluttertoast.showToast(msg: "Feedback submitted successfully");
      _feedbackController.clear();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to submit feedback: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Appearance'),
            _buildSwitchTile(
              Icons.dark_mode,
              'Dark Mode',
              isDarkMode,
                  (value) => themeProvider.toggleTheme(value),
            ),
            const Divider(height: 30),

            _buildSectionTitle('Preferences'),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.blue),
              title: const Text('Check for Updates'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Fluttertoast.showToast(msg: "No updates available");
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.deepPurple),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.orange),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              },
            ),

            const Divider(height: 30),

            _buildSectionTitle('Feedback'),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _buildActionButton(Icons.send, 'Submit Feedback', _submitFeedback),

            const Divider(height: 30),

            _buildSectionTitle('Account'),
            _buildActionButton(Icons.logout, 'Logout', _logout, color: Colors.red),

            const Divider(height: 30),

            Center(
              child: Text(
                'E-Waste Manager v1.0.1',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onPressed, {Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon, color: Colors.white),
        label: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
