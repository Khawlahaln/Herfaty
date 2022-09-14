import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herfaty/pages/login.dart';
import 'package:herfaty/pages/reusable_widgets.dart';
import 'package:herfaty/pages/welcomeRegestration.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:herfaty/firestore/firestore.dart';
// ignore_for_file: file_names, prefer_const_constructors

class SignupHerafy extends StatefulWidget {
  const SignupHerafy({Key? key}) : super(key: key);

  @override
  State<SignupHerafy> createState() => _SignupHerafyState();
}

class _SignupHerafyState extends State<SignupHerafy> {
  int currentStep = 0;

  DateTime date = DateTime(2017, 12, 30);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _BODController = TextEditingController();
  TextEditingController _PhoneNumberTextEditingController =
      TextEditingController();

  TextEditingController _shopnameTextEditingController =
      TextEditingController();
  TextEditingController _shoplogoEditingController = TextEditingController();

  TextEditingController _shopdescriptionTextEditingController =
      TextEditingController();

  PickedFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Image.asset(
                    "assets/images/login_toppp.png",
                    width: 150,
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,

                //   child: Image.asset(
                //     "assets/images/main_botomm.png",
                //     width: 200,
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                          ),

                          Container(
                              child: Image.asset(
                            "assets/images/HerfatyLogoCroped.png",
                            height: 100,
                          )),

                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "تسجيل حساب جديد",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 26, 96, 91),
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              child: Image.asset(
                            "assets/images/number1.png",
                            height: 50,
                          )),
                          SizedBox(
                            height: 15,
                          ),

                          Text(
                            "معلومات الحرفي",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(248, 228, 175, 122),
                            ),
                          ),

                          SizedBox(
                            height: 27,
                          ),
                          Container(
                            // width: 290,
                            // height: 53,
                            // padding: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextFieldForName(
                                "اسم الحرفي",
                                Icons.person,
                                false,
                                _nameTextEditingController),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            // width: 290,
                            // height: 53,
                            // padding: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextField(
                                "البريد الإلكتروني",
                                Icons.email_rounded,
                                false,
                                _emailTextEditingController),
                          ),

                          SizedBox(
                            height: 23,
                          ),

                          Container(
                            // width: 290,
                            // height: 53,
                            // padding: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextField("كلمة المرور", Icons.lock,
                                true, _passwordTextController),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 85),
                            child: Text(
                              "* كلمه المرور يجب ان لا تقل عن 6 خانات",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 235, 47, 26)),
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Container(
                              width: 320,
                              height: 53,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                  child: TextFormField(
                                controller: _BODController,
                                //editing controller of this TextField
                                decoration: InputDecoration(
                                  suffix: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color.fromARGB(255, 26, 96, 91),
                                  ),
                                  labelText: "تاريخ الميلاد",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(106, 26, 96, 91)),
                                  fillColor: Colors.white.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 26, 96, 91)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(255, 26, 96, 91)),
                                  ),
                                ),

                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101),

                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Color(
                                                0xff51908E), // <-- SEE HERE
                                            onPrimary:
                                                Colors.white, // <-- SEE HERE
                                            onSurface:
                                                Colors.black, // <-- SEE HERE
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: Color(
                                                  0xff51908E), // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      _BODController.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {
                                    print("لم يتم اختيار تاريخ الميلاد");
                                    // Fluttertoast.showToast(
                                    //   msg: "لم يتم اختيار تاريخ الميلاد  ",
                                    //   toastLength: Toast.LENGTH_SHORT,
                                    //   gravity: ToastGravity.CENTER,
                                    //   timeInSecForIosWeb: 3,
                                    //   backgroundColor: Colors.white,
                                    //   textColor: Colors.red,
                                    //   fontSize: 18.0,
                                    // );
                                  }
                                },
                              ))),
                          SizedBox(
                            height: 17,
                          ),
                          Container(
                            // width: 290,
                            // height: 53,
                            // padding: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextFieldForPhone(
                                "رقم الجوال",
                                Icons.phone_android,
                                false,
                                _PhoneNumberTextEditingController),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          SizedBox(
                            width: 299,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 2,
                                  color: Color.fromARGB(255, 26, 96, 91),
                                )),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              child: Image.asset(
                            "assets/images/number2.png",
                            height: 50,
                          )),
                          SizedBox(
                            height: 15,
                          ),

                          Text(
                            "معلومات المتجر",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(248, 228, 175, 122),
                            ),
                          ),

                          SizedBox(
                            height: 27,
                          ),

                          Text(
                            "أرفق صورة الشعار الخاصة بك",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 26, 96, 91),
                            ),
                          ),
                          imageProfile(),

                          ////////////////////////////Importing Picture //////////////////////////////////
                          SizedBox(
                            height: 27,
                          ),

                          Container(
                            // width: 290,
                            // height: 53,
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextField("اسم المتجر", Icons.shop,
                                false, _shopnameTextEditingController),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            // width: 290,
                            // height: 53,
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: reusableTextFieldDec(
                                "وصف المتجر",
                                Icons.shop_2,
                                false,
                                _shopdescriptionTextEditingController),
                          ),

                          SizedBox(
                            height: 17,
                          ),

                          SizedBox(
                            height: 17,
                          ),
                          Text(
                            "هيا لتبدأ رحلتك!",
                            style:
                                TextStyle(fontFamily: 'Tajawal', fontSize: 18),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email:
                                              _emailTextEditingController.text,
                                          password:
                                              _passwordTextController.text)
                                      .then((value) {
                                    final shopowner = ShopOwner(
                                        name: _nameTextEditingController.text,
                                        email: _emailTextEditingController.text,
                                        password: _passwordTextController.text,
                                        DOB: _BODController.text,
                                        phone_number:
                                            _PhoneNumberTextEditingController
                                                .text,
                                        logo: _shoplogoEditingController.text,
                                        shopname:
                                            _shopnameTextEditingController.text,
                                        shopdescription:
                                            _shopdescriptionTextEditingController
                                                .text);
                                    Fluttertoast.showToast(
                                      msg: "تم تسجيل الحساب بنجاح",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.white,
                                      textColor:
                                          Color.fromARGB(255, 26, 96, 91),
                                      fontSize: 18.0,
                                    );
                                    createShopOwner(shopowner);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const ownerBaseScreen()),
                                    // );
                                  });
                                }
                              } on FirebaseAuthException catch (error) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("خطأ"),
                                        content: Text(
                                            'البريد الإلكتروني موجود مسبقا'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("حسنا"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff51908E)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 90, vertical: 13)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                            ),
                            child: Text(
                              "تسجيل الحساب",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 33,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "هل لديك حساب بالفعل؟ ",
                                style: TextStyle(fontFamily: "Tajawal"),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/login");
                                  },
                                  child: Text(
                                    "تسجيل الدخول ",
                                    style: TextStyle(
                                        fontFamily: "Tajawal",
                                        decoration: TextDecoration.underline,
                                        color:
                                            Color.fromARGB(255, 53, 47, 244)),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    ); //form
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/images/Circular_Logo.png") as ImageProvider
              : FileImage(File(_imageFile!.path)),

          // _imageFile.path
          //
          // ?  as ImageProvider
          // :
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "اختر صورة",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () async {
                // Capture a photo

                final XFile? photo =
                    await _picker.pickImage(source: ImageSource.camera);
                try {
                  final file = File(photo!.path);
                  uploadImageToFirebaseStorage(file);
                } catch (e) {
                  print('error');
                }

                Navigator.of(context).pop();
              },
              label: Text("الكاميرا"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () async {
                // Pick an image
                final XFile? photo =
                    await _picker.pickImage(source: ImageSource.gallery);
                try {
                  final file = File(photo!.path);
                  uploadImageToFirebaseStorage(file);
                } catch (e) {
                  print('error');
                }

                Navigator.of(context).pop();
              },
              label: Text("الصور"),
            ),
          ])
        ],
      ),
    );
  }

//logo
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      try {
        _imageFile = pickedFile!;
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'هناك مشكلة أعد ادخال الصوره مجددا',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 18.0,
        );
      }
    });
  }
}

//Datebase
Future createShopOwner(ShopOwner shopowner) async {
  final docShopOWner =
      FirebaseFirestore.instance.collection('shop_owner').doc();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final User? user = auth.currentUser;
  final uid = user!.uid;
  shopowner.id = uid;

  final json = shopowner.toJson();

  await docShopOWner.set(json);
}

//Database
class ShopOwner {
  String id;
  final String name;
  final String email;
  final String password;
  final String DOB;
  final String phone_number;
  final String logo;
  final String shopname;
  final String shopdescription;

  ShopOwner({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    required this.DOB,
    required this.phone_number,
    required this.logo,
    required this.shopname,
    required this.shopdescription,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'DOB': DOB,
        'logo': logo,
        'phone_number': phone_number,
        'shopdescription': shopdescription,
        'shopname': shopname,
      };
}

// initilazie Image Picker library
final ImagePicker _picker = ImagePicker();
var uploadImageUrl = ""; //image URL before choose pic
// Firebase storage + ref for pic place
final storageRef = FirebaseStorage.instance.ref();

void uploadImageToFirebaseStorage(File file) async {
  // Create a reference to 'images/mountains.jpg'
  final imagesRef = storageRef
      .child("shopOwnerLogos/${DateTime.now().millisecondsSinceEpoch}.png");
  await imagesRef.putFile(file);

  uploadImageUrl = await imagesRef.getDownloadURL();
  //setState(() {});
  print("uploaded:" + uploadImageUrl);
}