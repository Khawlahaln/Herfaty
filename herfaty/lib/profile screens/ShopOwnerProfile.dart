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
import 'package:herfaty/widgets/ownerSettings.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/welcome.dart';
import '../widgets/ExpandedWidget.dart';
import '../widgets/ExpanededWidgetShop.dart';

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

  get kPrimaryColor => null;

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

  TextEditingController passwordController = TextEditingController();
//    fontFamily: "Tajawal",
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حسابي",
            style: TextStyle(
              color: Color.fromARGB(255, 39, 141, 134),
              fontFamily: "Tajawal",
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Color.fromARGB(255, 39, 141, 134),
        elevation: 2,
        leading: IconButton(
          icon:  Icon(Icons.logout, color: Color.fromARGB(255, 81, 144, 142)),
          onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("تنبيه"),
                      content: Text('سيتم تسجيل خروجك من الحساب'),
                      actions: <Widget>[
                        TextButton(
                          child: Text("تسجيل خروج",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            //Navigator.of(context).pop();
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => new login()));
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
                  });

              /*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }));*/
            
        
        
        
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => OwnerSettings()));
            },
            icon: Icon(CupertinoIcons.settings, color: Color.fromARGB(255, 81, 144, 142)),
          ),
        ],
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
                  : buildOwner(shopowner, context);
            } else {
              return Text("! هناك مشكلة ما حاول مجددا");
            }
          }),
    );
  }

  Widget imageProfile(String logo) {
    print(logo);
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 54.0,
          backgroundImage: logo == null
              ? AssetImage("assets/images/Circular_Logo.png") as ImageProvider
              : NetworkImage(logo),
          //  _imageFile == null
          //     ? AssetImage("assets/images/Circular_Logo.png") as ImageProvider
          //     : FileImage(File(_imageFile!.path)),
        ),
      ]),
    );
  }

//////////////////////////////////Building User Profile////////////////////////////////////////
  Widget buildOwner(ShopOwner shopowner, BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 600,
              width: double.infinity,
              child: SizedBox(
                height: 500,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/BG2.png'),
                        )),
                        child: Center(
                          child: Column(
                            children: [
                              imageProfile(shopowner.logo),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      width: 250,
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
                        height: 180,
                        width: 250,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                "معلومات الحرفي",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 26, 96, 91),
                                  fontFamily: "Tajawal",
                                ),
                              ),
                            ),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                                    fontFamily: "Tajawal",

),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                                                                          fontFamily: "Tajawal",
),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                                                                          fontFamily: "Tajawal",
),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                                                                          fontFamily: "Tajawal",
),
                                )
                              ],
                            )),
                          ],
                        ),
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
                        height: 160,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                "بيانات المتجر",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Tajawal",
                                    color: Color.fromARGB(255, 26, 96, 91)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    " اسم المتجر ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: "Tajawal",
                                        color:
                                            Color.fromARGB(255, 39, 141, 134)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  /**hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh */
                                  //
                                  Text(
                                    "${shopowner.shopname}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 0, left: 245),
                                    
                                child: Text(
                                  "وصف المتجر",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "Tajawal",
                                      color: Color.fromARGB(255, 39, 141, 134)),
                                ),
                              ),
                           ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(
                                  // vertical: 10,
                                  // horizontal: 30,
                                  ),
                              child: Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    /*hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh*/
                                    //${shopowner.shopdescription}
                                    child: ExpandedWidgetShop(
                                        text: '${shopowner.shopdescription}')),
                                //
                              ),
                            ),
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
                            showAlertDialog(context);
                            // openPasswordDialog(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopOwnerEditProfile(
                                      shopowner.name,
                                      shopowner.email,
                                      shopowner.password,
                                      shopowner.DOB,
                                      shopowner.phone_number,
                                      shopowner.shopname,
                                      shopowner.shopdescription,
                                      shopowner.id,
                                      shopowner.logo)),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff51908E)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 10)),
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
                                        final docSO = FirebaseFirestore.instance
                                            .collection('shop_owner')
                                            .doc(uid);
                                        //Navigator.of(context).pop();

                                        docSO.delete();

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
                                    horizontal: 45, vertical: 10)),
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
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

void openPasswordDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("التحقق من الوصول"),
            content: TextField(
                decoration: InputDecoration(hintText: 'ادخل كلمة المرور')),
            actions: [
              TextButton(
                  onPressed: () {
                    submit(context);
                  },
                  child: Text('تحقق'))
            ],
          ));
}

void submit(BuildContext context) {
  Navigator.of(context).pop();
}