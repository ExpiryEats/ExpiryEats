import 'package:expiry_eats/screens/item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';
import 'package:intl/intl.dart'; 


class InventoryItem extends StatelessWidget {
  final int itemId;
  final String? imageUrl;
  final String itemName;
  final String category;
  final String itemDateAdded;
  final String itemExpiryDate;

  const InventoryItem({
    super.key,
    required this.itemId,
    required this.imageUrl,
    required this.itemName,
    required this.category,
    required this.itemDateAdded,
    required this.itemExpiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center( 
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IteminfoScreen(
                    itemId: itemId,
                    itemName: itemName,
                    category: category,
                    itemImage: imageUrl?? 'assets/tesing_image.jpg',
                    itemDateAdded: itemDateAdded,
                    itemExpiryDate: itemExpiryDate,
                  ),
                ),
              );
              debugPrint('Item tapped: $itemName');
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5, 
              child: Row(
                children: [
                  // Image container
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height,
                    child: imageUrl != null? 
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>_buildDefaultImage(),
                    )
                  : _buildDefaultImage(),
                  ),
                  // Text content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start, 
                        children: [
                          Text(
                            itemName,
                            style: AppTextStyle.bold(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),  
                          const SizedBox(height: 32),
                        Text(
                            category,
                            style: AppTextStyle.medium(),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Expiry Date:${DateFormat('dd/MM/yyyy').format(DateTime.parse(itemExpiryDate))}',
                            style: AppTextStyle.medium(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/testing_image.jpg',
      fit: BoxFit.cover,
    );
  }
}