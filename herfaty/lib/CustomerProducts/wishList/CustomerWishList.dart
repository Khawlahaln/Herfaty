// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:herfaty/CustomerProducts/wishList/wishCard.dart';
import 'package:herfaty/CustomerProducts/wishList/wishListDetails.dart';
import 'package:herfaty/models/cart_wishlistModel.dart';
import 'package:herfaty/constants/color.dart';

class CustomerWishList extends StatefulWidget {
  CustomerWishList({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerWishList> createState() => _CustomerWishListState();
}

class _CustomerWishListState extends State<CustomerWishList> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String thisCustomerId = user!.uid;
    //====================================================================
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: wishListAppBar(context),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/cartBack1.png'),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              //تبعد لي البوكس اللي يعرض المنتجات عن الشريط العلوي
              const SizedBox(height: 15),
              Expanded(
                child: Stack(
                  children: [
                    //This is to list all of our items fetched from the DB========================
                    StreamBuilder<List<cart_wishlistModel>>(
                      stream: readPrpducts(thisCustomerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final productItems = snapshot.data!.toList();
                          final data = snapshot.data!;
                          if (data.isEmpty) {
                            return const Center(
                              child: Text(
                                'لا توجد لديك منتجات مفضلة',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Tajawal",
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          //هنا حالة النجاح في استرجاع البيانات...........................................
                          else {
                            return ListView.builder(
                              itemCount: productItems.length,
                              itemBuilder: (context, index) => wishCard(
                                itemIndex: index,
                                product: productItems[index],
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => wishListDetails(
                                        // يرسل المعلومات لصفحة المنتج عشان يعرض التفاصيل
                                        detailsImage:
                                            productItems[index].detailsImage,
                                        product: productItems[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          //..................................................................................
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    //==================================================================================
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//========================================================================================
  Stream<List<cart_wishlistModel>> readPrpducts(String thisCustomerId) =>
      FirebaseFirestore.instance
          .collection('wishList')
          .where("customerId", isEqualTo: thisCustomerId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => cart_wishlistModel.fromJson(doc.data()))
              .toList());

/////////////////////////////////////////////////////////////////////////////////////////////////////
  //AppBar
  AppBar wishListAppBar(var context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      centerTitle: true,
      title: Text(
        "مفضلاتي",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
          fontFamily: "Tajawal",
        ),
      ),
    );
  }
}