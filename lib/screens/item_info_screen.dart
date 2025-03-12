import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';





class IteminfoScreen extends StatelessWidget {
  final String itemName;


  const IteminfoScreen({
    super.key,
    required this.itemName,
    });

    Future<Map<String, dynamic>> fetchItemInfo() async {
      return {
        'itemName': itemName,
        'category': Category,
        'itemImage': 'assets/testing_image.jpg',
        'itemDateAdded': '2025/03/01',
        'itemExpiryDate': '2025/03/20',
      };
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: (){
              debugPrint('Edit $itemName');
            },
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic >>(
        future: fetchItemInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          } else {
            final itemInfo = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    itemInfo ['itemImage'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    itemInfo ['itemName'],
                    style: AppTextStyle.bold(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Food Category: ${itemInfo['category']}',
                    style:  AppTextStyle.medium(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Date Added: ${itemInfo['itemDateAdded']}',
                    style: AppTextStyle.standard()
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Expiry Date: ${itemInfo['itemExpiryDate']}',
                    style: AppTextStyle.small(),
                  )
                ],
              ),
            );
          }
        }
      )
    );
  }
}