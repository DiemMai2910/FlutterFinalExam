import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'contact_details.dart';
import 'contact_firestore.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final ContactFirestore contactFirestore = ContactFirestore();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController _searchController;
  final contactNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Thêm liên hệ'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        contactFirestore.addContact(contactNameController.text,
                            phoneNumberController.text);
                        Navigator.of(context).pop();
                        contactNameController.clear();
                        phoneNumberController.clear();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Thêm liên hệ thành công!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK")),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.save),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Tên liên hệ"),
                          ),
                          controller: contactNameController,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Số điện thoại"),
                          ),
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        leadingWidth: 150,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 5,
            ),
            Center(
                child: Text(
              currentUser!.email!.split('@')[0],
              overflow: TextOverflow.ellipsis,
            )),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
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
                    final name =
                        contact['contactName'].toString().toLowerCase();
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
                            leading: ClipOval(
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/flutter_logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              contact['contactName'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(contact['phoneNumber'].toString()),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.phone),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactDetailsView(
                                    contactId: contact.id,
                                    contactName: contact['contactName'],
                                    phoneNumber: contact['phoneNumber'],
                                  ),
                                ),
                              );
                            },
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
