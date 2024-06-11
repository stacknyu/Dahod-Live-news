class LoginResponse {
  String? displayName;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? token;
  String? userDisplayName;
  String? userEmail;
  int? userId;
  String? userNiceName;
  String? userLogin;

  bool? isUpdatedProfile;

  LoginResponse(
      {this.displayName, this.firstName, this.lastName, this.profileImage, this.token, this.userDisplayName, this.userEmail, this.userId, this.userNiceName, this.userLogin, this.isUpdatedProfile});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      displayName: json['display_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],
      token: json['token'],
      userDisplayName: json['user_display_name'],
      userEmail: json['user_email'],
      userId: json['user_id'],
      userNiceName: json['user_nicename'],
      userLogin: json['user_login'],
      isUpdatedProfile: json['iq_is_rest_profile_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['token'] = this.token;
    data['user_display_name'] = this.userDisplayName;
    data['user_email'] = this.userEmail;
    data['user_id'] = this.userId;
    data['user_nicename'] = this.userNiceName;
    data['user_login'] = this.userLogin;
    data['iq_is_rest_profile_updated'] = isUpdatedProfile;
    return data;
  }
}
