class OrderItem {
  final int orderitemid;
  final String orderid;
  final int pizzaid;
  final int catid;
  final int quantity;
  final String discount;
  final String pizzaname;
  final String pizzaprice;
  final String pizzaimage;
  final String? catname;
  final String? catimage;
  final int? iscombo;
  final String? comboprice;

  OrderItem({
    required this.orderitemid,
    required this.orderid,
    required this.pizzaid,
    required this.catid,
    required this.quantity,
    required this.discount,
    required this.pizzaname,
    required this.pizzaprice,
    required this.pizzaimage,
    this.catname,
    this.catimage,
    this.iscombo,
    this.comboprice,
  });

  // 🔹 discounted price = (price - discount)
  String get discountedPrice {
    double price = double.tryParse(iscombo == 1 ? (comboprice ?? "0") : pizzaprice) ?? 0;
    double discountPercent = double.tryParse(discount) ?? 0;

    double discounted = price - (price * discountPercent / 100);
    return discounted.toStringAsFixed(2);
  }


  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderitemid: json['orderitemid'],
      orderid: json['orderid'],
      pizzaid: json['pizzaid'],
      catid: json['catid'],
      quantity: json['quantity'],
      discount: json['discount'],
      pizzaname: json['pizzaname'],
      pizzaprice: json['pizzaprice'],
      pizzaimage: json['pizzaimage'],
      catname: json['catname'],
      catimage: json['catimage'],
      iscombo: json['iscombo'],
      comboprice: json['comboprice'],
    );
  }
}
