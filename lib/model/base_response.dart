class BaseResponse {
  String? message;
  bool? status;

  BaseResponse({this.message, this.status});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(message: json['message'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
