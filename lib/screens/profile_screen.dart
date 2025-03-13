import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController fullNameController =
      TextEditingController(); //user name
  final TextEditingController emailController = TextEditingController();
  final TextEditingController householdIdController = TextEditingController();
  final TextEditingController dietaryRequirementsController =
      TextEditingController(); // New controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true, // Center the title
      ),
      backgroundColor: AppTheme.primary80,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            padding: const EdgeInsets.all(16.0), // Padding inside the white box
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 500.0, // Set the desired width
                  child: TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    //contentPadding:
                    //EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 500.0, // Set the desired width
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    //contentPadding:
                    //EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 500.0, // Set the desired width
                  child: TextField(
                    controller: householdIdController,
                    decoration: InputDecoration(
                      labelText: 'Household ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    //contentPadding:
                    //EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 500.0, // Set the desired width
                  child: TextField(
                    controller: dietaryRequirementsController,
                    decoration: InputDecoration(
                      labelText: 'Dietary Requirements',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    //contentPadding:
                    //EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
