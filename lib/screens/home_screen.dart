import 'package:expiry_eats/screens/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/widgets/app_bar.dart';
import 'package:expiry_eats/screens/inventory_screen.dart';

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
    const Center(child: Text('Home Screen will be added here')), // Placeholder widget
    const InventoryScreen(),
    const RecipeScreen(),
    const SizedBox(), // Placeholder for NotificationsScreen
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      backgroundColor: AppTheme.surface,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppTheme.primary40,
        unselectedItemColor: AppTheme.unselected,
        unselectedLabelStyle: TextStyle(color: AppTheme.unselected),
        currentIndex: _selectedIndex,
        onTap: onTapHandler,
        items: _bottomNavigationBarItems,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        foregroundColor: AppTheme.surface,
        backgroundColor: AppTheme.primary80,
        child: Icon(Icons.add)
      ),
    );
  }
}