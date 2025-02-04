import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username: (email)',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password:',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                // connect the db and check if user credentials are correct
                // move the next screen, 
              },
            ),
          ],
        ),
      ),
    );
  }
}

// add "click here to register" which will take the user to the registration screen.
