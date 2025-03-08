import 'package:flutter/material.dart';
// rana's page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 131),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 173, 19, 101),
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
