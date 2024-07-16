import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tanam/models/productmodel.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final UserModel user;
  const ProductDetailScreen(
      {super.key, required this.product, required this.user});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // late FocusNode myFocusNode;
  double totalPrice = 0.0;
  double singlePrice = 0.0;
  int maksQuantity = 0;
  int userQuantity = 1;

  @override
  void initState() {
    super.initState();
    userQuantity = 1;
    maksQuantity = int.parse(widget.product.productQuantity.toString());
    totalPrice = double.parse(widget.product.productPrice.toString());
    singlePrice = double.parse(widget.product.productPrice.toString());
    // myFocusNode = FocusNode();
  }

  // final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 270,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        // bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Image.network(
                      widget.product.productImageUrl.toString(),
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(48),
                          // bottomRight: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.product.productName}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                ),
                              ),
                              Text(
                                "${widget.product.productQuantity} Available",
                                style: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.favorite_border, size: 25),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (userQuantity <= 1) {
                                  userQuantity = 1;
                                } else {
                                  userQuantity--;
                                }
                                totalPrice = singlePrice * userQuantity;
                                setState(() {});
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Text(userQuantity.toString()),
                            ),
                            IconButton(
                              onPressed: () {
                                if (userQuantity >= maksQuantity) {
                                  userQuantity = maksQuantity;
                                } else {
                                  userQuantity++;
                                }
                                totalPrice = singlePrice * userQuantity;
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'RM $totalPrice',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            // color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        Text("${widget.product.productState}")
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Product Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("${widget.product.productDescription}")
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: TextButton(
                      onPressed: () {
                        addtocart();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          color: Colors.green,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: TextButton(
                      onPressed: () {
                        // showMyProduct();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          color: Colors.green,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       TextButton(
          //         onPressed: () {
          //           addtocart();
          //         },
          //         style: TextButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor: Colors.indigo,
          //           minimumSize: const Size.fromHeight(50),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           side: const BorderSide(
          //             color: Colors.indigo,
          //             style: BorderStyle.solid,
          //           ),
          //         ),
          //         child: const Text(
          //           'Add To Cart',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             // color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           addtocart();
          //         },
          //         style: TextButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor: Colors.indigo,
          //           minimumSize: const Size.fromHeight(50),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           side: const BorderSide(
          //             color: Colors.indigo,
          //             style: BorderStyle.solid,
          //           ),
          //         ),
          //         child: const Text(
          //           'Add To Cart',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             // color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void addtocart() {
    http.post(Uri.parse("/barterit/php/addtocart.php"), body: {
      "productId": widget.product.productId,
      "cartQuantity": userQuantity.toString(),
      "cartPrice": totalPrice.toString(),
      "buyerId": widget.user.id,
      "sellerId": widget.product.sellerId
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

  // void showMyProduct() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (content) => BuyerProductScreen(
  //         user: widget.user,
  //         sellerProduct: widget.userProduct,
  //       ),
  //     ),
  //   );
  // }

  void barter() {
    http.post(Uri.parse("SERVER}/barterit/php/addbarter.php"), body: {
      "buyer_product_id": userQuantity.toString(),
      "seller_product_id": widget.product.productId,
      "buyer_id": widget.user.id,
      "seller_id": widget.product.sellerId
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }
}
