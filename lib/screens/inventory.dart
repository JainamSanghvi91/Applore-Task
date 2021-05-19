import 'package:apploreinternship/screens/AddProduct.dart';
import 'package:apploreinternship/widgets/googleprovider.dart';
import 'package:apploreinternship/widgets/productlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';

class Inventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxW = constraints.maxWidth;
        var maxH = constraints.maxHeight;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            title: Padding(
              padding: EdgeInsets.only(left: 0.16 * maxW),
              child: Center(
                child: Text(
                  'All Products',
                  style: TextStyle(color: Colors.white, fontSize: 0.032 * maxH),
                ),
              ),
            ),
            actions: [
              DropdownButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          Text('Logout'),
                        ],
                      ),
                    ),
                    value: 'logout',
                  ),
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    SweetAlert.show(
                      context,
                      title: "Confirmation",
                      subtitle: "   Are you sure you want to logout?",
                      style: SweetAlertStyle.confirm,
                      showCancelButton: true,
                      onPress: (bool isConfirm) {
                        if (isConfirm) {
                          Provider.of<GoogleSingnInProvider>(context,
                                  listen: false)
                              .logout();
                          FirebaseAuth.instance.signOut();
                        }
                      },
                    );
                  }
                },
              )
            ],
          ),
          body: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder(
                stream: Firestore.instance
                    .collection('products')
                    .where("userId", isEqualTo: futureSnapshot.data.uid)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final chatDocs = chatSnapshot.data.documents;
                  final user = FirebaseAuth.instance.currentUser;
                  void remover(String id) {
                    Firestore.instance
                        .collection('products')
                        .document(id)
                        .delete();
                  }

                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 10),
                    child: chatDocs.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: maxW * 0.6,
                                  child: Image.asset(
                                      'assets/images/add_product.png'),
                                ),
                              ),
                              Text(
                                "Add Product to your Inventory!",
                                style: TextStyle(fontSize: 16 * maxH / 647),
                              ),
                            ],
                          )
                        : ListView.builder(
                            // reverse: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) {
                              return ProductList(
                                remover: remover,
                                id: chatDocs[index].documentID,
                                image: chatDocs[index]['productImage'],
                                name: chatDocs[index]['productName'],
                                desc: chatDocs[index]['description'],
                              );
                            },
                          ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            child: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              AddProducts.routename,
            ),
          ),
        );
      },
    );
  }
}
