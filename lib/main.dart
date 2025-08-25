import 'package:flutter/material.dart';
import 'package:advertisement_app/ad_registration.dart';
import 'package:advertisement_app/existing_ads.dart';
import 'package:advertisement_app/clothing_store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه آگهی و فروشگاه',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir',
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    AdRegistrationScreen(),
    ExistingAdsScreen(),
    ClothingStoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'ثبت آگهی',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'آگهی های موجود',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'فروشگاه لباس',
          ),
        ],
      ),
    );
  }
}
