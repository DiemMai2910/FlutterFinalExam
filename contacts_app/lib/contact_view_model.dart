import 'contact.dart';
import 'contact_services.dart';
import 'package:flutter/material.dart';

class ContactViewModel extends ChangeNotifier {
  static final _instance = ContactViewModel.__internal();
  factory ContactViewModel() => _instance;
  ContactViewModel.__internal() {
    services.loadItem().then((values) {
      if (values is List<Contact>) {
        contacts.clear();
        contacts.addAll(values);
        notifyListeners();
      }
    });
  }
  final List<Contact> contacts = [];
  final services = ContactServices();

  Future addContact(String name, int phoneNumber, String? image) async {
    var contact = Contact(
      name: name,
      phoneNumber: phoneNumber,
      image: image,
    );
    contacts.add(contact);
    notifyListeners();

    services.addContact(contact);
    return contact;
  }

  Future removeContact(String id) async {
    contacts.removeWhere((item) => item.id == id);
    notifyListeners();

    services.removeContact(id);
  }

  Future updateContact(
      String id, String newName, int newPhoneNumber, String newImage) async {
    try {
      final contact = contacts.firstWhere((contact) => contact.id == id);
      contact.name.value = newName;
      contact.phoneNumber.value = newPhoneNumber;
      contact.image.value = newImage;
      notifyListeners();

      await services.updateContact(contact);
    } catch (e) {
      debugPrint("Không tìm thấy mục với ID $id");
    }
  }
}
