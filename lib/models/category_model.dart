class PizzaCategory {
  final int catid;
  final String catname;
  final String catimage;
  final String catdesc;
  final int cattype;
  final int iscombo;
  final double comboprice;
  final double discount;

  PizzaCategory({
    required this.catid,
    required this.catname,
    required this.catimage,
    required this.catdesc,
    required this.cattype,
    required this.iscombo,
    required this.comboprice,
    required this.discount,
  });

  factory PizzaCategory.fromJson(Map<String, dynamic> json) {
    return PizzaCategory(
      catid: int.tryParse(json['catid'].toString()) ?? 0,
      catname: json['catname'] ?? '',
      catimage: json['catimage'] ?? '',
      catdesc: json['catdesc'] ?? '',
      cattype: int.tryParse(json['cattype'].toString()) ?? 0,
      iscombo: int.tryParse(json['iscombo'].toString()) ?? 0,
      comboprice: double.tryParse(json['comboprice'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
    );
  }
}
