// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'contact_update.dart';

// class ContactDetailsView extends StatefulWidget {
//   const ContactDetailsView({super.key, required this.contact});

//   @override
//   State<ContactDetailsView> createState() => _ContactDetailsViewState();
// }

// class _ContactDetailsViewState extends State<ContactDetailsView> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text("Chi tiết liên hệ"),
//           actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () => _editContact(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => _deleteContact(context),
//           ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 20),
//                 if (widget.contact.image.value
//                     .isNotEmpty) // Kiểm tra nếu đường dẫn hình ảnh không rỗng
//                   ClipOval(
//                     child: kIsWeb
//                         ? Image.network(
//                             widget.contact.image.value,
//                             width: 200,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.file(
//                             File(widget.contact.image.value),
//                             width: 200,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           ),
//                   )
//                 else
//                   ClipOval(
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       color: Colors.grey[200],
//                       child: Center(
//                         child: Image.asset(
//                           'assets/images/flutter_logo.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 15),
//                 Text(
//                   widget.contact.name.value,
//                   style: const TextStyle(
//                       fontSize: 25, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 9),
//                 Text(
//                   '${widget.contact.phoneNumber.value}',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//     // Xóa liên hệ
//   void _deleteContact(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Xác nhận Xóa"),
//           content:
//               const Text("Bạn có chắc chắn muốn xóa điện thoại này không?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text("Hủy"),
//             ),
//             TextButton(
//               onPressed: () {
//                 viewModel.removeContact(widget.contact.id);
//                 Navigator.of(context).popUntil((route) => route.isFirst);
//               },
//               child: const Text("Xóa"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Chỉnh sửa thông tin liên hệ
//   void _editContact(BuildContext context) {
//     showModalBottomSheet<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => ContactUpdate(
//         initialName: widget.contact.name.value,
//         initialPhoneNumber: widget.contact.phoneNumber.value,
//         initialImage: widget.contact.image.value,
//       ),
//     ).then((value) {
//       if (value != null) {
//         viewModel.updateContact(
//           widget.contact.id,
//           value['name'] ?? '',
//           value['phoneNumber'] ?? 0,
//           value['image'], // Chuyển đường dẫn hình ảnh
//         );
//         setState(() {});
//       }
//     });
//   }

// }
