import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/commom/firestore_keys.dart';
import 'package:flutter_firebase_firestore/firestore/data/produto.dart';
import 'package:flutter_firebase_firestore/firestore/screens/widgets/list_produto_planejado.dart';
import 'package:uuid/uuid.dart';
import '../data/listin.dart';

class ListinScreen extends StatefulWidget {
  final Listin listin;
  const ListinScreen({super.key, required this.listin});

  @override
  State<ListinScreen> createState() => _ListinScreenState();
}

class _ListinScreenState extends State<ListinScreen> {
  List<Produto> listaProdutosPlanejados = [
    Produto(id: "ADASD", name: "Maçã", amount: 2),
    Produto(id: "UUID", name: "Pêra", amount: 3),
  ];
  List<Produto> listaProdutosPegos = [
    Produto(id: "UUID", name: "Laranja", amount: 1),
  ];

  int currentIndex = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.listin.name)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lista"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Pegos"),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: IndexedStack(
          index: currentIndex,
          children: [
            ListProdutoWidget(
              list: listaProdutosPlanejados,
              onEdit: showModalForm,
              onDelete: remove,
              onSwap: swapList,
              isPego: false,
            ),
            ListProdutoWidget(
              list: listaProdutosPegos,
              onEdit: showModalForm,
              onDelete: remove,
              onSwap: swapList,
              isPego: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showModalForm(BuildContext context, {Produto? toEdit, String? keySender}) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _nameController = TextEditingController();
        TextEditingController _amountController = TextEditingController();
        TextEditingController _priceController = TextEditingController();
        String id = const Uuid().v1();

        if (toEdit != null) {
          id = toEdit.id;
          _nameController.text = toEdit.name;
          _amountController.text = toEdit.amount.toString();
          if (toEdit.price != null) {
            _priceController.text = toEdit.price.toString();
          }
        }

        keySender ??= FirestoreKeys.listaProdutosPlanejados;

        return AlertDialog(
          title: Text(
              (toEdit == null) ? "Novo Produto" : "Editar '${toEdit.name}'"),
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text("Nome"),
                ),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  label: Text("Quantidade"),
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  label: Text("Preço"),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Produto produto = Produto(
                    id: id,
                    name: _nameController.text,
                    amount: double.parse(_amountController.text));
                if (_priceController.text != "") {
                  produto.price = double.parse(_priceController.text);
                }
                firestore
                    .collection(FirestoreKeys.listins)
                    .doc(widget.listin.id)
                    .collection(keySender!)
                    .doc(id)
                    .set(produto.toMap());
                refresh();
                Navigator.pop(context);
              },
              child: Text((toEdit == null) ? "Adicionar" : "Editar"),
            )
          ],
        );
      },
    );
  }

  refresh() async {
    QuerySnapshot<Map<String, dynamic>> snapshotPlanejados = await firestore
        .collection(FirestoreKeys.listins)
        .doc(widget.listin.id)
        .collection(FirestoreKeys.listaProdutosPlanejados)
        .get();

    QuerySnapshot<Map<String, dynamic>> snapshotPegos = await firestore
        .collection(FirestoreKeys.listins)
        .doc(widget.listin.id)
        .collection(FirestoreKeys.listaProdutosPegos)
        .get();

    setState(() {
      listaProdutosPlanejados = _fillList(snapshotPlanejados);
      listaProdutosPegos = _fillList(snapshotPegos);
    });

    return true;
  }

  List<Produto> _fillList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Produto> listTemp = [];

    for (var doc in snapshot.docs) {
      listTemp.add(Produto.fromMap(doc.data()));
    }

    return listTemp;
  }

  remove(Produto toRemove, String listCollection) async {
    await firestore
        .collection(FirestoreKeys.listins)
        .doc(widget.listin.id)
        .collection(listCollection)
        .doc(toRemove.id)
        .delete();
    refresh();
  }

  swapList(
    Produto produto,
    String listSender,
    String listReceiver,
  ) {
    // Remover da lista antiga
    remove(produto, listSender);

    // Adicionar na nova lista
    firestore
        .collection(FirestoreKeys.listins)
        .doc(widget.listin.id)
        .collection(listReceiver)
        .doc(produto.id)
        .set(produto.toMap());

    refresh();
  }
}
