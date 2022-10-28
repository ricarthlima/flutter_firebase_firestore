class Produto {
  String id;
  String name;
  double? price;
  double amount;

  Produto({
    required this.id,
    required this.name,
    this.price,
    required this.amount,
  });

  Produto.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        price = map["price"],
        amount = map["amount"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "amount": amount,
    };
  }
}
