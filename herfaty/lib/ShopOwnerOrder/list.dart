import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/color.dart';
import 'OrderModel.dart';
import 'orderDetails.dart';
//import 'package:flutterfiredemo/item_details.dart';
//import 'add_item.dart';

class list extends StatelessWidget {
  list({Key? key}) : super(key: key) {
    // _stream = _reference.snapshots();
  }

  /*
  Stream<List<orderModal>> readPrpducts() => FirebaseFirestore.instance
      // final uid = user.getIdToken();
      .collection('orders')
      //  .where("categoryName", isEqualTo: categoryName)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => orderModal.fromJson(doc.data())).toList());

  Widget buildUser(orderModal orderModel) => ListTile(
        //leading: CircleAvatar(child: Text('${orders.docId}')),
        title: Text(orderModel.docId),
        subtitle: Text('yes'),
      );*/
  //CollectionReference _reference =
  // FirebaseFirestore.instance.collection('ShopOwnerOrders');

  //late Stream<QuerySnapshot> _stream;

  // 1 METHOD....

  /*return FirebaseFirestore.instance
        .collection('orders')
        //  .where("categoryName", isEqualTo: categoryName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => orderModel.fromJson(doc.data()))
            .toList());*/

  @override
  Widget build(BuildContext context) {
    const title = 'قائمة الطلبات';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "طلبات متجري"),

      body: StreamBuilder<List<OrderModel>>(
          stream: readPrpducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("somting wrong \n ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return Text("");
            } else if (snapshot.hasData) {
              final cItems = snapshot.data!.toList();
              Size size = MediaQuery.of(context).size;

              return Column(
                children: [
                  Container(
                    height: 610,
                    child: Center(
                      child: ListView.builder(
                          itemCount: cItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFF1F1F1))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              //cItems[index].customerId,
                                              "طلب رقم ${index + 1}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 17.0,fontFamily: "Tajawal")),
                                            
                                          Text(
                                              "تاريح الطلب :${cItems[index].orderDate} ",style: TextStyle(fontSize: 17.0,fontFamily: "Tajawal") ,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(
                                          255, 81, 144, 142), // background
                                    ),
                                    onPressed: () {
                                      //go to order deatils page
                                    },
                                    child: Text(
                                      "تفاصيل الطلب",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),

      /*
      body: StreamBuilder<List<orderModal>>(
          stream: readPrpducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final orders = snapshot.data!; //.toList();
              return ListView(
                children: orders.map(buildUser).toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
*/
      //Check error
      /* if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            final productItems = snapshot.data!.toList();
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents
                .map((e) => {
                      'customerId': e['customerId'],
                      'docId': e['docId'],
                      'shopOwnerId': e['shopOwnerId'],
                      'location': e['location'],
                      'total': e['total'],
                      'shopName': e['shopName'],
                      'notification': e['notification'],
                      'productId': e['productId'],
                      'status': e['status'],
                      'cartDocId': e['cartDocId'],
                      'orderDate': e['orderDate'],
                    })
                .toList();

            //Display the list
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  //Get the item at this index
                  Map thisItem = items[index];
                  //REturn the widget for the list items
                  return ListTile(
                    title: Text('${thisItem['orderDate']}'),
                    subtitle: Text('${thisItem['totalPrice']}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => orderDetails(thisItem['id'])));
                    },
                  );
                });
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ), //Display a list // Add a FutureBuilder
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );*/

      //
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DefaultAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.0);
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("طلباتي",
          style: TextStyle(
            color: Color(0xff51908E),
            fontFamily: "Tajawal",
          )),
      centerTitle: true,
      backgroundColor: Colors.white,
      shadowColor: Color.fromARGB(255, 39, 141, 134),
      elevation: 3,
      leading: IconButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/home_screen_owner');
        },
        icon: Icon(Icons.arrow_back),
      ),
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Color(0xff51908E)),
    );
  }
}

Stream<List<OrderModel>> readPrpducts() {
  // final uid = user.getIdToken();

  final user;
  user = FirebaseAuth.instance.currentUser;
  final uid = user.uid;
  return FirebaseFirestore.instance
      .collection('orders')
      .where("shopOwnerId", isEqualTo: uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
}
