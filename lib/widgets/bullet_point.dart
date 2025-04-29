import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint(this.items, {super.key});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> output = <Widget>[];
    for (String item in items) {
      // Add list item
      output.add(BulletPointItem(item));
      // Add space between items
      output.add(SizedBox(height: 5.0));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: output
      ),
    );
  }
}

class BulletPointItem extends StatelessWidget {
  const BulletPointItem(this.item, {super.key});
  final String item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• $item", style: AppTextStyle.small()),
      ],
    );
  }
}