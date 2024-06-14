class Location {
  final String? type;
  final List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location();
    }
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((x) => (x as num).toDouble())
          .toList(),
    );
  }
}

class LicenceDetails {
  final String? licenceUrl;
  final String? licenceNo;
  final String? issueDate;
  final String? expDate;

  LicenceDetails({
    this.licenceUrl,
    this.licenceNo,
    this.issueDate,
    this.expDate,
  });

  factory LicenceDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LicenceDetails();
    }
    return LicenceDetails(
      licenceUrl: json['licenceUrl'],
      licenceNo: json['licenceNo'],
      issueDate: json['issueDate'],
      expDate: json['expDate'],
    );
  }
}

class VehicleDetails {
  final LicenceDetails? licenceDetails;
  final String? make;
  final String? model;
  final int? year;
  final String? numberPlate;
  final String? color;
  final String? insuranceUrl;
  final String? vehiclePaperUrl;

  VehicleDetails({
    this.licenceDetails,
    this.make,
    this.model,
    this.year,
    this.numberPlate,
    this.color,
    this.insuranceUrl,
    this.vehiclePaperUrl,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VehicleDetails();
    }
    return VehicleDetails(
      licenceDetails: json['licenceDetails'] != null
          ? LicenceDetails.fromJson(json['licenceDetails'])
          : null,
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
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final bool? isEmailVerified;
  final bool? isOnline;
  final bool? isAvailable;
  final bool? isApproved;
  final int? walletBalance;
  final String? role;
  final String? onboardingStatus;
  final String? createdAt;
  final int? v;
  final Location? location;
  final VehicleDetails? vehicleDetails;

  Driver({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.isEmailVerified,
    this.isOnline,
    this.isAvailable,
    this.isApproved,
    this.walletBalance,
    this.role,
    this.onboardingStatus,
    this.createdAt,
    this.v,
    this.location,
    this.vehicleDetails,
  });

  factory Driver.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Driver();
    }
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
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetails.fromJson(json['vehicleDetails'])
          : null,
    );
  }
}

class Data {
  final Driver? driver;
  final String? token;

  Data({this.driver, this.token});

  factory Data.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Data();
    }
    return Data(
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      token: json['token'],
    );
  }
}

class DriverModel {
  final String? message;
  final Data? data;

  DriverModel({this.message, this.data});

  factory DriverModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DriverModel();
    }
    return DriverModel(
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}
