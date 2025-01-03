import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Fetch books with an optional search query
  Stream<List<Book>> getBooks(String query) {
    Query<Map<String, dynamic>> booksCollection = _firestore.collection('books');
    if (query.isNotEmpty) {
      booksCollection = booksCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff');
    }

    return booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Authenticate and borrow book if credentials are valid
  Future<void> borrowBook(String bookId, int availableCopies) async {
    if (availableCopies <= 0) {
      _showDialog('No Copies Available', 'This book is currently out of stock.');
      return;
    }

    String? name = await _promptForMemberCredentials();
    if (name != null) {
      // Reduce the available copies by 1
      await _firestore.collection('books').doc(bookId).update({
        'availableCopies': availableCopies - 1,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrowed successfully!')),
      );

      // Send confirmation email
      await _sendBorrowConfirmationEmail(name);
    }
  }

  // Function to return book and increase available copies
  Future<void> returnBook(String bookId, int availableCopies) async {
    String? name = await _promptForMemberCredentials();
    if (name != null) {
      await _firestore.collection('books').doc(bookId).update({
        'availableCopies': availableCopies + 1,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book returned successfully!')),
      );
    }
  }

  // Show dialog for member credentials
  Future<String?> _promptForMemberCredentials() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    
    bool authenticated = false;
    String? memberName;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Member Authentication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                authenticated = await _authenticateMember(
                    nameController.text, passwordController.text);
                if (authenticated) {
                  memberName = nameController.text;
                  Navigator.pop(context);
                } else {
                  _showDialog('Authentication Failed', 'Invalid credentials.');
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return authenticated ? memberName : null;
  }

  // Function to check if member exists with given credentials
  Future<bool> _authenticateMember(String name, String password) async {
    final snapshot = await _firestore
        .collection('members')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Send borrow confirmation email via Gmail in a web browser
  Future<void> _sendBorrowConfirmationEmail(String memberName) async {
    final memberSnapshot = await _firestore
        .collection('members')
        .where('name', isEqualTo: memberName)
        .limit(1)
        .get();

    if (memberSnapshot.docs.isNotEmpty) {
      final memberData = memberSnapshot.docs.first.data();
      final email = memberData['email'];
      final returnDate = DateTime.now().add(Duration(days: 15));
      final formattedDate = DateFormat('yyyy-MM-dd').format(returnDate);

      // Create the Gmail link
      final subject = Uri.encodeComponent("Borrow Confirmation");
      final body = Uri.encodeComponent(
          "You have successfully borrowed a book. Please return it by $formattedDate.");
      final gmailUrl = "https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body";

      try {
        // Launch the Gmail link
        if (await canLaunch(gmailUrl)) {
          await launch(gmailUrl);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening Gmail to send confirmation email!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open Gmail.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open Gmail.')),
        );
      }
    }
  }

  // Helper to show alert dialogs
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a book',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: getBooks(searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading books'));
                }
                final books = snapshot.data ?? [];
                if (books.isEmpty) {
                  return Center(child: Text('No books found.'));
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(book.title ?? 'No Title'),
                        subtitle: Text('Author: ${book.author ?? 'Unknown'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                borrowBook(book.id, book.availableCopies);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                returnBook(book.id, book.availableCopies);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
