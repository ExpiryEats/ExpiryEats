import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:expiry_eats/item.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Item> _expiringItems = [];
  List<Item> _recentItems = [];

  @override
  void initState() {
    super.initState();
    loadExpiringItems();
    loadRecentItems();
  }

  Future<void> loadRecentItems() async {
    final cache = Provider.of<CacheProvider>(context, listen: false).cache;
    if (cache.userId == null) return;

    final allItems = await DatabaseService().getAllItems(cache.userId!);
    final items = allItems.map((data) => Item.fromMap(data)).toList();

    items.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

    setState(() {
      _recentItems = items.take(5).toList().reversed.toList();
    });
  }

  Future<void> loadExpiringItems() async {
    final cache = Provider.of<CacheProvider>(context, listen: false).cache;
    if (cache.userId == null) return;

    final allItems = await DatabaseService().getAllItems(cache.userId!);
    final items = allItems.map((data) => Item.fromMap(data)).toList();

    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));

    final expiringSoon = items.where((item) {
      return item.expirationDate.isBefore(soon);
    }).toList();

    expiringSoon.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

    setState(() {
      _expiringItems = expiringSoon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheProvider>(context).cache;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2E8),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Welcome, ${cache.firstName ?? 'User'}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          if (cache.dietaryRequirements.isNotEmpty)
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: cache.dietaryRequirements.map((requirement) {
                  return Container(
                    height: 32,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary80,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        requirement,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Expiring Soon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: _expiringItems.isEmpty
                ? const Center(child: Text('No items expiring soon!'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _expiringItems.length,
                    itemBuilder: (context, index) {
                      final item = _expiringItems[index];
                      final daysLeft =
                          item.expirationDate.difference(DateTime.now()).inDays;

                      return _buildExpiringCard(
                          item.itemName, daysLeft, item.expirationDate);
                    },
                  ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recently Added',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: _recentItems.isEmpty
                ? const Center(child: Text('No recently added items!'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentItems.length,
                    itemBuilder: (context, index) {
                      final item = _recentItems[index];
                      return _buildRecentCard(item.itemName, item.dateAdded);
                    },
                  ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildExpiringCard(String name, int daysLeft, DateTime expiryDate) {
    Color daysColor;
    if (daysLeft < 0) {
      daysColor = Colors.red;
    } else if (daysLeft == 0) {
      daysColor = Colors.orange;
    } else {
      daysColor = Colors.black87;
    }

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary80),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd/MM/yyyy').format(expiryDate),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            daysLeft == 0
                ? 'Expires today'
                : (daysLeft < 0
                    ? 'Expired ${daysLeft.abs()} day${daysLeft.abs() == 1 ? '' : 's'} ago'
                    : 'In $daysLeft day${daysLeft == 1 ? '' : 's'}'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: daysColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRecentCard(String name, DateTime addedDate) {
  return Container(
    width: 160,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.primary80),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Added: ${DateFormat('dd/MM/yyyy').format(addedDate)}',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const Spacer(),
        const Text(
          'Recently Added',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary80,
          ),
        ),
      ],
    ),
  );
}
