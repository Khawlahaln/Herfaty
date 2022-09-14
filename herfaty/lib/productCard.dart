import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/media_query.dart';
import 'package:flutter/material.dart';
import 'package:herfaty/Product1.dart';

class productCard extends StatelessWidget {
  const productCard({
    Key? key,
    required this.itemIndex,
    required this.product,
    required this.press,
  }) : super(key: key);

  final int itemIndex;
  final Product1 product;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    Size size =
        MediaQuery.of(context).size; //to get the width and height of the app
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      height: 190,
      child: InkWell(
        onTap:
            press, // يعني ان المستخدم لما يضغط على الكارد تفتح معاه صفحة جديدة
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              //(small box inside the Big box)
              padding: const EdgeInsets.only(top: 10),
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F6),
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, -10),
                      blurRadius: 25,
                      color: Colors.white),
                ],
              ),
            ),
            //*************************This part contains product photo:
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: 160,
                width: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAF9F6),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //**********************This part contains product name and price
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 136,
                //because our image is 200, so the siz of this box = width -200
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //product name=======================================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    //const Spacer(),
                    //const Spacer(),
                    //const Spacer(),
                    //سعر المنتج وعلامة التفضيل===============================================================
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            //vertical: 10,
                            right: 18,
                            top: 18,
                          ),
                          child: Text(
                            ' ${product.price} ريال',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange,
                            ),
                          ),
                        ),

                        //(أضافة إلى المفضلة )--------------------------
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            top: 18,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(right: 1),
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 35.0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
