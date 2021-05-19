import 'package:apploreinternship/screens/AddProduct.dart';
import 'package:apploreinternship/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginSignupUI(),
    );
  }
}

class LoginSignupUI extends StatelessWidget {
  const LoginSignupUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Signup UI",
      home: Login(),
      routes: {
        AddProducts.routename: (ctx) => AddProducts(),
      },
    );
  }
}
