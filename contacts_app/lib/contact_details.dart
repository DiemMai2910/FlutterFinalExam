import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'contact_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactDetailsView extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String phoneNumber;

  const ContactDetailsView({
    super.key,
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
  });

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  final ContactFirestore contactFirestore = ContactFirestore();
  late String contactId;
  late String contactName;
  late String phoneNumber;
  late TextEditingController contactNameControllerUpdate;
  late TextEditingController phoneNumberControllerUpdate;

  @override
  void initState() {
    super.initState();
    contactId = widget.contactId;
    contactNameControllerUpdate = TextEditingController(text: widget.contactName);
    phoneNumberControllerUpdate = TextEditingController(text: widget.phoneNumber);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chi tiết liên hệ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => editContact(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteContact(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: HexColor("#ecf4f2"),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ClipOval(
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[200],
                          child: Center(
                            child: Image.asset(
                              'assets/images/flutter_logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        contactNameControllerUpdate.text,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text(
                  phoneNumberControllerUpdate.text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Di động | Việt Nam",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Container(
                          color: HexColor("#ecf4f2"),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.call),
                            color: Colors.green,
                          )),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ClipOval(
                      child: Container(
                          color: HexColor("#ecf4f2"),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.messenger),
                            color: Colors.green,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Xóa liên hệ
  void deleteContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bạn có chắc chắn muốn xóa liên hệ này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                contactFirestore.deleteContact(contactId);
                Navigator.of(context).pop(); //Đóng Dialog
                Navigator.of(context).pop(); //ĐÓng Details view
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  // Chỉnh sửa thông tin liên hệ
  void editContact(BuildContext context) {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sửa liên hệ'),
            actions: [
              IconButton(
                onPressed: () {
                  contactFirestore.updateContact(contactId,
                      contactNameControllerUpdate.text, phoneNumberControllerUpdate.text);
                  Navigator.of(context).pop();
                  setState(() {});
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
                    controller: contactNameControllerUpdate,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Số điện thoại"),
                    ),
                    controller: phoneNumberControllerUpdate,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
