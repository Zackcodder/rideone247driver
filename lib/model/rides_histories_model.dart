class RidesHistories {
  final String? id;
  final Map<String, dynamic>? pickUpLocation;
  String? pickUpName;
  final Map<String, dynamic>? dropOffLocation;
  String? dropOffName;
  final String? status;
  final Rider? rider;
  final Driver? driver;
  final String? paymentMethod;
  final num? fare;
  final DateTime? createdAt;
  final DateTime? startTime;
  final DateTime? endTime;

  RidesHistories({
    this.id,
    this.pickUpName,
    this.pickUpLocation,
    this.dropOffLocation,
    this.dropOffName,
    this.status,
    this.rider,
    this.driver,
    this.paymentMethod,
    this.fare,
    this.createdAt,
    this.startTime,
    this.endTime,
  });

  factory RidesHistories.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RidesHistories();
    }
    return RidesHistories(
      id: json['_id'],
      pickUpName: json['pickUp'],
      pickUpLocation: json['pickUpLocation'],
      dropOffLocation: json['dropOffLocation'],
      dropOffName: json['dropOff'],
      status: json['status'],
      rider: json['riderId'] != null ? Rider.fromJson(json['riderId']) : null,
      driver: json['driverId'] != null ? Driver.fromJson(json['driverId']) : null,
      paymentMethod: json['paymentMethod'],
      fare: json['fare'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location();
    }
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
    );
  }
}

class Rider {
  final String? id;
  final Location? location;
  final String? avatar;
  final bool? isEmailVerified;
  final String? role;
  final String? openingTime;
  final String? currentTripId;
  final String? currentTripStatus;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? password;
  final String? otp;
  final String? publicId;
  final DateTime? createdAt;
  final int? v;

  Rider({
    this.id,
    this.location,
    this.avatar,
    this.isEmailVerified,
    this.role,
    this.openingTime,
    this.currentTripId,
    this.currentTripStatus,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.password,
    this.otp,
    this.publicId,
    this.createdAt,
    this.v,
  });

  factory Rider.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Rider();
    }
    return Rider(
      id: json['_id'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      avatar: json['avatar'],
      isEmailVerified: json['isEmailVerified'],
      role: json['role'],
      openingTime: json['openingTime'],
      currentTripId: json['currentTripId'],
      currentTripStatus: json['currentTripStatus'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      otp: json['otp'],
      publicId: json['publicId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      v: json['__v'],
    );
  }
}

class Driver {
  final String? id;
  final Location? location;
  final VehicleDetails? vehicleDetails;
  final String? role;
  final bool? isEmailVerified;
  final bool? isOnline;
  final bool? isAvailable;
  final bool? isApproved;
  final String? currentTripId;
  final String? currentTripStatus;
  final int? walletBalance;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? password;
  final String? otp;
  final String? publicId;
  final String? onboardingStatus;
  final DateTime? createdAt;
  final int? v;

  Driver({
    this.id,
    this.location,
    this.vehicleDetails,
    this.role,
    this.isEmailVerified,
    this.isOnline,
    this.isAvailable,
    this.isApproved,
    this.currentTripId,
    this.currentTripStatus,
    this.walletBalance,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.password,
    this.otp,
    this.publicId,
    this.onboardingStatus,
    this.createdAt,
    this.v,
  });

  factory Driver.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Driver();
    }
    return Driver(
      id: json['_id'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      vehicleDetails: json['vehicleDetails'] != null ? VehicleDetails.fromJson(json['vehicleDetails']) : null,
      role: json['role'],
      isEmailVerified: json['isEmailVerified'],
      isOnline: json['isOnline'],
      isAvailable: json['isAvailable'],
      isApproved: json['isApproved'],
      currentTripId: json['currentTripId'],
      currentTripStatus: json['currentTripStatus'],
      walletBalance: json['walletBalance'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      otp: json['otp'],
      publicId: json['publicId'],
      onboardingStatus: json['onboardingStatus'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      v: json['__v'],
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
      licenceDetails: json['licenceDetails'] != null ? LicenceDetails.fromJson(json['licenceDetails']) : null,
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

class LicenceDetails {
  final String? licenceUrl;
  final String? licenceNo;
  final DateTime? issueDate;
  final DateTime? expDate;

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
      issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      expDate: json['expDate'] != null ? DateTime.parse(json['expDate']) : null,
    );
  }
}
