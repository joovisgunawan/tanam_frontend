// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanam/tokenmanager.dart';
import 'package:path/path.dart' as path; // Add this import

class ApiClient {
  static const String apiUrl = 'https://api.tanam.software:8488';
  static const String apiKey = 'tanam_api_key';
  static const String refreshEndpoint = '/refresh';
  static const String registerEndpoint = '/register';
  static const String loginEndpoint = '/login';
  static const String uploadEndpoint = '/upload';

  Future<http.Response> refreshAccessToken() async {
    final refreshToken = await TokenManager.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final response = await http.post(
      Uri.parse('$apiUrl$refreshEndpoint'),
      headers: {'Content-Type': 'application/json', 'x-api-key': apiKey},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenManager.setAccessToken(data['access_token']);
      return response;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<http.Response> post(String endpoint) async {
    final accessToken = await TokenManager.getAccessToken();
    final response = await http.post(
      Uri.parse('$apiUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 401) {
      try {
        await refreshAccessToken();
        final newAccessToken = await TokenManager.getAccessToken();
        return await http.get(
          Uri.parse('$apiUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $newAccessToken',
            'x-api-key': 'your_api_key'
          },
        );
      } catch (e) {
        // Handle token refresh failure (e.g., redirect to login)
        print('Token refresh failed: $e');
        await TokenManager.clearTokens();
        // Redirect to login page or handle accordingly
        throw Exception('Unauthorized');
      }
    }

    return response;
  }

  Future<http.Response> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http
        .post(
          Uri.parse('$apiUrl$registerEndpoint'),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
          },
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success register') {
        // Optionally, you can save tokens if they're returned on successful registration
        if (data.containsKey('access_token')) {
          await TokenManager.setAccessToken(data['access_token']);
        }
        if (data.containsKey('refresh_token')) {
          await TokenManager.setRefreshToken(data['refresh_token']);
        }
      }
    }

    return response;
  }

  void loginv0(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$apiUrl$loginEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success register') {
        // Optionally, you can save tokens if they're returned on successful registration
        if (data.containsKey('access_token')) {
          await TokenManager.setAccessToken(data['access_token']);
        }
        if (data.containsKey('refresh_token')) {
          await TokenManager.setRefreshToken(data['refresh_token']);
        }
      }
    }
  }

  void loginv1(
    String email,
    String password,
  ) async {
    await http.post(
      Uri.parse("https://api.tanam.software:8488/login"),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: {
        "email": email,
        "password": password,
      },
    ).then((response) {
      return response;
    }).timeout(
      const Duration(seconds: 3),
    );
  }

  // void loginv2(
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   await http.post(
  //     Uri.parse("https://api.tanam.software:8488/login"),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-api-key': apiKey,
  //     },
  //     body: {
  //       "email": email,
  //       "password": password,
  //     },
  //   ).then((response) {
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       var jsondata = jsonDecode(response.body); //decode==parse
  //       if (jsondata['status'] == 'success login') {
  //         // UserTanam user = UserTanam.fromJson(jsondata['data']);
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (content) => const MainScreen(
  //               user: user,
  //               index: 0,
  //             ),
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text("Login Failed")));
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text("Login Failed")));
  //     }
  //   }).timeout(
  //     const Duration(seconds: 3),
  //     onTimeout: () {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Request timed out. Please try again.")),
  //       );
  //       throw TimeoutException(
  //           'The connection has timed out, Please try again!');
  //     },
  //   );
  // }

  Future<void> uploadImage(
    String productName,
    double productPrice,
    int productQuantity,
    String productDescription,
    String imagePath,
  ) async {
    final accessToken = await TokenManager.getAccessToken();
    final uri = Uri.parse('$apiUrl$uploadEndpoint');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..headers['x-api-key'] = apiKey
      ..fields['productName'] = productName
      ..fields['productPrice'] = productPrice as String
      ..fields['productQuantity'] = productQuantity as String
      ..fields['productDescription'] = productName
      ..files.add(await http.MultipartFile.fromPath(
        'productImage',
        imagePath,
        filename: path.basename(imagePath),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      // Handle success response
    } else if (response.statusCode == 401) {
      // Token might be expired, try refreshing
      try {
        await refreshAccessToken();
        final newAccessToken = await TokenManager.getAccessToken();
        request.headers['Authorization'] = 'Bearer $newAccessToken';

        response = await request.send();

        if (response.statusCode == 200) {
          print('Image uploaded successfully after refreshing token');
          // Handle success response
        } else {
          print('Failed to upload image: ${response.reasonPhrase}');
          // Handle failure response
        }
      } catch (e) {
        print('Token refresh failed: $e');
        await TokenManager.clearTokens();
        throw Exception('Unauthorized');
      }
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
      // Handle failure response
    }
  }

  // Add other HTTP methods (post, put, delete) with similar logic if needed
}
