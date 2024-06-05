import 'package:contacts_app/contact.dart';
import 'package:flutter/material.dart';

class ContactDetailsView extends StatefulWidget {
  final Contact contact;
  const ContactDetailsView({super.key, required this.contact});

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chi tiết liên hệ"),
      ),
    );
  }
}
