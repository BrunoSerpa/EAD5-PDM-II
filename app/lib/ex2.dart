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
      title: 'Cadastro de Tarefas Diárias',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TarefasDiarias(title: 'Cadastro de Tarefas Diárias'),
    );
  }
}

enum Prioridade { baixa, media, alta }

class Tarefa {
  String nome;
  String descricao;
  bool concluida;
  Prioridade prioridade;

  Tarefa({
    required this.nome,
    required this.descricao,
    this.concluida = false,
    this.prioridade = Prioridade.baixa,
  });
}

class TarefasDiarias extends StatefulWidget {
  const TarefasDiarias({super.key, required this.title});

  final String title;

  @override
  State<TarefasDiarias> createState() => _TarefasDiariasState();
}

class _TarefasDiariasState extends State<TarefasDiarias> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  Prioridade _selectedPrioridade = Prioridade.baixa;
  final List<Tarefa> _tarefas = [];

  void _adicionarTarefa() {
    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome da tarefa é obrigatório.')),
      );
      return;
    }
    final novaTarefa = Tarefa(
      nome: nome,
      descricao: descricao,
      prioridade: _selectedPrioridade,
    );
    setState(() {
      _tarefas.add(novaTarefa);
      _nomeController.clear();
      _descricaoController.clear();
      _selectedPrioridade = Prioridade.baixa;
    });
  }

  void _toggleConcluida(Tarefa tarefa, bool? novoValor) {
    setState(() {
      tarefa.concluida = novoValor ?? false;
    });
  }

  void _removerTarefa(Tarefa tarefa) {
    setState(() {
      _tarefas.remove(tarefa);
    });
  }

  String _prioridadeToString(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }

  Color _getPriorityColor(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.alta:
        return Colors.red;
      case Prioridade.media:
        return Colors.yellow;
      case Prioridade.baixa:
        return Colors.green;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Tarefa> tarefasOrdenadas = List.from(_tarefas)
      ..sort((a, b) => b.prioridade.index.compareTo(a.prioridade.index));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Tarefa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (breve)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Prioridade:'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Baixa'),
                        value: Prioridade.baixa,
                        groupValue: _selectedPrioridade,
                        onChanged: (value) {
                          setState(() {
                            _selectedPrioridade = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Média'),
                        value: Prioridade.media,
                        groupValue: _selectedPrioridade,
                        onChanged: (value) {
                          setState(() {
                            _selectedPrioridade = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Alta'),
                        value: Prioridade.alta,
                        groupValue: _selectedPrioridade,
                        onChanged: (value) {
                          setState(() {
                            _selectedPrioridade = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _adicionarTarefa,
                  child: const Text('Adicionar Tarefa'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  tarefasOrdenadas.isEmpty
                      ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
                      : ListView.builder(
                        itemCount: tarefasOrdenadas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefasOrdenadas[index];
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) => _removerTarefa(tarefa),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: _getPriorityColor(tarefa.prioridade),
                                    width: 6.0,
                                  ),
                                ),
                              ),
                              child: Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    value: tarefa.concluida,
                                    onChanged:
                                        (value) =>
                                            _toggleConcluida(tarefa, value),
                                  ),
                                  title: Text(
                                    tarefa.nome,
                                    style: TextStyle(
                                      decoration:
                                          tarefa.concluida
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(tarefa.descricao),
                                      Text(
                                        'Prioridade: ${_prioridadeToString(tarefa.prioridade)}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
