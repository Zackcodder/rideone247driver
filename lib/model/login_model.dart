class UserDetails {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final bool isEmailVerified;
  final bool isOnline;
  final bool isAvailable;
  final bool isApproved;
  final int walletBalance;
  final String id;
  // final String image;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isEmailVerified,
    required this.isOnline,
    required this.isAvailable,
    required this.isApproved,
    required this.walletBalance,
    required this.id,
    // required this.image,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      isOnline: json['isOnline'],
      isAvailable: json['isAvailable'],
      isApproved: json['isApproved'],
      walletBalance: json['walletBalance'],
      id: json['_id'],
      // image: json['avatar'],
    );
  }
}

class DriverModel {
  final String message;
  final UserData data;

  DriverModel({required this.message, required this.data});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final UserDetails userDetails;
  final String token;

  UserData({required this.userDetails, required this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userDetails: UserDetails.fromJson(json['userDetails']),
      token: json['token'],
    );
  }
}
