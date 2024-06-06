import 'package:contacts_app/contact_list_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_gate.dart';

class AuthFirebase extends StatefulWidget {
  const AuthFirebase({super.key});

  @override
  State<AuthFirebase> createState() => _AuthFirebaseState();
}

class _AuthFirebaseState extends State<AuthFirebase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return const ContactListView();
          }
          else {
            return const AuthGate();
          }
        },
      ),
    );
  }
}