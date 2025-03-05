import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 252, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 252, 1),
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
