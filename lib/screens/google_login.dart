import 'package:apploreinternship/utility/colors.dart';
import 'package:apploreinternship/widgets/googleprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class GoogleLogin extends StatefulWidget {
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxW = constraints.maxWidth;
        var maxH = constraints.maxHeight;
        return Scaffold(
          //backgroundColor: Colors.lime,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 0.45 * maxH,
                    width: maxW,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_1.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 0.17 * maxH, left: 0.05 * maxW),
                      color: Color(0xFF3b5999).withOpacity(.85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Welcome to ",
                              style: TextStyle(
                                fontSize: 0.03 * maxH,
                                letterSpacing: 2,
                                color: Colors.yellow[700],
                              ),
                              children: [
                                TextSpan(
                                  text: "Applore Technologies",
                                  style: TextStyle(
                                    fontSize: 0.035 * maxH,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Sign in with Google to continue",
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 0.075 * maxH, bottom: 0.02 * maxH),
                        child: Text(
                          "Click on this button and write email-id and password to login!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        height: 0.06 * maxH,
                        margin: EdgeInsets.only(
                            right: 30, left: 30, top: 0.02 * maxH),
                        child: buildTextButton(
                          MaterialCommunityIcons.google_plus,
                          "Google",
                          Palette.googleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isloading = true;
        });
        final provider =
            Provider.of<GoogleSingnInProvider>(context, listen: false);
        provider.login();
        setState(() {
          _isloading = false;
        });
      },
      style: TextButton.styleFrom(
        side: BorderSide(width: 1, color: Colors.grey),
        minimumSize: Size(145, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        primary: Colors.white,
        backgroundColor: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }
}
