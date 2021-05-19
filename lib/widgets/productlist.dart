import 'dart:math';

import 'package:apploreinternship/models/product.dart';
import 'package:apploreinternship/screens/AddProduct.dart';
import 'package:apploreinternship/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    Key key,
    @required this.name,
    @required this.desc,
    @required this.id,
    @required this.remover,
    @required this.image,
  }) : super(key: key);

  final String name;
  final String desc;
  final String image;
  final String id;
  final Function remover;

  @override
  Widget build(BuildContext context) {
    print("image is ${image}");
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxW = SizeConfig.heightMultiplier * 100;
        var maxH = SizeConfig.widthMultiplier * 100;
        print("productlist $maxW $maxH");
        return Container(
          padding: EdgeInsets.only(
              left: 6 * maxW / 360, right: 6 * maxW / 360, top: 0.02 * maxH),
          height: maxH * 0.28,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2 * maxW / 360,
                              vertical: 15 * maxH / 647),
                          width: min(maxW * 0.28, constraints.maxHeight * 0.8),
                          height: min(maxW * 0.28, constraints.maxHeight * 0.8),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(15 * maxH / 647),
                              child: Image.network(
                                image,
                                fit: BoxFit.contain,
                              )),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(8.0 * maxH / 647)),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 2 * maxW / 360, top: 8 * maxH / 647),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                // flex: 3,
                                child: Text(
                                  // "Bina Provison  msddj ksfjvkfjv",
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 32 * maxH / 647),
                                ),
                              ),
                              SizedBox(
                                height: 4 * maxH / 647,
                              ),
                              Flexible(
                                // flex: 2,
                                child: Text(
                                  // "Kanal Road, Near Vardhman, Morbi-363641 smnxsajcjcdncsc ndmcm s hwbdjshcjsd jvhjdvfjdh bjdfh  jdhbdjf dhfbvdjbjf j dhb",

                                  desc,
                                  overflow: TextOverflow.ellipsis,

                                  maxLines: 2,
                                  style: TextStyle(fontSize: 24 * maxH / 647),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                SweetAlert.show(context,
                                    title: "Confirmation",
                                    subtitle:
                                        "   Are you sure you want to delete?",
                                    style: SweetAlertStyle.confirm,
                                    showCancelButton: true,
                                    onPress: (bool isConfirm) {
                                  if (isConfirm) {
                                    remover(id);
                                    // Navigator.of(context).pop();
                                    // return false;
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 0.02 * maxH),
                                child: Icon(
                                  Icons.delete,
                                  size: 32 * maxH / 647,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Product product = Product(
                                    id: id,
                                    desc: desc,
                                    imageurl: image,
                                    name: name);
                                Navigator.of(context).pushNamed(
                                    AddProducts.routename,
                                    arguments: {
                                      'id': id,
                                      'desc': desc,
                                      'image': image,
                                      'name': name
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 0.02 * maxH),
                                child: Icon(
                                  Icons.edit,
                                  size: 32 * maxH / 647,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
