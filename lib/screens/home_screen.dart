import 'package:expiry_eats/screens/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/widgets/app_bar.dart';
import 'package:expiry_eats/screens/dashboard_screen.dart';
import 'package:expiry_eats/screens/inventory_screen.dart';
import 'package:expiry_eats/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  final List<Widget> _pages = [
    const DashboardScreen(),
    const InventoryScreen(),
    const RecipeScreen(),
    const NotificationScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
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
      appBar: Constants.customAppBar(context: context, title: 'Expiry Eats'),
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
        unselectedItemColor: AppTheme.unselected,
        unselectedLabelStyle: TextStyle(color: AppTheme.unselected),
        currentIndex: _selectedIndex,
        onTap: onTapHandler,
        items: _bottomNavigationBarItems,
      ),
    );
  }
}
