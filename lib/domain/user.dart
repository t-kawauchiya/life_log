import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(this.uid, this.email, this.reference);
  String uid;
  String email;
  String name = "";
  DateTime createdAt = DateTime.now();
  final DocumentReference? reference;
}
