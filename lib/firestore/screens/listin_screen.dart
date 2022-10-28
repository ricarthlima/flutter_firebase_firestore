import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/data/listin.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListin = [
    Listin(id: "UUID", name: "Lista de Outubro"),
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listas de Compras")),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: ListView(
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
        TextEditingController _nameController = TextEditingController();
        String id = const Uuid().v1();

        return AlertDialog(
          title: const Text("Nova Lista"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text("Nome"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Listin listin = Listin(id: id, name: _nameController.text);
                firestore.collection("listins").doc(id).set(listin.toMap());
                refresh();
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            )
          ],
        );
      },
    );
  }

  refresh() async {
    List<Listin> listTemp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("listins").get();
    for (var doc in snapshot.docs) {
      listTemp.add(Listin.fromMap(doc.data()));
    }

    setState(() {
      listListin = listTemp;
    });

    return true;
  }
}
