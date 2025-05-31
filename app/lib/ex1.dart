import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaCompras(title: 'Lista de Compras'),
    );
  }
}

class ListaItem {
  String nome;
  bool comprado;

  ListaItem({required this.nome, this.comprado = false});
}

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key, required this.title});
  final String title;

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  final TextEditingController _itemController = TextEditingController();
  final List<ListaItem> _itens = [];

  void _adicionarItem() {
    final texto = _itemController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        _itens.add(ListaItem(nome: texto));
        _itemController.clear();
      });
    }
  }

  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _itens[index].comprado = !_itens[index].comprado;
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _adicionarItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _adicionarItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _itens.length,
              itemBuilder: (context, index) {
                final item = _itens[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removerItem(index);
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: item.comprado,
                      onChanged: (_) => _toggleItem(index),
                    ),
                    title: Text(
                      item.nome,
                      style: TextStyle(
                        decoration:
                            item.comprado ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
