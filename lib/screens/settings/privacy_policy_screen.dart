import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildPolicySection(
            title: '1. Information Collection',
            description:
                'We collect personal data such as your email address and feedback to improve our services.',
          ),
          _buildPolicySection(
            title: '2. Data Usage',
            description:
                'Your data is used solely to enhance user experience and develop better features.',
          ),
          _buildPolicySection(
            title: '3. Data Protection',
            description:
                'We do not share your data with third parties. All user information is securely stored using Firebase services.',
          ),
          _buildPolicySection(
            title: '4. Your Rights',
            description:
                'You have the right to request deletion of your personal data by contacting our support team.',
          ),
          _buildPolicySection(
            title: '5. Changes to Policy',
            description:
                'We may occasionally update this policy. Major changes will be communicated within the app.',
          ),

          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Effective Date: April 2025',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
