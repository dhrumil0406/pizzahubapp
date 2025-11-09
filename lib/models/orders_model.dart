class Order {
  final String orderid;
  final int userid;
  final String fullname;
  final String email;
  final int addressId;
  final String address;
  final String phoneno;
  final double totalfinalprice;
  final double discountedtotalprice;
  final int paymentId;
  final int paymentmethod;
  final int orderstatus;
  final DateTime orderdate;

  Order({
    required this.orderid,
    required this.userid,
    required this.fullname,
    required this.email,
    required this.addressId,
    required this.address,
    required this.phoneno,
    required this.totalfinalprice,
    required this.discountedtotalprice,
    required this.paymentId,
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
      addressId: int.tryParse(json['addressid']?.toString() ?? '0') ?? 0,
      address: json['address']?.toString() ?? '',
      phoneno: json['phoneno']?.toString() ?? '',
      totalfinalprice: double.tryParse(json['totalfinalprice']?.toString() ?? '') ?? 0.0,
      discountedtotalprice: double.tryParse(json['discountedtotalprice']?.toString() ?? '') ?? 0.0,
      paymentId: int.tryParse(json['paymentid']?.toString() ?? '0') ?? 0,
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
      'addressid': addressId,
      'address': address,
      'phoneno': phoneno,
      'totalfinalprice': totalfinalprice,
      'discountedtotalprice': discountedtotalprice,
      'paymentid': paymentId,
      'paymentmethod': paymentmethod,
      'orderstatus': orderstatus,
      'orderdate': orderdate.toIso8601String(),
    };
  }
}
