class Order {
  final String orderid;
  final int userid;
  final String fullname;
  final String email;
  final String address;
  final String zip;
  final String phoneno;
  final double totalfinalprice;
  final double discountedtotalprice;
  final int paymentmethod;
  final int orderstatus;
  final DateTime orderdate;

  Order({
    required this.orderid,
    required this.userid,
    required this.fullname,
    required this.email,
    required this.address,
    required this.zip,
    required this.phoneno,
    required this.totalfinalprice,
    required this.discountedtotalprice,
    required this.paymentmethod,
    required this.orderstatus,
    required this.orderdate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderid: json['orderid']?.toString() ?? '',
      userid: int.tryParse(json['userid']?.toString() ?? '') ?? 0,
      fullname: json['fullname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      zip: json['zip']?.toString() ?? '',
      phoneno: json['phoneno']?.toString() ?? '',
      totalfinalprice: double.tryParse(json['totalfinalprice']?.toString() ?? '') ?? 0.0,
      discountedtotalprice: double.tryParse(json['discountedtotalprice']?.toString() ?? '') ?? 0.0,
      paymentmethod: int.tryParse(json['paymentmethod']?.toString() ?? '') ?? 0,
      orderstatus: int.tryParse(json['orderstatus']?.toString() ?? '') ?? 0,
      orderdate: DateTime.tryParse(json['orderdate']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'userid': userid,
      'fullname': fullname,
      'email': email,
      'address': address,
      'zip': zip,
      'phoneno': phoneno,
      'totalfinalprice': totalfinalprice,
      'discountedtotalprice': discountedtotalprice,
      'paymentmethod': paymentmethod,
      'orderstatus': orderstatus,
      'orderdate': orderdate.toIso8601String(),
    };
  }
}
