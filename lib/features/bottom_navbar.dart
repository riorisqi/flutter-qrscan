import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/features/auth/presentation/pages/login.dart';
import 'package:test_flutter/features/home/presentation/pages/home.dart';
import 'package:test_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:test_flutter/features/search/presentation/pages/search_page.dart';
import 'package:http/http.dart' as http;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorShape: const CircleBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected:(value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        indicatorColor: Colors.blueAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        const HomeScreen(),
        const SearchPage(),
        const ProfilePage()
      ][currentPageIndex],
    );
  }

  void logoutButtonAction() async {
    setState(() {
      isLoading = true;
    });

    try{
      String url = "http://172.20.8.136:8000/api/logout/mobile";

      var response = await http.post(Uri.parse(url));

      if(response.statusCode == 200) {
        removeToken();

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        throw Exception('Failed to login');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      const snackBar = SnackBar(
        content: Text('Failed to logout'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
      return null;
    }
  }
  
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}