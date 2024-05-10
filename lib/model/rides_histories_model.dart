class RidesHistories {
  final String id;
  final Location pickUpLocation;
  String pickUpName;
  final Location dropOffLocation;
  String dropOffName;
  final String status;
  final Rider rider;
  final Driver driver;
  final String paymentMethod;
  final num? fare;
  final DateTime createdAt;

  RidesHistories({
    required this.id,
    required this.pickUpName,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.dropOffName,
    required this.status,
    required this.rider,
    required this.driver,
    required this.paymentMethod,
    required this.fare,
    required this.createdAt,
  });

  factory RidesHistories.fromJson(Map<String, dynamic> json) {
    return RidesHistories(
      id: json['_id'],
      pickUpName: json['pickUp'] ?? '',
      pickUpLocation: Location.fromJson(json['pickUpLocation']),
      dropOffLocation: Location.fromJson(json['dropOffLocation']),
      dropOffName: json['dropOff'] ?? '',
      status: json['status'],
      rider: Rider.fromJson(json['riderId']),
      driver: Driver.fromJson(json['driverId']),
      paymentMethod: json['paymentMethod'],
      fare: json['fare'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
      List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class Rider {
  final String id;
  final Location location;
  final String avatar;
  final bool isEmailVerified;
  final String role;
  final String openingTime;
  final String currentTripId;
  final String currentTripStatus;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String? otp;
  final String publicId;
  final DateTime createdAt;
  final int v;

  Rider({
    required this.id,
    required this.location,
    required this.avatar,
    required this.isEmailVerified,
    required this.role,
    required this.openingTime,
    required this.currentTripId,
    required this.currentTripStatus,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.otp,
    required this.publicId,
    required this.createdAt,
    required this.v,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['_id'],
      location: Location.fromJson(json['location']),
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
      createdAt: DateTime.parse(json['createdAt']),
      v: json['__v'],
    );
  }
}

class Driver {
  final String id;
  final Location location;
  final VehicleDetails vehicleDetails;
  final String role;
  final bool isEmailVerified;
  final bool isOnline;
  final bool isAvailable;
  final bool isApproved;
  final String? currentTripId;
  final String currentTripStatus;
  final int walletBalance;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String? otp;
  final String publicId;
  final String onboardingStatus;
  final DateTime createdAt;
  final int v;

  Driver({
    required this.id,
    required this.location,
    required this.vehicleDetails,
    required this.role,
    required this.isEmailVerified,
    required this.isOnline,
    required this.isAvailable,
    required this.isApproved,
    required this.currentTripId,
    required this.currentTripStatus,
    required this.walletBalance,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.otp,
    required this.publicId,
    required this.onboardingStatus,
    required this.createdAt,
    required this.v,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      location: Location.fromJson(json['location']),
      vehicleDetails: VehicleDetails.fromJson(json['vehicleDetails']),
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
      createdAt: DateTime.parse(json['createdAt']),
      v: json['__v'],
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

class LicenceDetails {
  final String licenceUrl;
  final String licenceNo;
  final DateTime issueDate;
  final DateTime expDate;

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
      issueDate: DateTime.parse(json['issueDate']),
      expDate: DateTime.parse(json['expDate']),
    );
  }
}
