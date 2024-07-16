// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tanam/config.dart';
import 'package:tanam/models/productmodel.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/screens/productdetailscreen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  BannerAd? _bannerAd;
  // ignore: unused_field
  bool _isLoading = false;
  List<ProductModel> productList = [];

  // final adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-6311242713601440/1225088115'
  //     : 'ca-app-pub-6311242713601440/5169036706';
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/6300978111'
      // ... or this one on iOS.
      : 'ca-app-pub-3940256099942544/2934735716';

  TextEditingController searchController = TextEditingController();
  String selectedCategories = "For You";
  List productCategories = [
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
  late int axiscount = 2;
  int totalPage = 1, currentPage = 1;
  int numberofresult = 0;
  // ignore: prefer_typing_uninitialized_variables
  var color, color1;
  int cartqty = 0;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${widget.user.name}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                print(Config.mongoUrl);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                        : ListView(
                            children: [
                              const Text(
                                'Recommended Products',
                                // style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 280,
                                child: ListView.builder(
                                  itemCount: productList.length,
                                  scrollDirection: Axis.horizontal,
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
                                          width: 180,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.teal),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "RM${productList[index].productPrice.toString()}",
                                                      style: const TextStyle(
                                                        color: Colors.yellow,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                              const SizedBox(height: 16),
                            ],
                          ),
              ),
              if (_bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Text(
  //                     'Recommended Products',
  //                     // style: Theme.of(context).textTheme.headline6,
  //                   ),
  //                   const SizedBox(height: 16),
  // if (_bannerAd != null)
  //               Container(
  //                 alignment: Alignment.center,
  //                 width: _bannerAd!.size.width.toDouble(),
  //                 height: _bannerAd!.size.height.toDouble(),
  //                 child: AdWidget(ad: _bannerAd!),
  //               ),

  Future<void> getProduct() async {
    setState(() {
      _isLoading = true;
    });

    int currentPage = 1;

    print("request is called");
    try {
      final response = await http
          .post(
            Uri.parse("${Config.baseUrl}/getproduct"),
            headers: {
              'Content-Type': 'application/json', // Change to application/json
              'x-api-key': Config.apiKey,
              'Accept-Encoding': 'gzip',
            },
            // if header is application/json, so the body must be in json,so json encode the body
            body: jsonEncode({
              //In Dart, the body of an HTTP POST request should be a Map<String, String>,
              // and all values in this map should be strings.
              //unless we encode the body
              "current_page": currentPage,
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

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print("Ad is loaded");
          debugPrint('$ad loaded.');
          setState(() {});
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text('Hi ${widget.user.name.toString()}'),
  //                 const Icon(Icons.trolley),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: TextField(
  //                     controller: searchController,
  //                     decoration: const InputDecoration(hintText: 'Search'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: SizedBox(
  //                     height: 50,
  //                     child: ListView.builder(
  //                       itemCount: productCategories.length,
  //                       scrollDirection: Axis.horizontal,
  //                       itemBuilder: (context, index) {
  //                         return Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(horizontal: 4),
  //                             height: 50,
  //                             width: 120,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(8),
  //                               color: productCategories[index] ==
  //                                       selectedCategories
  //                                   ? Colors.green
  //                                   : Colors.grey,
  //                             ),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 selectedCategories = productCategories[index];
  //                                 setState(() {});
  //                               },
  //                               child: Center(
  //                                 child: Text(
  //                                   productCategories[index],
  //                                   style: const TextStyle(
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: SizedBox(
  //                             height: 250,
  //                             child: ListView.builder(
  //                               itemCount: productContent.length,
  //                               scrollDirection: Axis.horizontal,
  //                               itemBuilder: (context, index) {
  //                                 return Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Container(
  //                                     padding:
  //                                         const EdgeInsets.symmetric(horizontal: 4),
  //                                     width: 150,
  //                                     decoration: BoxDecoration(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8),
  //                                         color: Colors.green),
  //                                     child: InkWell(
  //                                       onTap: () {
  //                                         setState(() {});
  //                                       },
  //                                       child: Column(
  //                                         children: [
  //                                           Text(
  //                                             productContent[index]
  //                                                 .productCategory,
  //                                             style: const TextStyle(
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                           Image.asset(
  //                                             productContent[index]
  //                                                 .productImage,
  //                                             // width: 250,
  //                                           ),
  //                                           Text(
  //                                             productContent[index].productName,
  //                                             style: const TextStyle(
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             productContent[index]
  //                                                 .productPrice,
  //                                             style: const TextStyle(
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             productContent[index]
  //                                                 .productQuantity,
  //                                             style: const TextStyle(
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: SizedBox(
  //                             height: 250,
  //                             child: ListView.builder(
  //                               itemCount: 5,
  //                               scrollDirection: Axis.horizontal,
  //                               itemBuilder: (context, index) {
  //                                 return Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Container(
  //                                     padding:
  //                                         const EdgeInsets.symmetric(horizontal: 4),
  //                                     width: 150,
  //                                     decoration: BoxDecoration(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8),
  //                                         color: Colors.green),
  //                                     child: InkWell(
  //                                       onTap: () {
  //                                         setState(() {});
  //                                       },
  //                                       child: Center(
  //                                         child: Text(
  //                                           productCategories[index],
  //                                           style: const TextStyle(
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: SizedBox(
  //                             height: 250,
  //                             child: ListView.builder(
  //                               itemCount: 5,
  //                               scrollDirection: Axis.horizontal,
  //                               itemBuilder: (context, index) {
  //                                 return Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Container(
  //                                     padding:
  //                                         const EdgeInsets.symmetric(horizontal: 4),
  //                                     width: 150,
  //                                     decoration: BoxDecoration(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8),
  //                                         color: Colors.green),
  //                                     child: InkWell(
  //                                       onTap: () {
  //                                         setState(() {});
  //                                       },
  //                                       child: Center(
  //                                         child: Text(
  //                                           productCategories[index],
  //                                           style: const TextStyle(
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(padding: const EdgeInsets.all(0),),
  //             _bannerAd == null
  //                 ? const SizedBox(height: 0,) // Render nothing if _bannerAd is null
  //                 : SizedBox(
  //                     width: AdSize.banner.width.toDouble(),
  //                     height: AdSize.banner.height.toDouble(),
  //                     child: _bannerAd == null
  //                         // Nothing to render yet.
  //                         ? const Text('no ads')
  //                         // The actual ad.
  //                         : AdWidget(ad: _bannerAd!),
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  
// }
