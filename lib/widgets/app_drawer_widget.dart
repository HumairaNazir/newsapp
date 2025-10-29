import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:topnewsapp/utilities/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/theme_provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@topnewsapp.com',
      query: 'subject=Feedback from Top News App',
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch email app');
    }
  }

  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://topnewsapp.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch website');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Row(
              children: [
                const Icon(Icons.newspaper, color: Colors.white, size: 40),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Top News',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Latest headlines daily',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
              Navigator.pop(context);
            },
          ),

          // 🔹 Email Contact
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: const Text('support@topnewsapp.com'),
            onTap: _launchEmail,
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () async {
              Navigator.pop(context);
              try {
                await Share.share(
                  '🗞 Check out Top News App — your daily dose of trending news!\n📲 Download now: https://play.google.com/store/apps/details?id=com.yourappname',
                  subject: 'Top News App',
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to share the app. Please try again.'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, privacyPolicyScreenRoute);
            },
          ),
        ],
      ),
    );
  }
}
