import 'package:flutter/material.dart';
import '../../data/produto.dart';

class ListProdutoPegoWidget extends StatelessWidget {
  final List<Produto> list;
  const ListProdutoPegoWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(list.length, (index) {
        Produto produto = list[index];
        return ListTile(
          title: Text(produto.name),
        );
      }),
    );
  }
}
