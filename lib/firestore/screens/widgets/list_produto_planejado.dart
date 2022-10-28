import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/commom/firestore_keys.dart';
import '../../data/produto.dart';

class ListProdutoPlanejadoWidget extends StatelessWidget {
  final List<Produto> list;
  final Function onEdit;
  final Function onDelete;
  final Function onSwap;

  const ListProdutoPlanejadoWidget({
    super.key,
    required this.list,
    required this.onEdit,
    required this.onDelete,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(list.length, (index) {
        Produto produto = list[index];
        return Dismissible(
          key: ValueKey<Produto>(list[index]),
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (DismissDirection direction) {
            onDelete(produto, FirestoreKeys.listaProdutosPlanejados);
          },
          child: ListTile(
            title: Text(produto.name),
            onLongPress: () {
              onEdit(context, toEdit: produto);
            },
            trailing: IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
              onPressed: () {
                onSwap(
                  produto,
                  FirestoreKeys.listaProdutosPlanejados,
                  FirestoreKeys.listaProdutosPegos,
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
