class DriverInformation {
  final DriverProfile? profile;

  DriverInformation({this.profile});

  factory DriverInformation.fromJson(Map<String, dynamic> json) {
    return DriverInformation(
      profile: json['data'] != null
          ? DriverProfile.fromJson(json['data']['profile'])
          : null,
    );
  }
}

class DriverProfile {
  final Driver? driver;
  final VehicleDetails? vehicleDetails;
  final int? completedTrips;
  final double? balance;
  final double? averageRating;

  DriverProfile({
    this.driver,
    this.vehicleDetails,
    this.completedTrips,
    this.balance,
    this.averageRating,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      driver: json['driver'] != null
          ? Driver.fromJson(json['driver'])
          : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetails.fromJson(json['vehicleDetails'])
          : null,
      completedTrips: json['completedTrips'],
      balance: json['balance'].toDouble(),
      averageRating: json['averageRating'].toDouble(),
    );
  }
}

class Driver {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  late final String? phone;
  final bool? online;
  final bool? isAvailable;

  Driver({
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.phone,
    this.online,
    this.isAvailable,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      avatar: json['avatar'],
      phone: json['phone'],
      online: json['online'],
      isAvailable: json['isAvailable'],
    );
  }
}

class VehicleDetails {
  final LicenceDetails? licenceDetails;
  late final String? make;
  late final String? model;
  late final int? year;
  final String? numberPlate;
  late final String? color;
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

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
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

  factory LicenceDetails.fromJson(Map<String, dynamic> json) {
    return LicenceDetails(
      licenceUrl: json['licenceUrl'],
      licenceNo: json['licenceNo'],
      issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      expDate: json['expDate'] != null ? DateTime.parse(json['expDate']) : null,
    );
  }
}
