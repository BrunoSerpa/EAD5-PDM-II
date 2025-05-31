import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuários',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(secondary: Colors.orangeAccent),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
      ),
      home: const paginaInicial(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class paginaInicial extends StatefulWidget {
  const paginaInicial({super.key});

  @override
  State<paginaInicial> createState() => _paginaInicialEstado();
}

class _paginaInicialEstado extends State<paginaInicial> {
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _chaveFormulario = GlobalKey<FormState>();

  List<Map<String, String>> _listaUsuariosCadastrados = [];
  final String _nomeArquivo = 'dados_usuarios.json';

  @override
  void initState() {
    super.initState();
    _carregarUsuariosDoArquivo();
  }

  Future<String> _obterCaminhoDiretorioDocumentos() async {
    String caminhoDiretorio;
    if (Platform.isLinux) {
      final String? diretorioHome = Platform.environment['HOME'];
      if (diretorioHome != null && diretorioHome.isNotEmpty) {
        String caminhoDocumentosPtBr = p.join(diretorioHome, 'Documentos');
        Directory dirPtBr = Directory(caminhoDocumentosPtBr);
        if (await dirPtBr.exists() ||
            Platform.localeName.toLowerCase().startsWith('pt_br')) {
          caminhoDiretorio = caminhoDocumentosPtBr;
        } else {
          String caminhoDocumentsEn = p.join(diretorioHome, 'Documents');
          Directory dirEn = Directory(caminhoDocumentsEn);
          if (await dirEn.exists()) {
            caminhoDiretorio = caminhoDocumentsEn;
          } else {
            caminhoDiretorio = caminhoDocumentosPtBr;
          }
        }
      } else {
        final Directory diretorioDocsApp =
            await getApplicationDocumentsDirectory();
        caminhoDiretorio = diretorioDocsApp.path;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Diretório HOME não encontrado. Usando ${diretorioDocsApp.path}',
              ),
            ),
          );
        }
      }
    } else {
      final Directory diretorioDocsApp =
          await getApplicationDocumentsDirectory();
      caminhoDiretorio = diretorioDocsApp.path;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Plataforma não é Linux. Salvando em ${diretorioDocsApp.path}',
            ),
          ),
        );
      }
    }
    final Directory dir = Directory(caminhoDiretorio);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return caminhoDiretorio;
  }

  Future<File> _obterArquivoLocal() async {
    final caminhoDiretorio = await _obterCaminhoDiretorioDocumentos();
    return File(p.join(caminhoDiretorio, _nomeArquivo));
  }

  Future<void> _persistirListaUsuarios(List<Map<String, String>> lista) async {
    final arquivo = await _obterArquivoLocal();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String dadosJson = encoder.convert(lista);
    await arquivo.writeAsString(dadosJson);
  }

  Future<void> _carregarUsuariosDoArquivo() async {
    try {
      final arquivo = await _obterArquivoLocal();
      if (await arquivo.exists()) {
        final String conteudoExistente = await arquivo.readAsString();
        if (conteudoExistente.isNotEmpty) {
          final List<dynamic> dadosDecodificados = jsonDecode(
            conteudoExistente,
          );
          setState(() {
            _listaUsuariosCadastrados = dadosDecodificados
                .map((item) => Map<String, String>.from(item as Map))
                .toList();
          });
        } else {
          setState(() {
            _listaUsuariosCadastrados = [];
          });
        }
      } else {
        setState(() {
          _listaUsuariosCadastrados = [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao carregar dados: $e. Iniciando com lista vazia.',
            ),
          ),
        );
      }
      setState(() {
        _listaUsuariosCadastrados = [];
      });
    }
  }

  Future<void> _adicionarUsuario() async {
    if (!_chaveFormulario.currentState!.validate()) {
      return;
    }
    final String nome = _controladorNome.text;
    final String email = _controladorEmail.text;
    final Map<String, String> novoDado = {'nome': nome, 'email': email};

    final listaTemporaria = List<Map<String, String>>.from(
      _listaUsuariosCadastrados,
    );
    listaTemporaria.add(novoDado);

    try {
      await _persistirListaUsuarios(listaTemporaria);
      setState(() {
        _listaUsuariosCadastrados = listaTemporaria;
      });
      _controladorNome.clear();
      _controladorEmail.clear();
      FocusScope.of(context).unfocus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário "${novoDado['nome']}" adicionado!')),
        );
      }
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar usuário: $erro')),
        );
      }
    }
  }

  Future<void> _excluirUsuario(int index) async {
    final usuarioParaExcluir = _listaUsuariosCadastrados[index];
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
            'Tem certeza que deseja excluir o usuário "${usuarioParaExcluir['nome']}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      final listaTemporaria = List<Map<String, String>>.from(
        _listaUsuariosCadastrados,
      );
      listaTemporaria.removeAt(index);
      try {
        await _persistirListaUsuarios(listaTemporaria);
        setState(() {
          _listaUsuariosCadastrados = listaTemporaria;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Usuário "${usuarioParaExcluir['nome']}" excluído.',
              ),
            ),
          );
        }
      } catch (erro) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir usuário: $erro')),
          );
        }
      }
    }
  }
  Future<void> _atualizarUsuario(int index) async {
    final usuarioAtual = _listaUsuariosCadastrados[index];
    final TextEditingController nomeController = TextEditingController(
      text: usuarioAtual['nome'],
    );
    final TextEditingController emailController = TextEditingController(
      text: usuarioAtual['email'],
    );
    final bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualizar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Atualizar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      final String novoNome = nomeController.text;
      final String novoEmail = emailController.text;
      final Map<String, String> usuarioAtualizado = {
        'nome': novoNome,
        'email': novoEmail,
      };
      final listaTemporaria = List<Map<String, String>>.from(
        _listaUsuariosCadastrados,
      );
      listaTemporaria[index] = usuarioAtualizado;

      try {
        await _persistirListaUsuarios(listaTemporaria);

        setState(() {
          _listaUsuariosCadastrados = listaTemporaria;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário atualizado com sucesso!')),
        );
      } catch (erro) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário: $erro')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuários'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Color.fromARGB(255, 37, 51, 132),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 3.0,
              margin: const EdgeInsets.only(bottom: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _chaveFormulario,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Novo Usuário',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blueGrey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controladorNome,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Informe seu nome.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controladorEmail,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Informe seu email.';
                          }
                          if (!valor.contains('@') || !valor.contains('.')) {
                            return 'Informe um email válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _adicionarUsuario,
                        child: const Text('Adicionar Usuário'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Usuários Cadastrados:',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _listaUsuariosCadastrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.people_outline,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum usuário cadastrado ainda.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listaUsuariosCadastrados.length,
                      itemBuilder: (context, index) {
                        final usuario = _listaUsuariosCadastrados[index];
                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Colors.white,
                              child: Text(
                                usuario['nome']!.isNotEmpty
                                    ? usuario['nome']![0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(
                              usuario['nome'] ?? 'Nome não disponível',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              usuario['email'] ?? 'Email não disponível',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueGrey[800],
                                  ),
                                  tooltip: 'Editar ${usuario['nome']}',
                                  onPressed: () {
                                    _atualizarUsuario(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red[700],
                                  ),
                                  tooltip: 'Excluir ${usuario['nome']}',
                                  onPressed: () {
                                    _excluirUsuario(index);
                                  },
                                ),
                              ],
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
