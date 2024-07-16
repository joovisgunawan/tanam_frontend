// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tanam/config.dart';
import 'package:tanam/models/productmodel.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/post.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/screens/productdetailscreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ShopScreen extends StatefulWidget {
  final UserModel user;
  const ShopScreen({super.key, required this.user});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isLoading = false;
  int totalPage = 1, currentPage = 1;
  List<String> productCategories = [
    "For You",
    "Hydroponics",
    "Aquaponics",
    "Drone",
    "Seeds",
    "Tools",
    "Sensor",
    "Nutrients",
    "Merchendise",
  ];
  String selectedCategories = "For You";
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    getProduct(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      print(Config.mongoUrl);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: productCategories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedCategories = productCategories[index];
                        category(selectedCategories);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: productCategories[index] == selectedCategories
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                        child: Text(
                          productCategories[index],
                          style: TextStyle(
                            color:
                                productCategories[index] == selectedCategories
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productList.isEmpty
                        ? const Center(child: Text('No products found'))
                        : GridView.builder(
                            itemCount: productList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 0,
                              mainAxisExtent: 240,
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          product: productList[index],
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.teal,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              productList[index]
                                                  .productImageUrl
                                                  .toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productList[index]
                                                    .productName
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "RM${productList[index].productPrice.toString()}",
                                                style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: totalPage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () {
                          currentPage = index + 1;
                          getProduct(currentPage);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: (currentPage - 1) == index
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.green,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: "Post Product",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostProductScreen(),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
              label: "My Product",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostProductScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getProduct(int currentPage) async {
    setState(() {
      _isLoading = true;
      productList.clear();
    });

    print("request is called");
    try {
      final response = await http
          .post(
            Uri.parse("${Config.baseUrl}/getproduct"),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': Config.apiKey,
              'Accept-Encoding': 'gzip',
            },
            //In Dart, the body of an HTTP POST request should be a Map<String, String>,
            // and all values in this map should be strings.
            //unless we encode the body
            body: jsonEncode({
              "current_page": currentPage,
              "product_category": selectedCategories,
            }),
          )
          .timeout(
            const Duration(seconds: 5),
          );
      print("response");
      print(response);
      print(response.headers);
      print(response.body);
      print(response.contentLength);
      print(response.statusCode);
      final data = jsonDecode(response.body);
      print("success decoding response");

      if (response.headers['content-encoding'] == 'gzip') {
        print("Response is gzip compressed");
      } else {
        print("Response is not gzip compressed");
      }

      if (response.statusCode != 200) {
        print("error");
        final data = jsonDecode(response.body);
        String error = data['data'].toString();
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $error",
            ),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        String error = data['data'].toString();
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $error",
            ),
          ),
        );
        return;
      }
      totalPage = data['totalPage'];
      print('totalPageNew');

      print(totalPage);
      productList.clear();
      data['data'].forEach((product) {
        productList.add(ProductModel.fromJson(product));
      });
      _isLoading = false;

      setState(() {});
    } on TimeoutException catch (_) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      print("Catch error");
      print(e);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
        ),
      );
    }
  }

  Future<void> category(String category) async {
    setState(() {
      _isLoading = true;
    });

    print("request is called");
    try {
      final response = await http
          .post(
            Uri.parse("${Config.baseUrl}/getproduct"),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': Config.apiKey,
              'Accept-Encoding': 'gzip',
            },
            body: jsonEncode({
              "product_category": category,
            }),
          )
          .timeout(
            const Duration(seconds: 5),
          );
      print(category);
      print("response");
      print(response);
      print(response.headers);
      print(response.body);
      print(response.contentLength);
      print(response.statusCode);
      final data = jsonDecode(response.body);
      print("success decoding response");

      if (response.headers['content-encoding'] == 'gzip') {
        print("Response is gzip compressed");
      } else {
        print("Response is not gzip compressed");
      }

      if (response.statusCode != 200) {
        print("error");
        final data = jsonDecode(response.body);
        String error = data['data'].toString();
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $error",
            ),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        String error = data['data'].toString();
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $error",
            ),
          ),
        );
        return;
      }
      productList.clear();
      data['data'].forEach((product) {
        productList.add(ProductModel.fromJson(product));
      });

      print(productList);
      setState(() {
        _isLoading = false;
      });
    } on TimeoutException catch (_) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      print("Catch error");
      print(e);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
        ),
      );
    }
  }
}
