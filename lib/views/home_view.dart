import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/models.dart';

class HomeView extends StatefulWidget {
  static const String routeName = 'home';

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> bands = [
    Band(id: '1', name: 'Genitalica', votes: 1),
    Band(id: '2', name: 'Elefante', votes: 4),
    Band(id: '3', name: 'Panteón Rococó', votes: 5),
    Band(id: '4', name: 'Ska-P', votes: 2),
    Band(id: '5', name: 'Los Fabulosos Cádillacs', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Nombres',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 16),
        child: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (listViewContext, i) => _bandTile(bands[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Dismissible _bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // TODO: se manda llamar el método para eliminar del backend
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            banda.name.substring(0, 2),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        title: Text(banda.name),
        trailing: CircleAvatar(
          backgroundColor: Colors.black38,
          maxRadius: 14,
          child: Text(
            '${banda.votes}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {
          print(banda.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nueva banda'),
          content: TextField(
            controller: textController,
            cursorColor: Colors.deepOrange,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
            ),
          ),
          actions: [
            MaterialButton(
              child: const Text('Agregar'),
              textColor: Colors.deepOrange,
              elevation: 5,
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  addBandToList(textController.text);
                }
              },
            ),
          ],
        ),
      );
    } else if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('Nueva banda'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Agregar'),
                onPressed: addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  addBandToList(String name) {
    if (name.isNotEmpty) {
      final ultimoID = int.parse(bands[bands.length - 1].id);
      setState(() {
        bands.add(Band(id: '${ultimoID + 1}', name: name, votes: 0));
      });
      Navigator.pop(context);
    }
  }
}
