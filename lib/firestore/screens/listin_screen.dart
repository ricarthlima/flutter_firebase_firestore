import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/data/listin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListin = [
    Listin(id: "UUID", name: "Lista de Outubro"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listas de Compras")),
      body: ListView(
        children: List.generate(
          listListin.length,
          (index) {
            Listin model = listListin[index];
            return ListTile(
              title: Text(model.name),
              subtitle: Text(model.id),
            );
          },
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

  showModalForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Lista"),
          content: const TextField(
            decoration: InputDecoration(
              label: Text("Nome"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Adicionar"),
            )
          ],
        );
      },
    );
  }
}
