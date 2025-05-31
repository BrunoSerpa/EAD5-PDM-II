import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FormularioFeedback(title: 'Formulário de Feedback'),
    );
  }
}

enum Avaliacao { excelente, bom, regular, ruim }

class FormularioFeedback extends StatefulWidget {
  const FormularioFeedback({super.key, required this.title});

  final String title;

  @override
  State<FormularioFeedback> createState() => _FormularioFeedbackState();
}

class _FormularioFeedbackState extends State<FormularioFeedback> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _comentariosController = TextEditingController();

  Avaliacao? _avaliacao;

  void _enviarFeedback() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final comentarios = _comentariosController.text.trim();

    if (nome.isEmpty || email.isEmpty || _avaliacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios.')),
      );
      return;
    }

    // ignore: avoid_print
    print(
      'Feedback enviado:\nNome: $nome\nEmail: $email\nAvaliação: $_avaliacao\nComentários: $comentarios',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback enviado com sucesso!')),
    );

    _nomeController.clear();
    _emailController.clear();
    _comentariosController.clear();
    setState(() {
      _avaliacao = null;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _comentariosController.dispose();
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
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Como você avalia nosso serviço?',
              style: TextStyle(fontSize: 16),
            ),
            Column(
              children: [
                RadioListTile<Avaliacao>(
                  title: const Text('Excelente'),
                  value: Avaliacao.excelente,
                  groupValue: _avaliacao,
                  onChanged: (Avaliacao? value) {
                    setState(() {
                      _avaliacao = value;
                    });
                  },
                ),
                RadioListTile<Avaliacao>(
                  title: const Text('Bom'),
                  value: Avaliacao.bom,
                  groupValue: _avaliacao,
                  onChanged: (Avaliacao? value) {
                    setState(() {
                      _avaliacao = value;
                    });
                  },
                ),
                RadioListTile<Avaliacao>(
                  title: const Text('Regular'),
                  value: Avaliacao.regular,
                  groupValue: _avaliacao,
                  onChanged: (Avaliacao? value) {
                    setState(() {
                      _avaliacao = value;
                    });
                  },
                ),
                RadioListTile<Avaliacao>(
                  title: const Text('Ruim'),
                  value: Avaliacao.ruim,
                  groupValue: _avaliacao,
                  onChanged: (Avaliacao? value) {
                    setState(() {
                      _avaliacao = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _comentariosController,
              decoration: const InputDecoration(
                labelText: 'Comentários',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviarFeedback,
              child: const Text('Enviar Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
