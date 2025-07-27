class Pizza {
  final int pizzaid ;
  final String pizzaname;
  final double pizzaprice;
  final String pizzaimage;
  final String pizzadesc;
  final int catid ;
  final double discount;

  Pizza({
    required this.pizzaid,
    required this.pizzaname,
    required this.pizzaprice,
    required this.pizzaimage,
    required this.pizzadesc,
    required this.catid,
    required this.discount,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      pizzaid: int.tryParse(json['pizzaid'].toString()) ?? 0,
      pizzaname: json['pizzaname'] ?? '',
      pizzaprice: double.tryParse(json['pizzaprice'].toString()) ?? 0,
      pizzaimage: json['pizzaimage'] ?? '',
      pizzadesc: json['pizzadesc'] ?? '',
      catid: int.parse(json['catid'].toString()),
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
    );
  }
}
