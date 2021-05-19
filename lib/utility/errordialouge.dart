import 'package:apploreinternship/utility/colors.dart';
import 'package:apploreinternship/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showErrorDialoug(int flag, String message, BuildContext context) {
  Size size = MediaQuery.of(context).size;
  final h = SizeConfig.heightMultiplier * 100;
  final w = SizeConfig.widthMultiplier * 100;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      )),
      elevation: 5,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: w * 0.5,
        height: h * 0.25,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: (flag != 3)
                        ? (flag == 1)
                            ? blueLt
                            : redLt
                        : greenLt,
                    //height: h * 0.25 * 0.45,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            w * 0.06, h * 0.05, w * 0.06, 0),
                        child: Center(
                          child: Text(
                            //'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: h * 0.25 * 0.095),
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.25 * 0.15),
              child: Align(
                alignment: Alignment.topCenter,
                child: (flag != 3)
                    ? (flag == 1)
                        ? SvgPicture.asset("assets/images/some_err.svg")
                        : SvgPicture.asset("assets/images/wrong.svg")
                    : SvgPicture.asset("assets/images/right.svg"),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Okay',
            style: TextStyle(
                color: (flag != 3)
                    ? (flag == 1)
                        ? blueLt
                        : redLt
                    : greenLt,
                fontSize: h * 0.25 * 0.095),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
