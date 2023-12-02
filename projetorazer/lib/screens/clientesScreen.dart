import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorazer/models/classCliente.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key});

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> clientes = [];

  // Controller para os campos de edição
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobrenomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  // Variável para rastrear se estamos adicionando ou editando
  bool isEditing = false;
  int editingIndex = -1;

  final String baseUrl =
      'http://localhost:3000'; // Ajuste a URL conforme necessário

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: clientes == null
          ? Center(child: CircularProgressIndicator())
          : clientes.isEmpty
              ? Center(child: Text('Nenhum cliente encontrado.'))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ListTile(
                      title: Text('${cliente.nome} ${cliente.sobrenome}'),
                      subtitle: Text('CPF: ${cliente.cpf}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _mostrarDialogoEditarCliente(context, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmarExclusaoCliente(cliente
                                  .id); // Chamar o método de confirmaçãor
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirEditarCliente(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Cliente>> _listarClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['clientes'];
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar clientes da API');
    }
  }

  Future<void> _incluirCliente(Cliente novoCliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/incluirCliente'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(novoCliente.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar cliente na API');
    }
  }

  Future<void> _editarCliente(int id, Cliente clienteEditado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/atualizarCliente/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(clienteEditado.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar cliente na API');
    }
  }

  Future<Cliente> _getClienteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/clientes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Cliente.fromJson(data);
    } else {
      throw Exception('Erro ao carregar cliente da API');
    }
  }

  Future<void> _excluirCliente(int id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/excluirCliente/$id'));

      // Se a exclusão for bem-sucedida, mostrar mensagem de confirmação
      _mostrarSnackBar('Cliente excluído com sucesso');

      // Recarregar lista de clientes após a exclusão
      _carregarClientes();
    } catch (e) {
      print('Erro ao excluir cliente: $e');
      // Tratar erro, se necessário
    }
  }

  Future<void> _confirmarExclusaoCliente(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Tem certeza que deseja excluir esse cliente?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _excluirCliente(id);
                Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoIncluirEditarCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incluir Cliente'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: sobrenomeController,
                  decoration: InputDecoration(labelText: 'Sobrenome'),
                ),
                TextField(
                  controller: cpfController,
                  decoration: InputDecoration(labelText: 'CPF'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Chamar a função para incluir o cliente
                _incluirEditarCliente();
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEditarCliente(BuildContext context, int index) {
    // Preencher os controladores com os detalhes do cliente selecionado
    nomeController.text = clientes[index].nome;
    sobrenomeController.text = clientes[index].sobrenome;
    cpfController.text = clientes[index].cpf;

    // Configurar variáveis de edição
    isEditing = true;
    editingIndex = index;

    // Mostrar o diálogo de inclusão/editação
    _mostrarDialogoIncluirEditarCliente(context);
  }

  void _incluirEditarCliente() async {
    // Criar um novo cliente com os dados dos controladores
    Cliente novoCliente = Cliente(
      id: isEditing
          ? clientes[editingIndex].id
          : 0, // Se estiver editando, use o ID existente, caso contrário, use 0 ou um valor padrão
      nome: nomeController.text,
      sobrenome: sobrenomeController.text,
      cpf: cpfController.text,
    );

    if (isEditing) {
      // Se estiver editando, chamar a função de editar com o ID correto
      await _editarCliente(clientes[editingIndex].id, novoCliente);
    } else {
      // Se não estiver editando, chamar a função de incluir
      await _incluirCliente(novoCliente);
    }

    // Limpar campos e recarregar lista de clientes
    _limparCampos();
    _carregarClientes();
  }

  void _mostrarSnackBar(String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _limparCampos() {
    nomeController.clear();
    sobrenomeController.clear();
    cpfController.clear();

    // Resetar variáveis de edição
    isEditing = false;
    editingIndex = -1;
  }

  void _carregarClientes() async {
    try {
      final listaClientes = await _listarClientes();
      setState(() {
        clientes = listaClientes;
      });
    } catch (e) {
      print('Erro ao carregar clientes: $e');
    }
  }
}
