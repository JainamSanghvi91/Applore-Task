import 'package:apploreinternship/screens/google_login.dart';
import 'package:apploreinternship/screens/inventory.dart';
import 'package:apploreinternship/screens/splash.dart';
import 'package:apploreinternship/widgets/googleprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (contex) => GoogleSingnInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSingnInProvider>(context);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplasScreen();
            } else if (provider.isSigningIn) {
              return SplasScreen();
            } else if (snapshot.hasData) {
              return Inventory();
            } else {
              return GoogleLogin();
            }
          },
        ),
      ),
    );
  }
}
