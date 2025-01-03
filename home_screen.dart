import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'members_screen.dart';
import 'chatbot_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Library Home")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),  // Add padding around GridView
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,  // Add spacing between columns
            mainAxisSpacing: 8.0,   // Add spacing between rows
            children: [
              _buildFeatureCard(context, Icons.book, "Explore Books", BooksScreen()),
              _buildFeatureCard(context, Icons.people, "Manage Members", MembersScreen()),
              _buildFeatureCard(context, Icons.chat, "Query", ChatbotScreen()),
              _buildFeatureCard(context, Icons.info, "About", AboutScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, Widget screen) {
    return Card(
      elevation: 4,  // Add shadow to make the card stand out
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),  // Rounded corners
      child: InkWell(
        borderRadius: BorderRadius.circular(10),  // Match border radius
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Add padding inside each card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),  // Custom icon color
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
