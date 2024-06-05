import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'contact.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactWidget({Key? key, required this.contact, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 60,
          height: 60,
          child: contact.image.value.isNotEmpty
              ? kIsWeb
                  ? Image.network(
                      contact.image.value,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(contact.image.value),
                      fit: BoxFit.cover,
                    )
              : Image.asset(
                  'assets/images/flutter_logo.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(contact.name.value),
      subtitle: Text(contact.phoneNumber.value.toString()),
      onTap: onTap,
    );
  }
}
