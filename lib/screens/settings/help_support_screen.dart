import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildFaqCard(
            question: 'How do I report an issue?',
            answer: 'Use the "Submit Feedback" option in the Settings screen.',
          ),
          _buildFaqCard(
            question: 'How do I change the theme?',
            answer: 'You can toggle between light and dark mode in Settings > Appearance.',
          ),
          _buildFaqCard(
            question: 'I forgot my password. What should I do?',
            answer: 'On the login screen, tap "Forgot Password" to reset it.',
          ),

          const SizedBox(height: 30),
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildContactTile(
            icon: Icons.email,
            title: 'Email',
            subtitle: 'support@ewastemanager.app',
          ),
          _buildContactTile(
            icon: Icons.phone,
            title: 'Call',
            subtitle: '+91 98765 43210 (Mon–Fri, 9AM–6PM)',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(answer, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }
}
