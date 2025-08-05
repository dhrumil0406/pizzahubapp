class PizzaCategory {
  final int catid;
  final String catname;
  final String catimage;
  final String catdesc;
  final int cattype;
  final int iscombo;
  final double comboprice;
  final double discount;
  final DateTime catcreatedate;
  final DateTime catupdatedate;

  PizzaCategory({
    required this.catid,
    required this.catname,
    required this.catimage,
    required this.catdesc,
    required this.cattype,
    required this.iscombo,
    required this.comboprice,
    required this.discount,
    required this.catcreatedate,
    required this.catupdatedate
  });

  factory PizzaCategory.fromJson(Map<String, dynamic> json) {
    return PizzaCategory(
      catid: int.tryParse(json['catid'].toString()) ?? 0,
      catname: json['catname']?.toString() ?? '',
      catimage: json['catimage']?.toString() ?? '',
      catdesc: json['catdesc']?.toString() ?? '',
      cattype: int.tryParse(json['cattype'].toString()) ?? 0,
      iscombo: int.tryParse(json['iscombo'].toString()) ?? 0,
      comboprice: double.tryParse(json['comboprice'].toString()) ?? 0.0,
      discount: double.tryParse(json['catdiscount'].toString()) ?? 0.0,
      catcreatedate: DateTime.tryParse(json['catcreatedate']?.toString() ?? '') ?? DateTime.now(),
      catupdatedate: DateTime.tryParse(json['catupdatedate']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catid': catid,
      'catname': catname,
      'catimage': catimage,
      'catdesc': catdesc,
      'cattype': cattype,
      'iscombo': iscombo,
      'comboprice': comboprice,
      'discount': discount,
      'catcreatedate': catcreatedate.toIso8601String(),
      'catupdatedate': catupdatedate.toIso8601String()
    };
  }
}
