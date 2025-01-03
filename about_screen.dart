import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Library Management System", style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text("Version: 1.0", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                "This is a library management system that allows users to explore books, borrow them, and manage members.",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
