import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String id;
  String title;
  String author;
  int availableCopies;
  int totalCopies;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.availableCopies,
    required this.totalCopies,
  });

  // Factory constructor with updated DocumentSnapshot type
  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Book(
      id: doc.id,
      title: data['title'] ?? 'Untitled',
      author: data['author'] ?? 'Unknown',
      availableCopies: data['availableCopies'] ?? 0,
      totalCopies: data['totalCopies'] ?? 0,
    );
  }
}
