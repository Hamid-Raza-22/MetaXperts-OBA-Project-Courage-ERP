class ShopStatusModel {
  final String name;
  final String address;
  //final String attendanceStatus;
  final String city;

  ShopStatusModel({
    required this.name,
    required this.address,
    //required this.attendanceStatus,
    required this.city,
  });

  factory ShopStatusModel.fromJson(Map<String, dynamic> json) {
    return ShopStatusModel(
      name: json['shop_name'],
      address: json['shop_address'],
      //attendanceStatus: json['status'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_name': name,
      'shop_address': address,
      //'status': attendanceStatus,
      'city': city,
    };
  }
}
