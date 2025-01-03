import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BorrowBookScreen extends StatefulWidget {
  final String bookId;

  BorrowBookScreen({required this.bookId});

  @override
  _BorrowBookScreenState createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
  late DocumentSnapshot bookData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch book data from Firestore
    fetchBookData();
  }

  // Function to fetch book details
  void fetchBookData() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('books').doc(widget.bookId).get();
    setState(() {
      bookData = snapshot;
      isLoading = false;
    });
  }

  // Function to borrow book
  void borrowBook() async {
    int availableCopies = bookData['availableCopies'];
    if (availableCopies > 0) {
      // Decrease availableCopies and update Firestore
      await FirebaseFirestore.instance.collection('books').doc(widget.bookId).update({
        'availableCopies': availableCopies - 1,
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book Borrowed!')));
      Navigator.pop(context);  // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No copies available')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Borrow Book')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract book details
    String title = bookData['title'];
    String author = bookData['author'];
    int availableCopies = bookData['availableCopies'];
    int totalCopies = bookData['totalCopies'];

    return Scaffold(
      appBar: AppBar(title: Text('Borrow Book')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Author: $author', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Total Copies: $totalCopies', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Available Copies: $availableCopies', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: borrowBook,
              child: Text('Borrow Book'),
            ),
          ],
        ),
      ),
    );
  }
}
