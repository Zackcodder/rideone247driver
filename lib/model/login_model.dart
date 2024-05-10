// class UserDetails {
//   final String firstName;
//   final String lastName;
//   final String phone;
//   final String email;
//   final bool isEmailVerified;
//   final bool isOnline;
//   final bool isAvailable;
//   final bool isApproved;
//   final int walletBalance;
//   final String id;
//   // final String image;
//
//   UserDetails({
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//     required this.email,
//     required this.isEmailVerified,
//     required this.isOnline,
//     required this.isAvailable,
//     required this.isApproved,
//     required this.walletBalance,
//     required this.id,
//     // required this.image,
//   });
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       phone: json['phone'],
//       email: json['email'],
//       isEmailVerified: json['isEmailVerified'],
//       isOnline: json['isOnline'],
//       isAvailable: json['isAvailable'],
//       isApproved: json['isApproved'],
//       walletBalance: json['walletBalance'],
//       id: json['_id'],
//       // image: json['avatar'],
//     );
//   }
// }
//
// class DriverModel {
//   final String message;
//   final UserData data;
//
//   DriverModel({required this.message, required this.data});
//
//   factory DriverModel.fromJson(Map<String, dynamic> json) {
//     return DriverModel(
//       message: json['message'],
//       data: UserData.fromJson(json['data']),
//     );
//   }
// }
//
// class UserData {
//   final UserDetails userDetails;
//   final String token;
//
//   UserData({required this.userDetails, required this.token});
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       userDetails: UserDetails.fromJson(json['userDetails']),
//       token: json['token'],
//     );
//   }
// }
class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class LicenceDetails {
  final String licenceUrl;
  final String licenceNo;
  final String issueDate;
  final String expDate;

  LicenceDetails({
    required this.licenceUrl,
    required this.licenceNo,
    required this.issueDate,
    required this.expDate,
  });

  factory LicenceDetails.fromJson(Map<String, dynamic> json) {
    return LicenceDetails(
      licenceUrl: json['licenceUrl'],
      licenceNo: json['licenceNo'],
      issueDate: json['issueDate'],
      expDate: json['expDate'],
    );
  }
}

class VehicleDetails {
  final LicenceDetails licenceDetails;
  final String make;
  final String model;
  final int year;
  final String numberPlate;
  final String color;
  final String insuranceUrl;
  final String vehiclePaperUrl;

  VehicleDetails({
    required this.licenceDetails,
    required this.make,
    required this.model,
    required this.year,
    required this.numberPlate,
    required this.color,
    required this.insuranceUrl,
    required this.vehiclePaperUrl,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      licenceDetails: LicenceDetails.fromJson(json['licenceDetails']),
      make: json['make'],
      model: json['model'],
      year: json['year'],
      numberPlate: json['numberPlate'],
      color: json['color'],
      insuranceUrl: json['insuranceUrl'],
      vehiclePaperUrl: json['vehiclePaperUrl'],
    );
  }
}

class Driver {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final bool isEmailVerified;
  final bool isOnline;
  final bool isAvailable;
  final bool isApproved;
  final int walletBalance;
  final String role;
  final String onboardingStatus;
  final String createdAt;
  final int v;

  final Location location;
  final VehicleDetails vehicleDetails;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isEmailVerified,
    required this.isOnline,
    required this.isAvailable,
    required this.isApproved,
    required this.walletBalance,
    required this.role,
    required this.onboardingStatus,
    required this.createdAt,
    required this.v,
    required this.location,
    required this.vehicleDetails,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      isOnline: json['isOnline'],
      isAvailable: json['isAvailable'],
      isApproved: json['isApproved'],
      walletBalance: json['walletBalance'],
      role: json['role'],
      onboardingStatus: json['onboardingStatus'],
      createdAt: json['createdAt'],
      v: json['__v'],
      location: Location.fromJson(json['location']),
      vehicleDetails: VehicleDetails.fromJson(json['vehicleDetails']),
    );
  }
}

class Data {
  final Driver driver;
  final String token;

  Data({required this.driver, required this.token});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      driver: Driver.fromJson(json['driver']),
      token: json['token'],
    );
  }
}

class DriverModel {
  final String message;
  final Data data;

  DriverModel({required this.message, required this.data});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}
