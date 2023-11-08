class DriverModel {
  String? message;
  String? driverName;
  String? driverEmail;
  String token;
  bool isEmailVerified;
  bool isOnline;
  bool isAvailable;
  String? currentTripId;
  String? currentTripStatus;
  int walletBalance;
  int id;
  String? lastName;
  String? phoneNumber;
  String? password;
  String? publicId;
  String? onBoardingStatus;
  String createdAt;
  int v;
  bool isApproved;
  DriverModel(
      {required this.driverEmail,
      required this.driverName,
      required this.message,
      required this.createdAt,
      required this.currentTripId,
      required this.currentTripStatus,
      required this.id,
      required this.isApproved,
      required this.isAvailable,
      required this.isEmailVerified,
      required this.isOnline,
      required this.lastName,
      required this.onBoardingStatus,
      required this.password,
      required this.phoneNumber,
      required this.publicId,
      required this.token,
      required this.v,
      required this.walletBalance});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      driverEmail: json['email'],
      driverName: json['firstName'],
      message: json['message'],
      currentTripId: json['currentTripId'],
      createdAt: json['createdAt'],
      currentTripStatus: json['currentTripStatus'],
      isApproved: json['isApproved'],
      id: json['_id'],
      isAvailable: json['isAvailable'],
      isEmailVerified: json['isEmailVerified'],
      isOnline: json['isOnline'],
      lastName: json['lastName'],
      onBoardingStatus: json['onBoardingStatus'],
      password: json['password'],
      phoneNumber: json['phone'],
      publicId: json['publicId'],
      token: json['token'],
      v: json['__v'],
      walletBalance: json['walletBalance'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'driverEmail': driverEmail,
      'driverName': driverName,
      'message': message,
      'token': token,
      'phoneNumber': phoneNumber,
      'walletBalance': walletBalance,
      'lastName': lastName
    };
  }
}
