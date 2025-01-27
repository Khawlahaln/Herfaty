// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herfaty/models/cart_wishlistModel.dart';
import 'package:herfaty/models/Product1.dart';
import 'package:herfaty/constants/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herfaty/widgets/ExpandedWidget.dart';
import 'package:intl/intl.dart';

class CustomerProdectDetails extends StatefulWidget {
  final Product1 product;
  String detailsImage;

  CustomerProdectDetails(
      {super.key, required this.product, required this.detailsImage});

  @override
  State<CustomerProdectDetails> createState() => _CustomerProdectDetailsState();
}

class _CustomerProdectDetailsState extends State<CustomerProdectDetails> {
  late int thisPageQuantity;
  late bool isButtonsDisabled;
  @override
  void initState() {
    if (widget.product.availableAmount == 0) {
      thisPageQuantity = 0;
      isButtonsDisabled = true;
    } else {
      thisPageQuantity = 1;
      isButtonsDisabled = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("class sara |||||");
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String thisCustomerId = user!.uid;
    /////////////////////////////////////////////////////////////////////////////////
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Products');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.modified) {
          for (var index = 0; index < querySnapshot.size; index++) {
            var data = querySnapshot.docs.elementAt(index).data() as Map;
            String productId = data["id"];
            if (productId == widget.product.productId) {
              String updatedDescription = data["dsscription"];
              int updatedAvailabeAmount = data["avalibleAmount"];
              num updatedPrice = data["price"];
              String updatedImage = data["image"];
              String updatedName = data["name"];
              if (mounted) {
                setState(
                  () {
                    widget.product.availableAmount = updatedAvailabeAmount;
                    widget.product.name = updatedName;
                    widget.product.description = updatedDescription;
                    widget.product.price = updatedPrice;
                    widget.product.image = updatedImage;

                    if (updatedAvailabeAmount == 0) {
                      setState(() {
                        thisPageQuantity = 0;
                        isButtonsDisabled = true;
                      });
                    } else if (updatedAvailabeAmount != 0) {
                      setState(() {
                        thisPageQuantity = 1;
                        isButtonsDisabled = false;
                      });
                    }
                  },
                );
              }
            }
          }
        } else if (change.type == DocumentChangeType.removed) {
          if (change.doc.id == widget.product.productId) {
            Navigator.pop(context);
            //showToastMethod(context, "عذرًا، تم حذف المنتج من قبل المالك");
          }
        }
      });
    });
    //////////////////////////////////////////////////////////////////////////////////////////
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,

      appBar: productDetailsAppBar(context),
      //..............................................................................................................
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //to make the container covers the full width of the screen
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  //==child of the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // image=====================================================================
                      Center(
                        child: ProductImage(
                          size: size,
                          image: widget.detailsImage,
                        ),
                      ),
                      Column(
                        //For Column:
                        // mainAxisAlignment = Vertical Axis
                        // crossAxisAlignment = Horizontal Axis
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                fontFamily: "Tajawal",
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          // price and quanity ======================================================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isButtonsDisabled
                                    ? "${widget.product.price} ريال"
                                    : ' ${thisPageQuantity * widget.product.price} ريال',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Tajawal",
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                ' الكمية: ${widget.product.availableAmount} / ${thisPageQuantity} ',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Tajawal",
                                  color: Color.fromARGB(255, 86, 86, 86),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //this sizebox is to add a space after the price
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
                //product description======================================================================
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  child: Text(
                    "${widget.product.description}",
                    style: TextStyle(
                      fontSize: 17.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: "Tajawal",
                    ),
                  ),
                  // child: SingleChildScrollView(
                  //     scrollDirection: Axis.vertical,
                  //     child: ExpandedWidget(
                  //       text: widget.product.description,
                  //     )),
                ),
                // const Spacer(),
                //(أضافة إلى السلة)============================================================//
                //////////////////////////////////////////////////////////////////////////////////
                /////=============================================================================
                //////////////////////////////////////////////////////////////////////////////////
                //=================== التحكم في الكمية

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ////////////////////////////////////////////////////////////////////////////////
                    ///
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: isButtonsDisabled
                                ? Color.fromARGB(139, 158, 158, 158)
                                : Colors.white,
                            size: 26,
                          ),
                          onPressed: isButtonsDisabled
                              ? null
                              : () {
                                  if (mounted) {
                                    setState(
                                      () {
                                        if (thisPageQuantity > 1) {
                                          thisPageQuantity =
                                              thisPageQuantity - 1;
                                        } else {
                                          ShowDialogMethod(context,
                                              "أقل عدد للمنتج هو واحد");
                                        }
                                      },
                                    );
                                  }
                                },
                        ),
                        Container(
                          width: 28.0,
                          height: 47.0,
                          padding: EdgeInsets.only(top: 22.0),
                          color: kPrimaryColor,
                          child: TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '${thisPageQuantity}',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: isButtonsDisabled
                                ? Color.fromARGB(139, 158, 158, 158)
                                : Colors.white,
                            size: 26,
                          ),
                          onPressed: isButtonsDisabled
                              ? null
                              : () async {
                                  //get the existed quantity of the item if it is already exists in the cart
                                  int existedQuantity =
                                      await getQuantity(thisCustomerId);
                                  if (mounted) {
                                    setState(
                                      () {
                                        /*if existed quantity is not zero, المنتج موجود سابقًا*/
                                        if (existedQuantity != 0) {
                                          int totalQuantity = thisPageQuantity +
                                              existedQuantity;
                                          //-----------------------------------
                                          if (totalQuantity <
                                              widget.product.availableAmount) {
                                            thisPageQuantity =
                                                thisPageQuantity + 1;
                                          } else {
                                            ShowDialogMethod(context,
                                                "المنتج موجود لديك في السلة، لا توجد كمية متاحة أكثر من ذلك.");
                                          }
                                        }

                                        //==================================================
                                        //else: item does not exists in the cart
                                        else {
                                          if (thisPageQuantity <
                                              widget.product.availableAmount) {
                                            thisPageQuantity =
                                                thisPageQuantity + 1;
                                          } else {
                                            ShowDialogMethod(context,
                                                "لا توجد كمية متاحة من المنتج أكثر من ذلك");
                                          }
                                        }
                                      },
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                    Container(
                      //margin: EdgeInsets.only(top: 20.0),
                      // زر اللإضافة للسلة-----------------------------------------
                      child: ElevatedButton(
                        onPressed: isButtonsDisabled
                            ? null
                            : () async {
                                //get the existed quantity of the item if it is already exists in the cart
                                int existedQuantity =
                                    await getQuantity(thisCustomerId);

                                /*if existed quantity is not zero, this means the document already exists in the cart,
                          and I need only to update its quantity. المنتج موجود سابقًا*/
                                if (existedQuantity != 0) {
                                  int totalQuantity =
                                      thisPageQuantity + existedQuantity;
                                  print(
                                      "==========Add button says: item exists in the cart");
                                  if (totalQuantity <=
                                      widget.product.availableAmount) {
                                    //get the docId of the existed item, so that its quantity can be updated
                                    String existedDocId =
                                        await getDocId(thisCustomerId);
                                    //update
                                    FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc('${existedDocId}')
                                        .update({
                                      "quantity":
                                          thisPageQuantity + existedQuantity
                                    });
                                    await showToastMethod(context,
                                        "تمت إضافة المنتج للسلة بنجاح");
                                  } else {
                                    ShowDialogMethod(context,
                                        "المنتج موجود لديك في السلة، لا توجد كمية متاحة أكثر من ذلك.");
                                  }
                                } else {
                                  final productToBeAdded = FirebaseFirestore
                                      .instance
                                      .collection('cart')
                                      .doc();
                                  String cdateTime =
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .format(DateTime.now());
                                  cart_wishlistModel item = cart_wishlistModel(
                                      name: widget.product.name,
                                      detailsImage: widget.detailsImage,
                                      docId: productToBeAdded.id,
                                      productId: widget.product.productId,
                                      customerId: user.uid,
                                      description: widget.product.description,
                                      shopName: widget.product.shopName,
                                      shopOwnerId: widget.product.shopOwnerId,
                                      quantity:
                                          existedQuantity + thisPageQuantity,
                                      availableAmount:
                                          widget.product.availableAmount,
                                      price: widget.product.price,
                                      proudctDate: cdateTime);
                                  createCartItem(item);
                                  await showToastMethod(
                                      context, "تمت إضافة المنتج للسلة بنجاح");
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.only(
                            right: 26,
                            left: 26,
                            top: 10,
                            bottom: 5,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                        ),
                        child: Text(
                          "أضف إلى السلة",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                isButtonsDisabled
                    ? Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            'هذا المنتج غير متوفر حاليًا',
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              //fontFamily: "Tajawal",
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        '',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//==========================================================================================
  Future createCartItem(cart_wishlistModel cartItem) async {
    final docCartItem =
        FirebaseFirestore.instance.collection('cart').doc("${cartItem.docId}");
    final json = cartItem.toJson();
    await docCartItem.set(
      json,
      // SetOptions(merge: true)
    );
  }

//========================================================================================
  Future<int> getQuantity(String thisCustomerId) async {
    int existedQuantity = 0;
    print("==================this is get quantity method");
    final cartDoc = await FirebaseFirestore.instance
        .collection('cart')
        .where("productId", isEqualTo: widget.product.productId)
        .where("customerId", isEqualTo: thisCustomerId)
        .get();
    if (cartDoc.size > 0) {
      var data = cartDoc.docs.elementAt(0).data() as Map;
      existedQuantity = data["quantity"];
      print(
          'Existed quantity is ${existedQuantity}============================');
    }

    return existedQuantity;
  }

//=======================================================================================
  Future<String> getDocId(String thisCustomerId) async {
    String existedDocId = "";
    print("==================this is get docId method");
    final cartDoc = await FirebaseFirestore.instance
        .collection('cart')
        .where("productId", isEqualTo: widget.product.productId)
        .where("customerId", isEqualTo: thisCustomerId)
        .get();
    if (cartDoc.size > 0) {
      var data = cartDoc.docs.elementAt(0).data() as Map;
      existedDocId = data["docId"];
      print('Existed docId is ${existedDocId}============================');
    }
    return existedDocId;
  }

  //===============================================================================

///////////////////////////////////////////////////////////////////////////////////
  Future<dynamic> ShowDialogMethod(BuildContext context, String textToBeShown) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("عفوًا"),
          content: Text(textToBeShown),
          actions: <Widget>[
            TextButton(
              child: Text("حسنًا"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

///////////////////////////////////////////////////////////////////////////////
  Future<void> showToastMethod(
      BuildContext context, String textToBeShown) async {
    Fluttertoast.showToast(
      msg: textToBeShown,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Color.fromARGB(255, 26, 96, 91),
      textColor: Colors.white,
      fontSize: 18.0,
    );
    await Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

/////////////////////////////////////////////////////////////////////////////
  AppBar productDetailsAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        padding: const EdgeInsets.only(right: 20),
        icon: const Icon(
          Icons.arrow_back, //سهم العودة
          color: Color.fromARGB(255, 26, 96, 91),
          size: 22.0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text(
        "",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 26, 96, 91),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
class ProductImage extends StatelessWidget {
  const ProductImage({
    Key? key,
    required this.size,
    required this.image,
  }) : super(key: key);

  final Size size;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: size.width * 0.8,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: size.width * 0.8,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
