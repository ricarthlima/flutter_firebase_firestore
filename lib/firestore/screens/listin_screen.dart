import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/data/produto.dart';
import 'package:flutter_firebase_firestore/firestore/screens/widgets/list_produto_pego.dart';
import 'package:flutter_firebase_firestore/firestore/screens/widgets/list_produto_planejado.dart';
import '../data/listin.dart';

class ListinScreen extends StatefulWidget {
  final Listin listin;
  const ListinScreen({super.key, required this.listin});

  @override
  State<ListinScreen> createState() => _ListinScreenState();
}

class _ListinScreenState extends State<ListinScreen> {
  List<Produto> listaProdutosPlanejados = [
    Produto(id: "ADASD", name: "Maçã"),
    Produto(id: "UUID", name: "Pêra"),
  ];
  List<Produto> listaProdutosPegos = [
    Produto(id: "UUID", name: "Laranja"),
  ];

  int currentIndex = 0;

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
      body: IndexedStack(
        index: currentIndex,
        children: [
          ListProdutoPlanejadoWidget(list: listaProdutosPlanejados),
          ListProdutoPegoWidget(list: listaProdutosPegos),
        ],
      ),
    );
  }
}
