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
      title: 'Notas Rápidas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotasRapidas(title: 'Notas Rápidas'),
    );
  }
}

class Nota {
  final String titulo;
  final String conteudo;

  Nota({required this.titulo, required this.conteudo});
}

class NotasRapidas extends StatefulWidget {
  const NotasRapidas({super.key, required this.title});

  final String title;

  @override
  State<NotasRapidas> createState() => _NotasRapidasState();
}

class _NotasRapidasState extends State<NotasRapidas> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  final List<Nota> _notas = [];
  String? _errorMessage;

  void _adicionarNota() {
    final titulo = _tituloController.text.trim();
    final conteudo = _conteudoController.text.trim();

    if (titulo.isEmpty || conteudo.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos corretamente.';
      });
      return;
    }
    final novaNota = Nota(titulo: titulo, conteudo: conteudo);
    setState(() {
      _notas.add(novaNota);
      _tituloController.clear();
      _conteudoController.clear();
      _errorMessage = null;
    });
  }

  void _removerNota(Nota nota) {
    setState(() {
      _notas.remove(nota);
    });
  }

  void _mostrarConteudo(Nota nota) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nota.titulo),
          content: SingleChildScrollView(child: Text(nota.conteudo)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Nota',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _conteudoController,
              decoration: const InputDecoration(
                labelText: 'Conteúdo da Nota',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarNota,
              child: const Text('Adicionar Nota'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notas Criadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _notas.isEmpty
                ? const Text('Nenhuma nota cadastrada.')
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _notas.length,
                  itemBuilder: (context, index) {
                    final nota = _notas[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _removerNota(nota),
                      child: Card(
                        child: ListTile(
                          title: Text(nota.titulo),
                          onTap: () => _mostrarConteudo(nota),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
