import 'package:flutter/material.dart';
import 'ex1.dart';
import 'ex2.dart';
import 'ex3.dart';
import 'ex4.dart';
import 'ex5.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Exercícios 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExerciciosHome(),
    );
  }
}

class ExerciciosHome extends StatelessWidget {
  const ExerciciosHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Exercícios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _ExercicioButton(
              title: 'Lista de Compras',
              image: 'https://cdn-icons-png.flaticon.com/512/1011/1011286.png',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const ListaCompras(title: 'Lista de Compras'),
                    ),
                  ),
            ),
            _ExercicioButton(
              title: 'Tarefas Diárias',
              image: 'https://cdn-icons-png.flaticon.com/512/5058/5058507.png',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const TarefasDiarias(title: 'Tarefas Diárias'),
                    ),
                  ),
            ),
            _ExercicioButton(
              title: 'Notas Rápidas',
              image: 'https://cdn-icons-png.flaticon.com/512/82/82071.png',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const NotasRapidas(title: 'Notas Rápidas'),
                    ),
                  ),
            ),
            _ExercicioButton(
              title: 'Feedback',
              image: 'https://cdn-icons-png.flaticon.com/512/813/813395.png',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const FormularioFeedback(title: 'Feedback'),
                    ),
                  ),
            ),
            _ExercicioButton(
              title: 'Preferências',
              image: 'https://cdn-icons-png.flaticon.com/512/4561/4561705.png',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfiguracoesPreferencia(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercicioButton extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _ExercicioButton({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  _ExercicioButtonState createState() => _ExercicioButtonState();
}

class _ExercicioButtonState extends State<_ExercicioButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get _backgroundColor {
    if (_isPressed) {
      return Colors.grey[500]!;
    } else if (_isHovered) {
      return Colors.grey[300]!;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit:
          (_) => setState(() {
            _isHovered = false;
            _isPressed = false;
          }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.image, width: 50, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
