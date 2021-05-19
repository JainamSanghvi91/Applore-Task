import 'dart:io';

import 'package:apploreinternship/utility/colors.dart';
import 'package:apploreinternship/utility/errordialouge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  static final String routename = '/add-product-page';
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  final image = ImagePicker();

  Map<String, String> _userdata = {
    'name': '',
    'description': '',
    'id': '',
    'image': '',
  };
  File _pickedImage;
  bool _isLoading = false;
  var _controller = TextEditingController();
  final GlobalKey<FormState> _forrmkey = GlobalKey();

  bool isfirst = true;
  int from = 0;

  void showSubmitRequestSnackBar(BuildContext context, String msg) async {
    Flushbar(
      padding: EdgeInsets.only(left: 20),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Transform.scale(
          scale: 0.6, child: SvgPicture.asset("assets/images/right.svg")),
      messageText: Text(
        msg,
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.grey[300],
      duration: Duration(seconds: 2),
    )..show(context).then((r) {
        Navigator.of(context).pop();
      });
  }

  void _sendMessage() async {
    _controller.clear();
    final isValid = _forrmkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _forrmkey.currentState.save();

      final user = await FirebaseAuth.instance.currentUser();
      if (from == 0) {
        if (_pickedImage == null) {
          showErrorDialoug(1, "Please select the Image!", context);
          return;
        }
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_image')
            .child(_pickedImage.path);
        await ref.putFile(_pickedImage).onComplete;
        final url = await ref.getDownloadURL();
        DocumentReference docRef =
            await Firestore.instance.collection('products').add(
          {
            'userId': user.uid,
            'productName': _userdata['name'],
            'productImage': url,
            'description': _userdata['description'],
          },
        );
        showSubmitRequestSnackBar(context, "Successfully added!");
      } else {
        var url;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('product_image')
              .child(_pickedImage.path);
          await ref.putFile(_pickedImage).onComplete;
          url = await ref.getDownloadURL();
        } else {
          url = _userdata['image'];
        }
        print("id is ${_userdata['id']}");
        await Firestore.instance
            .collection('products')
            .document(_userdata['id'])
            .updateData({
          'userId': user.uid,
          'productName': _userdata['name'],
          'productImage': url,
          'description': _userdata['description'],
        });
        showSubmitRequestSnackBar(context, "Successfully updated!");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> showChoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Product Image?"),
            content: Text("Which source you want to use Camera or Gallery?"),
            actions: [
              TextButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageGallery();
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future getImageCamera() async {
    final pickedimage = await image.getImage(source: ImageSource.camera);
    try {
      final pickedImageFile = File(pickedimage.path);
      setState(() {
        _userdata['image'] = '';
        _pickedImage = pickedImageFile;
      });
    } catch (error) {
      print("photo not uploaded");
    }
  }

  Future getImageGallery() async {
    final pickedimage = await image.getImage(source: ImageSource.gallery);
    try {
      final pickedImageFile = File(pickedimage.path);
      setState(() {
        _userdata['image'] = '';
        _pickedImage = pickedImageFile;
      });
    } catch (error) {
      print("Photo not uploaded");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isfirst) {
      final productId =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      if (productId != null) {
        from = 1;
        _userdata = {
          'name': productId['name'],
          'description': productId['desc'],
          'image': productId['image'],
          'id': productId['id'],
        };
      }
      isfirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var maxW = constraints.maxWidth;
      var maxH = constraints.maxHeight;
      return Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 0.02 * maxH, left: 0.02 * maxW),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                  Container(
                    height: 0.4 * maxH,
                    width: maxW,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_1.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 0.1 * maxH, left: 0.05 * maxW),
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
                            "Add or Edit details then click on button",
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildBottomHalfContainer(true, maxH, maxW),
            AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: 0.28 * maxH,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                height: 0.53 * maxH,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 0.1 * maxW,
                margin: EdgeInsets.symmetric(horizontal: 0.05 * maxW),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  isSignupScreen = true;
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Add Product",
                                  style: TextStyle(
                                      fontSize: 0.02 * maxH,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 3,
                                  ),
                                  height: 2,
                                  width: 0.2 * maxW,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      addProductCard(maxH, maxW),
                    ],
                  ),
                ),
              ),
            ),
            buildBottomHalfContainer(false, maxH, maxW),
          ],
        ),
      );
    });
  }

  Container addProductCard(double maxH, double maxW) {
    return Container(
      margin: EdgeInsets.only(top: 0.028 * maxH),
      child: Form(
        key: _forrmkey,
        child: Column(
          children: [
            Container(
              height: 0.152 * maxH,
              padding: EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  showChoice(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.orange,
                  child: _userdata['image'] == ""
                      ? _pickedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _pickedImage,
                                width: 0.25 * maxW,
                                height: 0.125 * maxH,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            _userdata['image'],
                            width: 0.25 * maxW,
                            height: 0.125 * maxH,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                initialValue: _userdata['name'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.inventory,
                    color: Palette.iconColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.textColor1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        35.0,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.textColor1),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Product Name",
                  hintStyle: TextStyle(
                      fontSize: 0.018 * maxH, color: Palette.textColor1),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product Name should not be empty";
                  }
                },
                onSaved: (value) {
                  _userdata['name'] = value;
                  print("Name of Product:");
                  print(_userdata['name']);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                initialValue: _userdata['description'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: Palette.iconColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.textColor1),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.textColor1),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Product Description",
                  hintStyle: TextStyle(
                      fontSize: 0.018 * maxH, color: Palette.textColor1),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Description should not be empty";
                  }
                },
                onSaved: (value) {
                  _userdata['description'] = value;
                },
              ),
            ),
            Container(
              width: 0.3 * maxH,
              margin: EdgeInsets.only(top: 0.02 * maxH),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "By pressing 'Submit' product will be added",
                  style:
                      TextStyle(color: Colors.grey[600], fontSize: 0.02 * maxH),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow, double maxH, double maxW) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: 0.75 * maxH,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 0.11 * maxH,
          width: 0.48 * maxW,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.red[400],
                        Colors.orange[400],
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                  child: (_isLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () => _sendMessage(),
                          child: Center(
                            child: Text(
                              from == 0 ? 'Add Product' : "Update Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 0.023 * maxH,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                )
              : Center(),
        ),
      ),
    );
  }
}
