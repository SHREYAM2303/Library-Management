import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login_screen.dart';
import 'screens/books_screen.dart'; // Correct path to BooksScreen
import 'screens/members_screen.dart'; // Correct path to MembersScreen
 // Make sure to import your MembersScreen
import 'package:flutter/foundation.dart'; // Required for kIsWeb

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization for web and mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBg35c06UK2_WBN3OgDqZMsvXC9SEafP84",
        authDomain: "library-management-fb088.firebaseapp.com",
        projectId: "library-management-fb088",
        storageBucket: "library-management-fb088.firebasestorage.app",
        messagingSenderId: "476277016011",
        appId: "1:476277016011:web:02360d291b4c052992e24e",
        measurementId: "G-KH8JW0YWMB",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Start with the login screen
      home: LoginScreen(),
      routes: {
        // Add routes for BooksScreen and MembersScreen
        '/books': (context) => BooksScreen(),
        '/members': (context) => MembersScreen(),
      },
    );
  }
}
