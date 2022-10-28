import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore/firestore/data/listin.dart';
import 'package:flutter_firebase_firestore/firestore/screens/listin_screen.dart';
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
              return Dismissible(
                key: ValueKey<Listin>(listListin[index]),
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
                  remove(model);
                },
                child: ListTile(
                  title: Text(model.name),
                  subtitle: Text(model.id),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ListinScreen(listin: model);
                    }));
                  },
                  onLongPress: () {
                    showModalForm(context, toEdit: model);
                  },
                ),
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

  showModalForm(BuildContext context, {Listin? toEdit}) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _nameController = TextEditingController();
        String id = const Uuid().v1();

        if (toEdit != null) {
          _nameController.text = toEdit.name;
          id = toEdit.id;
        }

        return AlertDialog(
          title:
              Text((toEdit == null) ? "Nova Lista" : "Editar '${toEdit.name}'"),
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
              child: Text((toEdit == null) ? "Adicionar" : "Editar"),
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

  remove(Listin listin) async {
    await firestore.collection("listins").doc(listin.id).delete();
    refresh();
  }
}
