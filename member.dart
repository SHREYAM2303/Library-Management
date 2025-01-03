class Member {
  final String? id;
  final String? name;

  Member({this.id, this.name});

  // Factory method to create Member from Firestore data
  factory Member.fromFirestore(Map<String, dynamic> data) {
    return Member(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
