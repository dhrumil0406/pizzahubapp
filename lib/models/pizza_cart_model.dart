class PizzaCart {
  final int cartItemId;
  final int pizzaId;
  final int catId;
  final int userId;
  final int quantity;
  final DateTime itemAddDate;

  PizzaCart({
    required this.cartItemId,
    required this.pizzaId,
    required this.catId,
    required this.userId,
    required this.quantity,
    required this.itemAddDate,
  });

  // Factory constructor to create from JSON (Map)
  factory PizzaCart.fromJson(Map<String, dynamic> json) {
    return PizzaCart(
      cartItemId: int.parse(json['cartitemid'].toString()),
      pizzaId: int.parse(json['pizzaid'].toString()),
      catId: int.parse(json['catid'].toString()),
      userId: int.parse(json['userid'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      itemAddDate: DateTime.parse(json['itemadddate']),
    );
  }

  // Convert to JSON (Map) for requests
  Map<String, dynamic> toJson() {
    return {
      'cartitemid': cartItemId,
      'pizzaid': pizzaId,
      'catid': catId,
      'userid': userId,
      'quantity': quantity,
      'itemadddate': itemAddDate.toIso8601String(),
    };
  }
}
