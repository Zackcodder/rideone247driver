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

// class DriverModel {
//   String message;
//   String driverName;
//   String? driverEmail;
//   String token;
//   bool isEmailVerified;
//   bool isOnline;
//   bool isAvailable;
//   String? currentTripId;
//   String? currentTripStatus;
//   int walletBalance;
//   int id;
//   String? lastName;
//   String? phoneNumber;
//   String? password;
//   String? publicId;
//   String? onBoardingStatus;
//   String createdAt;
//   int v;
//   bool isApproved;
//   DriverModel(
//       {required this.driverEmail,
//       required this.driverName,
//       required this.message,
//       required this.createdAt,
//       required this.currentTripId,
//       required this.currentTripStatus,
//       required this.id,
//       required this.isApproved,
//       required this.isAvailable,
//       required this.isEmailVerified,
//       required this.isOnline,
//       required this.lastName,
//       required this.onBoardingStatus,
//       required this.password,
//       required this.phoneNumber,
//       required this.publicId,
//       required this.token,
//       required this.v,
//       required this.walletBalance});
//
//   factory DriverModel.fromJson(Map<String, dynamic> json) {
//     return DriverModel(
//       driverEmail: json['email'] ?? '', // Provide a default value if it's null
//       driverName:
//           json['firstName'] ?? '', // Provide a default value if it's null
//       message: json['message'] ?? '',
//       currentTripId: json['currentTripId'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       currentTripStatus: json['currentTripStatus'] ?? '',
//       isApproved:
//           json['isApproved'] ?? false, // Provide a default value if it's null
//       id: json['_id'] ?? 0, // Provide a default value if it's null
//       isAvailable:
//           json['isAvailable'] ?? false, // Provide a default value if it's null
//       isEmailVerified: json['isEmailVerified'] ??
//           false, // Provide a default value if it's null
//       isOnline:
//           json['isOnline'] ?? false, // Provide a default value if it's null
//       lastName: json['lastName'] ?? '', // Provide a default value if it's null
//       onBoardingStatus: json['onBoardingStatus'] ??
//           '', // Provide a default value if it's null
//       password: json['password'] ?? '', // Provide a default value if it's null
//       phoneNumber: json['phone'] ?? '', // Provide a default value if it's null
//       publicId: json['publicId'] ?? '', // Provide a default value if it's null
//       token: json['token'] ?? '', // Provide a default value if it's null
//       v: json['__v'] ?? 0, // Provide a default value if it's null
//       walletBalance: json['walletBalance'] ?? 0,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'driverEmail': driverEmail,
//       'driverName': driverName,
//       'message': message,
//       'token': token,
//       'phoneNumber': phoneNumber,
//       'walletBalance': walletBalance,
//       'lastName': lastName
//     };
//   }
// }
