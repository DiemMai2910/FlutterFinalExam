import 'contact.dart';
import 'package:localstore/localstore.dart';

class ContactServices {
  Future loadItem() async {
    var db = Localstore.getInstance(useSupportDir: true);
    var mapContact = await db.collection('contacts').get();
    if (mapContact != null && mapContact.isNotEmpty) {
      var contacts = List<Contact>.from(
          mapContact.entries.map((e) => Contact.fromMap(e.value)));
      return contacts;
    }
    return null;
  }

  Future addContact(Contact contact) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('contacts').doc(contact.id).set(contact.toMap());
  }

  Future removeContact(String id) async {
    var db = Localstore.getInstance(useSupportDir: true);
    db.collection('contacts').doc(id).delete();
  }

  Future updateContact(Contact contact) async {
    var db = Localstore.getInstance(useSupportDir: true);
    await db
        .collection('contacts')
        .doc(contact.id)
        .set(contact.toMap(), SetOptions(merge: true));
  }
}
