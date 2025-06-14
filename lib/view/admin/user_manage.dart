import 'package:flutter/material.dart';

class UserManagePage extends StatelessWidget {
  const UserManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Manage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User Manage'),
          ],
        ),
      ),
    );
  }
}