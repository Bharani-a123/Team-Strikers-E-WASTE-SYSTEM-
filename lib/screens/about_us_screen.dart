import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 120,
                child: Image.asset('assets/images/app_logo.jpg'), // Update the path accordingly
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'E-Waste Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We are committed to reducing electronic waste by helping users properly recycle their old devices and electronics.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildContactItem(
              Icons.email,
              'Email Us',
              'support@ewastemanager.com',
                  () => _launchUrl('mailto:support@ewastemanager.com'),
            ),
            _buildContactItem(
              Icons.phone,
              'Call Us',
              '+1 (555) 123-4567',
                  () => _launchUrl('tel:+15551234567'),
            ),
            _buildContactItem(
              Icons.language,
              'Visit Website',
              'www.ewastemanager.com',
                  () => _launchUrl('https://www.ewastemanager.com'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Developed By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'GreenTech Solutions',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '© 2023 All Rights Reserved',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
