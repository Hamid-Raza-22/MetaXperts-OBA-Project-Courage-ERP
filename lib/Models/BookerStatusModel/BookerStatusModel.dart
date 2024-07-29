class BookerStatusModel {
  final String name;
  final String designation;
  final String attendanceStatus;
  final String city;

  BookerStatusModel({
    required this.name,
    required this.designation,
    required this.attendanceStatus,
    required this.city,
  });

  factory BookerStatusModel.fromJson(Map<String, dynamic> json) {
    return BookerStatusModel(
      name: json['user_name'],
      designation: json['designation'],
      attendanceStatus: json['status'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': name,
      'designation': designation,
      'status': attendanceStatus,
      'city': city,
    };
  }
}
