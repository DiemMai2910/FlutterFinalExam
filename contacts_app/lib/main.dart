import 'auth_firebase_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();    //Đảm bảo widget tree đã được khởi tạo, tránh lỗi bất đồng bộ 
  await Firebase.initializeApp(   //Khởi tạo Firebase bất đồng bộ
    options: DefaultFirebaseOptions.currentPlatform,    //Tùy chọn mặc định cho nền tảng hiện tại
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,  //Ẩn banner "Debug" ở góc trên bên phải
        title: 'Danh Bạ',
        home: AuthFirebase());
  }
}
