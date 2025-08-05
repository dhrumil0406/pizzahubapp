class Pizza {
  final int pizzaid;
  final String pizzaname;
  final double pizzaprice;
  final String pizzaimage;
  final String pizzadesc;
  final int catid;
  final double discount;
  final DateTime pizzacreatedate;
  final DateTime pizzaupdatedate;

  Pizza({
    required this.pizzaid,
    required this.pizzaname,
    required this.pizzaprice,
    required this.pizzaimage,
    required this.pizzadesc,
    required this.catid,
    required this.discount,
    required this.pizzacreatedate,
    required this.pizzaupdatedate
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      pizzaid: int.tryParse(json['pizzaid']?.toString() ?? '') ?? 0,
      pizzaname: json['pizzaname']?.toString() ?? '',
      pizzaprice: double.tryParse(json['pizzaprice']?.toString() ?? '') ?? 0.0,
      pizzaimage: json['pizzaimage']?.toString() ?? '',
      pizzadesc: json['pizzadesc']?.toString() ?? '',
      catid: int.tryParse(json['catid']?.toString() ?? '') ?? 0,
      discount: double.tryParse(json['pizzadiscount']?.toString() ?? '') ?? 0.0,
      pizzacreatedate: DateTime.tryParse(json['pizzacreatedate']?.toString() ?? '') ?? DateTime.now(),
      pizzaupdatedate: DateTime.tryParse(json['pizzaupdatedate']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pizzaid': pizzaid,
      'pizzaname': pizzaname,
      'pizzaprice': pizzaprice,
      'pizzaimage': pizzaimage,
      'pizzadesc': pizzadesc,
      'catid': catid,
      'discount': discount,
      'pizzacreatedate': pizzacreatedate.toIso8601String(),
      'pizzaupdatedate': pizzaupdatedate.toIso8601String()
    };
  }
}
