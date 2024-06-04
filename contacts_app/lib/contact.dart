import 'dart:math';

import 'package:flutter/material.dart';

class Contact {
  String id;
  ValueNotifier<String> name;
  ValueNotifier<int> phoneNumber;
  ValueNotifier<String> image;

  Contact( {
    String? id,
    String? name,
    required int phoneNumber,
    String? image,
  })  : id = id ?? generateUuid(),
        name = ValueNotifier(name ?? ''),
        phoneNumber = ValueNotifier(phoneNumber),
        image = ValueNotifier(image ?? '');

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name.value,
      'phoneNumber': phoneNumber.value,
      'image': image.value,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      image: map['image'],
    );
  }
}
