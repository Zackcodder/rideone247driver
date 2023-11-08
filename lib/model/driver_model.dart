class DriverModel {
  String? message;
  String? driverName;
  String? driverEmail;

  DriverModel({
    required this.driverEmail,
    required this.driverName,
    required this.message,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
        driverEmail: json['loginId'],
        driverName: json['firstName'],
        message: json['message']);
  }
  Map<String, dynamic> toJson() {
    return {
      'driverEmail': driverEmail,
      'driverName': driverName,
      'message': message,
    };
  }
}
