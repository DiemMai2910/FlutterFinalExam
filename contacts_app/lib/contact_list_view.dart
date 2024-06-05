import 'package:flutter/material.dart';

import 'contact_details.dart';
import 'contact_update.dart';
import 'contact_view_model.dart';
import 'contact.dart';
import 'contact_widget.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final viewModel = ContactViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Bạ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                builder: (context) => const ContactUpdate(),
              ).then((value) {
                if (value != null) {
                  viewModel.addContact(
                    value['name'] ?? '',
                    value['phoneNumber'] ?? 0,
                    value['image'] ?? '',
                  );
                }
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {},
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
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return ListView.builder(
                  itemCount: viewModel.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = viewModel.contacts[index];
                    return ContactWidget(
                      key: ValueKey(contact.id),
                      contact: contact,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactDetailsView(
                            contact: contact,
                          ),
                        ));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
