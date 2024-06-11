import 'package:news_flutter/model/post_model.dart';

class PostListModel {
  // ignore: non_constant_identifier_names
  int? num_pages;
  List<PostModel>? posts;

  // ignore: non_constant_identifier_names
  PostListModel({this.num_pages, this.posts});

  factory PostListModel.fromJson(Map<String, dynamic> json) {
    return PostListModel(
      num_pages: json['num_pages'],
      posts: json['posts'] != null ? (json['posts'] as List).map((i) => PostModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_pages'] = this.num_pages;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
