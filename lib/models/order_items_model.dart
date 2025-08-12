class OrderItem {
  final int orderItemId;
  final String orderId;
  final int pizzaId;
  final int catId;
  final int quantity;
  final double discount;

  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.pizzaId,
    required this.catId,
    required this.quantity,
    required this.discount,
  });

  // Convert from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: int.parse(json['orderitemid'].toString()),
      orderId: json['orderid'],
      pizzaId: int.parse(json['pizzaid'].toString()),
      catId: int.parse(json['catid'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      discount: double.parse(json['discount'].toString()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderitemid': orderItemId,
      'orderid': orderId,
      'pizzaid': pizzaId,
      'catid': catId,
      'quantity': quantity,
      'discount': discount,
    };
  }
}
