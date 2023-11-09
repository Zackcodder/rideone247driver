class SignUpResponse {
  String message;
  Data data;

  SignUpResponse({required this.message, required this.data});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  NewUser newUser;
  String token;

  Data({required this.newUser, required this.token});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      newUser: NewUser.fromJson(json['newUser']),
      token: json['token'],
    );
  }
}

class NewUser {
  String status;
  String message;

  NewUser({required this.status, required this.message});

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      status: json['status'],
      message: json['message'],
    );
  }
}
