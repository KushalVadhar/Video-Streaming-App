import 'package:flutter/material.dart';
import 'package:video_streaming_app/pages/browse_screen.dart';
import 'package:video_streaming_app/pages/feed_screen.dart';
import 'package:video_streaming_app/pages/go_live.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pages = 0; // Move this variable here to maintain state across rebuilds.

  // List of pages for navigation
  final List<Widget> pages = [
    FeedScreen(),
    GoLive(),
    BrowseScreen(),
  ];

  void onPageChange(int page) {
    setState(() {
      _pages = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pages], // Set the body based on the current page index.
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(224, 64, 251, 1),
        unselectedItemColor: Colors.black,
        onTap: onPageChange,
        currentIndex: _pages,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Browse',
          ),
        ],
      ),
    );
  }
}
