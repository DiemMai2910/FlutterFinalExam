import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { login, register }   //Định nghĩa các trạng thái cho AuthMode

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  var mode = AuthMode.login;

  //Các trường nhập liệu 
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  //Khóa quản lý trạng thái biểu mẫu
  final formKey = GlobalKey<FormState>();

  //Quản lý xác thực FirebaseAuth
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mode == AuthMode.register

      //Giao diện đăng ký
          ? Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Danh bạ trực tuyến",
                      style: TextStyle(fontSize: 20),
                    ),

                    //Form đăng ký
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: userController,
                              decoration: InputDecoration(
                                label: const Text('Tên tài khoản'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),

                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                label: const Text('Email'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),

                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                label: const Text('Mật khẩu'),
                              ),
                              obscureText: true,    //Ẩn ký tự nhập
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),

                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () {
                                register();
                              },
                              child: const Text("Đăng ký"),
                            ),
                            
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Đã có tài khoản? "),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      mode = AuthMode.login;
                                    });
                                  },
                                  child: const Text("Đăng nhập",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )

          //Giao diện đăng nhập  
          : Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Danh bạ trực tuyến",
                      style: TextStyle(fontSize: 20),
                    ),

                    //Form đăng nhập
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 25),

                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                label: Text('Email'),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Mật khẩu'),
                              ),
                              obscureText: true,
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),

                            const SizedBox(height: 20),
                            FilledButton(
                                onPressed: login,
                                child: const Text("Đăng nhập")),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Chưa có tài khoản? "),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      mode = AuthMode.register;
                                    });
                                  },
                                  child: const Text("Đăng ký",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }


  //Phương thức đăng nhập
  Future<void> login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    try {
      if (formKey.currentState!.validate()) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        errorMessageDiaglog(e.code, context);
      }
    }
  }


  //Phương thức đăng ký
  Future<void> register() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      try {

        if (formKey.currentState!.validate()) {   //kiểm tra hợp lệ nhập liệu
          UserCredential? userCredential =
              await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          
          addUserFirestore(userCredential);

          if (mounted) Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
          errorMessageDiaglog(e.code, context);
        }
      }
  }


  //Phương thức thêm thông tin tài khoản vào FireStore
  Future<void> addUserFirestore(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userController.text,
      });
    }
  }
}

void errorMessageDiaglog(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(message),
          ));
}
