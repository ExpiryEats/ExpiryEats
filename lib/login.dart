import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('log In Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Log In'),
          onPressed: () {
            // what happens after button press
            // move the home screen
          },
        ),
      ),
    );
  }
}
// add username field
// add password field
// add "click here to register" which will take the user to the registration screen.
