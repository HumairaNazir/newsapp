import 'package:flutter/material.dart';
import 'package:topnewsapp/view/home_screen.dart';
import 'package:topnewsapp/view/categories_screen.dart';
import 'package:topnewsapp/view/bookmarked_screen.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const BookmarkedScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // ✅ Drawer here
      body: _screens[_selectedIndex], // ✅ Each screen has its own AppBar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
