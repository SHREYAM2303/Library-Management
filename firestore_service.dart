import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../models/member.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new book
  Future<void> addBook(Book book) async {
    try {
      await _db.collection('books').add(book.toMap());
    } catch (e) {
      print('Error adding book: $e');
    }
  }

  // Get list of books
  Future<List<Book>> getBooks() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('books').get();
      return querySnapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  // Add a new member
  Future<void> addMember(Member member) async {
    try {
      await _db.collection('members').add(member.toMap());
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  // Get list of members
  Future<List<Member>> getMembers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('members').get();
      return querySnapshot.docs.map((doc) {
        return Member.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching members: $e');
      return [];
    }
  }
}
