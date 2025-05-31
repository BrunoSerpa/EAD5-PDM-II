import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferências',
      debugShowCheckedModeBanner: false,
      home: const ConfiguracoesPreferencia(),
    );
  }
}

enum Tema { claro, escuro }

enum Idioma { portugues, ingles, espanhol }

class ConfiguracoesPreferencia extends StatefulWidget {
  const ConfiguracoesPreferencia({super.key});

  @override
  State<ConfiguracoesPreferencia> createState() =>
      _ConfiguracoesPreferenciaState();
}

class _ConfiguracoesPreferenciaState extends State<ConfiguracoesPreferencia> {
  Tema _temaSelecionado = Tema.claro;
  Idioma _idiomaSelecionado = Idioma.portugues;
  final TextEditingController _usernameController = TextEditingController();

  final Map<Idioma, Map<String, String>> _localizedTexts = {
    Idioma.portugues: {
      'title': 'Configurações de Preferência',
      'selecioneTema': 'Selecione o Tema:',
      'claro': 'Claro',
      'escuro': 'Escuro',
      'selecioneIdioma': 'Selecione o Idioma:',
      'portugues': 'Português',
      'ingles': 'Inglês',
      'espanhol': 'Espanhol',
      'nomeUsuario': 'Nome de Usuário',
    },
    Idioma.ingles: {
      'title': 'Preference Settings',
      'selecioneTema': 'Select Theme:',
      'claro': 'Light',
      'escuro': 'Dark',
      'selecioneIdioma': 'Select Language:',
      'portugues': 'Portuguese',
      'ingles': 'English',
      'espanhol': 'Spanish',
      'nomeUsuario': 'Username',
    },
    Idioma.espanhol: {
      'title': 'Configuración de Preferencias',
      'selecioneTema': 'Seleccione el Tema:',
      'claro': 'Claro',
      'escuro': 'Oscuro',
      'selecioneIdioma': 'Seleccione el Idioma:',
      'portugues': 'Portugués',
      'ingles': 'Inglés',
      'espanhol': 'Español',
      'nomeUsuario': 'Nombre de usuario',
    },
  };

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = _localizedTexts[_idiomaSelecionado]!;

    final Color backgroundColor =
        _temaSelecionado == Tema.claro ? Colors.white : Colors.black87;
    final Color primaryColor =
        _temaSelecionado == Tema.claro ? Colors.blue : Colors.deepPurple;
    final Color textColor =
        _temaSelecionado == Tema.claro ? Colors.black : Colors.white;
    final String username = _usernameController.text.trim();
    final String appBarTitle;
    if (username.isNotEmpty) {
      switch (_idiomaSelecionado) {
        case Idioma.portugues:
          appBarTitle = 'Configurações do usuário $username';
          break;
        case Idioma.ingles:
          appBarTitle = "User Settings: $username";
          break;
        case Idioma.espanhol:
          appBarTitle = 'Configuraciones del usuario $username';
          break;
      }
    } else {
      appBarTitle = texts['title']!;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(appBarTitle), backgroundColor: primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(color: textColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts['selecioneTema']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RadioListTile<Tema>(
                title: Text(
                  texts['claro']!,
                  style: TextStyle(color: textColor),
                ),
                value: Tema.claro,
                groupValue: _temaSelecionado,
                activeColor: primaryColor,
                onChanged: (Tema? value) {
                  setState(() {
                    _temaSelecionado = value!;
                  });
                },
              ),
              RadioListTile<Tema>(
                title: Text(
                  texts['escuro']!,
                  style: TextStyle(color: textColor),
                ),
                value: Tema.escuro,
                groupValue: _temaSelecionado,
                activeColor: primaryColor,
                onChanged: (Tema? value) {
                  setState(() {
                    _temaSelecionado = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                texts['selecioneIdioma']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RadioListTile<Idioma>(
                title: Text(
                  texts['portugues']!,
                  style: TextStyle(color: textColor),
                ),
                value: Idioma.portugues,
                groupValue: _idiomaSelecionado,
                activeColor: primaryColor,
                onChanged: (Idioma? value) {
                  setState(() {
                    _idiomaSelecionado = value!;
                  });
                },
              ),
              RadioListTile<Idioma>(
                title: Text(
                  texts['ingles']!,
                  style: TextStyle(color: textColor),
                ),
                value: Idioma.ingles,
                groupValue: _idiomaSelecionado,
                activeColor: primaryColor,
                onChanged: (Idioma? value) {
                  setState(() {
                    _idiomaSelecionado = value!;
                  });
                },
              ),
              RadioListTile<Idioma>(
                title: Text(
                  texts['espanhol']!,
                  style: TextStyle(color: textColor),
                ),
                value: Idioma.espanhol,
                groupValue: _idiomaSelecionado,
                activeColor: primaryColor,
                onChanged: (Idioma? value) {
                  setState(() {
                    _idiomaSelecionado = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: texts['nomeUsuario']!,
                  labelStyle: TextStyle(color: textColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
