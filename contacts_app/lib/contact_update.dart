import 'package:flutter/material.dart';

class ContactUpdate extends StatefulWidget {
  final String? initialName;
  final int? initialPhoneNumber;
  final String? initialImage;

  const ContactUpdate({
    Key? key,
    this.initialName,
    this.initialPhoneNumber,
    this.initialImage,
  }) : super(key: key);

  @override
  State<ContactUpdate> createState() => _ContactUpdateState();
}

class _ContactUpdateState extends State<ContactUpdate> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneNumberController = TextEditingController(
        text: widget.initialPhoneNumber?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm danh bạ'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop({
                'name': _nameController.text,
                'phoneNumber': int.tryParse(_phoneNumberController.text) ?? 0,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
