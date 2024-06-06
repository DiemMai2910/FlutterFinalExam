import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactFirestore {
  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference contacts =
      FirebaseFirestore.instance.collection("Contacts");

  Future<DocumentReference<Object?>> addContact(
      String contactName, String phoneNumber) async {
    return contacts.add({
      'userEmail': user!.email,
      'contactName': contactName,
      'phoneNumber': phoneNumber,
    });
  }

  Stream<QuerySnapshot> getContacts(String email) {
    return contacts
        .where('userEmail', isEqualTo: email)
        .orderBy('contactName')
        .snapshots();
  }
}
