import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'contact_update.dart';
import 'contact_firestore.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({Key? key}) : super(key: key);

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final ContactFirestore contactFirestore = ContactFirestore();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            builder: (context) => const ContactUpdate(),
          ).then((value) {
            if (value != null) {
              contactFirestore.addContact(
                value['name'] ?? '',
                value['phoneNumber'] ?? '',
              );
            }
          });
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Danh Bạ'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Cập nhật UI khi truy vấn tìm kiếm thay đổi
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: contactFirestore.getContacts(currentUser!.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Hiện không có liên lạc mới nào"),
                    ),
                  );
                } else {
                  final contacts = snapshot.data!.docs;
                  final searchQuery = _searchController.text.toLowerCase();
                  final filteredContacts = contacts.where((contact) {
                    final name = contact['contactName'].toString().toLowerCase();
                    final phoneNumber = contact['phoneNumber'].toString();
                    return name.contains(searchQuery) ||
                        phoneNumber.contains(searchQuery);
                  }).toList();

                  filteredContacts.sort((a, b) => a['contactName']
                      .toString()
                      .toLowerCase()
                      .compareTo(b['contactName'].toString().toLowerCase()));
                      
                  return ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              size: 60,
                            ),
                            title: Text(contact['contactName'], style: const TextStyle(fontWeight: FontWeight.bold),),
                            subtitle:
                                Text(contact['phoneNumber'].toString()),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.phone),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
