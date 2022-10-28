import 'package:flutter/material.dart';
import '../../data/produto.dart';

class ListProdutoPlanejadoWidget extends StatelessWidget {
  final List<Produto> list;
  final Function onEdit;
  const ListProdutoPlanejadoWidget(
      {super.key, required this.list, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(list.length, (index) {
        Produto produto = list[index];
        return ListTile(
          title: Text(produto.name),
          onLongPress: () {
            onEdit(context, toEdit: produto);
          },
        );
      }),
    );
  }
}
