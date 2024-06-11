class NotificationModel {
  List<NotificationData>? data;
  String? message;

  NotificationModel({this.data, this.message});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => NotificationData.fromJson(i)).toList() : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['`data`'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? datetime;
  String? id;
  String? image;
  String? postId;
  String? title;

  NotificationData({this.datetime, this.id, this.image, this.postId, this.title});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      datetime: json['datetime'],
      id: json['id'],
      image: json['image'],
      postId: json['post_id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['id'] = this.id;
    data['image'] = this.image;
    data['post_id'] = this.postId;
    data['title'] = this.title;
    return data;
  }
}
