class RSMStatusModel {

  final String bookerId;
  final String name;
  final String designation;
  final String attendanceStatus;
  final String city;

  RSMStatusModel({
    required this.bookerId,
    required this.name,
    required this.designation,
    required this.attendanceStatus,
    required this.city,
  });

  factory RSMStatusModel.fromJson(Map<String, dynamic> json) {
    return RSMStatusModel(
      bookerId: json['user_id'],
      name: json['user_name'],
      designation: json['designation'],
      attendanceStatus: json['status'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id':bookerId,
      'user_name': name,
      'designation': designation,
      'status': attendanceStatus,
      'city': city,
    };
  }
}
