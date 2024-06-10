import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ContactFirestore {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference contacts =
      FirebaseFirestore.instance.collection("Contacts");
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Thêm liên hệ
  Future<DocumentReference<Object?>> addContact(
      String contactName, String phoneNumber) async {
    return contacts.add({
      'userEmail': user!.email,  
      'contactName': contactName,
      'phoneNumber': phoneNumber,
    });
  }

  // Cập nhật liên hệ
  Future<void> updateContact(
      String contactId, String contactName, String phoneNumber) async {
    final contactUpdate = {
      'contactName': contactName,
      'phoneNumber': phoneNumber,
    };

    await contacts.doc(contactId).update(contactUpdate);
  }

  // Xóa liên hệ
  Future<void> deleteContact(String contactId) async {
    await contacts.doc(contactId).delete();
  }

  // Lấy danh sách liên hệ
  Stream<QuerySnapshot> getContacts(String email) {
    return contacts
        .where('userEmail', isEqualTo: email)
        .orderBy('contactName')
        .snapshots();
  }
}
