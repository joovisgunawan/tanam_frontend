// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
// import 'package:tanam/config.dart';
// import 'package:tanam/screens/notificationdetailscreen2.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   List notification = [];
//   bool isLoading = true;
//   bool isError = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotification();
//   }

//   fetchNotification() async {
//     try {
//       var db = await mongo.Db.create(
//         Config.mongoUrl,
//       );
//       await db.open();
//       var collection = db.collection('notification');
//       var notificationList = await collection.find().toList();
//       await db.close();
//       print(notificationList);

//       setState(() {
//         notification = notificationList;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching notifications: $e');
//       setState(() {
//         isError = true;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Notifications',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green, // Example color
//         elevation: 0, // No shadow
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//               ),
//             )
//           : isError
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 60,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Failed to load notifications.',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isLoading = true;
//                             isError = false;
//                           });
//                           fetchNotification();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.green,
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 24,
//                           ),
//                         ),
//                         child: Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : notification.isEmpty
//                   ? Center(
//                       child: Text(
//                         'No notifications available.',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: notification.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           elevation: 2,
//                           margin: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           child: ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) {
//                                     return NotificationDetailScreen2(
//                                       notif: notification[index],
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                             title: Text(
//                               notification[index]['title'],
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(notification[index]['body']),
//                             trailing: Icon(Icons.arrow_forward_ios),
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }
// }


// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:intl/intl.dart';
import 'package:tanam/config.dart';
import 'package:tanam/screens/notificationdetailscreen2.dart';

class NotificationScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const NotificationScreen({Key? key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notification = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchNotification();
  }

  fetchNotification() async {
    try {
      var db = await mongo.Db.create(Config.mongoUrl);
      await db.open();
      var collection = db.collection("notification");
      var notificationList = await collection.find().toList();
      await db.close();
      print(notificationList);

      setState(() {
        notification = notificationList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load notifications.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            isError = false;
                          });
                          fetchNotification();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : notification.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications available.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notification.length,
                      itemBuilder: (context, index) {
                        var notif = notification[index];
                        var formattedDate = DateFormat('MMM d, yyyy - HH:mm').format(DateTime.parse(notif['timestamp']));
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return NotificationDetailScreen2(
                                      notif: notif,
                                    );
                                  },
                                ),
                              );
                            },
                            title: Text(
                              notif['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notif['body']),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      },
                    ),
    );
  }
}
