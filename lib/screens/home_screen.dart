import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Page Controller
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  
  final List<Widget> _pages = [
    // const BpmScreen(),
    // const HarmonyScreen(),
    // const TunerScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Inventory',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.food_bank_outlined),
      label: 'Recipes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
  ];

  void onTapHandler(int index) {
    setState(() => _selectedIndex = index);

    _pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 750),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.customAppBar(title: 'Expiry Eats'),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: _pages,
      ),
      backgroundColor: AppTheme.surface,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppTheme.primary40,
        currentIndex: _selectedIndex,
        onTap: onTapHandler,
        items: _bottomNavigationBarItems,
      ),
    );
  }
}