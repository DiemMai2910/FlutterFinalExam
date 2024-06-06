import 'package:flutter/material.dart';

class ContactUpdate extends StatefulWidget {
  final String? initialName;
  final String? initialPhoneNumber;

  const ContactUpdate({
    Key? key,
    this.initialName,
    this.initialPhoneNumber,
  }) : super(key: key);

  @override
  State<ContactUpdate> createState() => _ContactUpdateState();
}

class _ContactUpdateState extends State<ContactUpdate> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm danh bạ'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop({
                'name': nameController.text,
                'phoneNumber': phoneNumberController.text,
              });
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Tên liên hệ"),
                ),
                controller: nameController,
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
  }
}
