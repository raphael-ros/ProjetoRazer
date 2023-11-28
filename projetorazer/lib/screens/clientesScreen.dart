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
                              _excluirCliente(cliente.id);
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
    final response =
        await http.delete(Uri.parse('$baseUrl/excluirCliente/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir cliente na API');
    }
  }

  void _mostrarDialogoIncluirEditarCliente(BuildContext context) {}

  void _mostrarDialogoEditarCliente(BuildContext context, int index) {}

  void _incluirEditarCliente() async {}

  void _limparCampos() {
    // Restante do código...
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
