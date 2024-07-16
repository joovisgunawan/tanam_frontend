class NotificationModel {
  String? title;
  String? body;

  NotificationModel({
    this.title,
    this.body,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }
  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

List notificationList = [
  NotificationModel(
    title: "Notification 1",
    body: "",
  ),
  NotificationModel(
    title: "Notification 2",
    body: "",
  ),
];
