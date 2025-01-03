import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Members from Firestore
  Stream<List<Member>> getMembers() {
    return _firestore.collection('members').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Member.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
      ),
      body: StreamBuilder<List<Member>>(
        stream: getMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading members'));
          }

          final members = snapshot.data ?? [];

          // Display message when no members are found
          if (members.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                title: Text(member.name),
                subtitle: Text(member.email),
              );
            },
          );
        },
      ),
    );
  }
}

class Member {
  final String name;
  final String email;
  final String role;

  Member({required this.name, required this.email, required this.role});

  factory Member.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Member(
      name: data['name'],
      email: data['email'],
      role: data['role'],
    );
  }
}
