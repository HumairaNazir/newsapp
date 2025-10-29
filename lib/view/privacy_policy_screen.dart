import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This Privacy Policy explains how the Top News App handles your information.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '• We do not collect any personal information from users.\n'
                '• The app may display public news data fetched from open news APIs.\n'
                '• No login or sign-up is required to use this app.\n'
                '• We do not share or sell any user data to anyone.\n'
                '• This app works offline/online for displaying news content only.\n'
                '• Your data remains private and safe on your device.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'If you have any questions about this policy, please contact us at:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'support@topnewsapp.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
