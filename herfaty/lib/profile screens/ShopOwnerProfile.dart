import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herfaty/AddProduct.dart';
import 'package:herfaty/constants/color.dart';
import 'package:herfaty/pages/login.dart';
import 'package:herfaty/pages/signupHerafy.dart';
import 'package:herfaty/profile%20screens/ShopOwnerEditProfile.dart';
import 'package:herfaty/profile%20screens/show_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/welcome.dart';

class ShopOwnerProfile extends StatefulWidget {
  const ShopOwnerProfile({super.key});

  @override
  State<ShopOwnerProfile> createState() => _ShopOwnerProfileState();
}

class _ShopOwnerProfileState extends State<ShopOwnerProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  var uid;

  _ShopOwnerProfileState() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    print(uid);
  }

  final CollectionReference shopOwners =
      FirebaseFirestore.instance.collection('shop_owner');
  late ShopOwner shopOwner;
  PickedFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  String? DOB = '';
  String? email = '';
  String? id = '';
  String? logo = '';
  String? name = '';
  String? password = '';
  String? phone_number = '';
  String? shopdescription = '';
  String? shopname = '';

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("useres")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          DOB = snapshot.data()!["DOB"];
          email = snapshot.data()!["email"];
          id = snapshot.data()!["id"];

          logo = snapshot.data()!["logo"];
          name = snapshot.data()!["name"];
          password = snapshot.data()!["password"];
          phone_number = snapshot.data()!["phone_number"];
          shopdescription = snapshot.data()!["shopdescription"];
          shopname = snapshot.data()!["shopname"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حسابي", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Color.fromARGB(255, 39, 141, 134),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.logout, color: kPrimaryColor),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => login()));
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),

      ////////////////////////FUTURE BUILDER///////////////////////////////
      body: FutureBuilder<ShopOwner?>(
          future: readUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('11111111111111111111111111111111111111');
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('2222222222222222222222222222222222222222222222');
              return Text('!هناك خطأ في استرجاع البيانات${snapshot.hasError}');
            }
            if (!snapshot.hasData) {
              print('2222222222222222222222222222222222222222222222');
              return Center(child: Text('! خطأ في عرض البيانات '));
            }
            if (snapshot.hasData) {
              print('4444444444444444444444444444444444444444');
              final shopowner = snapshot.data;
              return shopowner == null
                  ? const Center(child: Text('!لا توجد معلومات الحرفي'))
                  : buildOwner(shopowner);
            } else {
              return Text("! هناك مشكلة ما حاول مجددا");
            }
          }),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/images/Circular_Logo.png") as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
      ]),
    );
  }

//////////////////////////////////Building User Profile////////////////////////////////////////
  Widget buildOwner(ShopOwner shopowner) {
    logo = shopowner.logo;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 670,
            // padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            image: DecorationImage(
                              image: AssetImage('assets/images/BG2.png'),
                            )),
                        child: Center(
                          child: Column(
                            children: [
                              imageProfile(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "معلومات الحرفي",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 26, 96, 91)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Icon(Icons.person,
                                    color: Color.fromARGB(255, 39, 141, 134)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  " ${shopowner.name}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Icon(Icons.email_rounded,
                                    color: Color.fromARGB(255, 39, 141, 134)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${shopowner.email}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Icon(Icons.date_range,
                                    color: Color.fromARGB(255, 39, 141, 134)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  " ${shopowner.DOB}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Icon(Icons.phone_android,
                                    color: Color.fromARGB(255, 39, 141, 134)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${shopowner.phone_number}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "معلومات المتجر",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 26, 96, 91)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "اسم المتجر",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(255, 26, 96, 91)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    " ${shopowner.shopname}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "وصف المتجر",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 26, 96, 91)),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Center(
                                    child: Text(
                                  '${shopowner.shopdescription}',
                                  style: TextStyle(fontSize: 15),
                                )),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(children: [
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopOwnerEditProfile()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff51908E)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 13)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            " تعديل البيانات",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
// Diolog to enter the password

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("تنبيه"),
                                  content: Text('سيتم حذف الحساب نهائيا'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("حذف",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
//The logic of deleting an account

                                        //Navigator.of(context).pop();
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) =>
                                                    new Welcome()));
                                      },
                                    ),
                                    TextButton(
                                      child: Text("تراجع"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 221, 112, 112)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 13)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            "حذف الحساب",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<ShopOwner?> readUser() async {
    print("BBBBBBBBBBEGIningggggggggggggggggggggggg ");
    //get a singal document
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? userSO = auth.currentUser;
    final uid = userSO!.uid;
    // userID = FirebaseAuth.instance.currentUser;
    print(uid);

    final docShopOwner = await FirebaseFirestore.instance
        .collection('shop_owner')
        .doc(uid)
        .get();
    print('after the refrence');
    if (docShopOwner.exists) {
      return ShopOwner.fromJson(docShopOwner.data()!);
    }
  }

  void showAlertDialog(BuildContext context) {
    TextEditingController _checkPasslController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // final checkPasslField = TextFormField(
                    TextField(
                      controller: _checkPasslController,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'أدخل كلمة المرور لتعديل الحساب',
                        labelStyle: TextStyle(
                          color: Color(0xff51908E),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text("تحقق"),
                      onPressed: () {
//check if it was correct

                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )));
      },

      // return CustomAlertDialog(
      //       content: Container(
      //         width: MediaQuery.of(context).size.width / 1.3,
      //         height: MediaQuery.of(context).size.height / 2.5,
      //         decoration: new BoxDecoration(
      //           shape: BoxShape.rectangle,
      //           color: const Color(0xFFFFFF),
      //           borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
      //         ),
      //         child: //Contents here
      //       ),
      //     );
    );
  }
}
// void uploadImageToFirebaseStorage(File file) async {
//   // Create a reference to 'images/mountains.jpg'
//   final imagesRef = storageRef
//       .child("shopOwnerLogos/${DateTime.now().millisecondsSinceEpoch}.png");
//   await imagesRef.putFile(file);

//   uploadImageUrl = await imagesRef.getDownloadURL();
//   //setState(() {});
//   print("uploaded:" + uploadImageUrl);
// }

