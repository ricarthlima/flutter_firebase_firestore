import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/commom/firestore_keys.dart';
import '../../data/produto.dart';

class ListProdutoWidget extends StatelessWidget {
  final List<Produto> list;
  final bool isPego;
  final Function onEdit;
  final Function onDelete;
  final Function onSwap;

  const ListProdutoWidget({
    super.key,
    required this.list,
    required this.onEdit,
    required this.onDelete,
    required this.onSwap,
    required this.isPego,
  });

  @override
  Widget build(BuildContext context) {
    String keySender = FirestoreKeys.listaProdutosPlanejados;
    String keyReceiver = FirestoreKeys.listaProdutosPegos;

    if (isPego) {
      keySender = FirestoreKeys.listaProdutosPegos;
      keyReceiver = FirestoreKeys.listaProdutosPlanejados;
    }

    return Column(
      children: [
        Visibility(
          visible: isPego,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  "R\$${getTotalPrice()}",
                  style: TextStyle(fontSize: 42),
                ),
                const Text(
                  "total previsto para essa compra",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(list.length, (index) {
                Produto produto = list[index];
                String priceString =
                    (produto.price != null) ? produto.price!.toString() : "-";
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
                    onDelete(produto, keySender);
                  },
                  child: ListTile(
                    title: Text(produto.name),
                    subtitle: Text("R\$ $priceString"),
                    onTap: () {
                      onEdit(context, toEdit: produto, keySender: keySender);
                    },
                    leading: IconButton(
                      icon: (!isPego)
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.grey,
                            ),
                      onPressed: () {
                        onSwap(
                          produto,
                          keySender,
                          keyReceiver,
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (Produto produto in list) {
      if (produto.price != null) {
        totalPrice += produto.price!;
      }
    }
    return totalPrice;
  }
}
