import 'package:flutter/material.dart';
import '../models/classProduto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key});

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> produtos = [];
  final String baseUrl = 'http://infopguaifpr.com.br:3052';
  TextEditingController descricaoController = TextEditingController();
  bool isEditing = false;
  int editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
    print('Produtos: $produtos');
  }

  // Função para carregar produtos da API
  Future<void> _carregarProdutos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produtos'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> produtosData =
            data['produtos']; // Acessar a lista de produtos

        setState(() {
          produtos =
              produtosData.map((json) => Produto.fromJson(json)).toList();
        });
      } else {
        print('Erro ao carregar produtos da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  // Função para exibir diálogo de inclusão/editação de produto
  Future<void> _mostrarDialogoIncluirEditarProduto(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Produto' : 'Adicionar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _limparCampos();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                isEditing ? await _editarProduto() : await _adicionarProduto();
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função para adicionar novo produto
  Future<void> _adicionarProduto() async {
    try {
      final novaDescricao = descricaoController.text;
      if (novaDescricao.isNotEmpty) {
        final novoProduto = Produto(id: 0, descricao: novaDescricao);
        final response = await http.post(
          Uri.parse('$baseUrl/incluirProduto'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(novoProduto.toJson()),
        );

        if (response.statusCode == 201) {
          _carregarProdutos();
          _mostrarSnackBar('Produto adicionado com sucesso');
        } else {
          print('Erro ao adicionar produto: ${response.statusCode}');
        }
      } else {
        _mostrarSnackBar('Por favor, preencha a descrição do produto.');
      }
    } catch (e) {
      print('Erro ao adicionar produto: $e');
    }
  }

  // Função para editar produto existente
  Future<void> _editarProduto() async {
    try {
      final novaDescricao = descricaoController.text;
      if (novaDescricao.isNotEmpty) {
        final produtoEditado =
            Produto(id: produtos[editingIndex].id, descricao: novaDescricao);
        final response = await http.put(
          Uri.parse('$baseUrl/atualizarProduto/${produtoEditado.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(produtoEditado.toJson()),
        );

        if (response.statusCode == 200) {
          _carregarProdutos();
          _mostrarSnackBar('Produto editado com sucesso');
        } else {
          print('Erro ao editar produto: ${response.statusCode}');
        }
      } else {
        _mostrarSnackBar('Por favor, preencha a descrição do produto.');
      }
    } catch (e) {
      print('Erro ao editar produto: $e');
    }
  }

  // Função para exibir diálogo de confirmação de exclusão de produto
  Future<void> _confirmarExclusaoProduto(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Tem certeza que deseja excluir este produto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _excluirProduto(id);
                Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  // Função para excluir produto
  Future<void> _excluirProduto(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/excluirProduto/$id'));
      if (response.statusCode == 204) {
        _carregarProdutos();
        _mostrarSnackBar('Produto excluído com sucesso');
      } else {
        print('Erro ao excluir produto: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao excluir produto: $e');
    }
  }

  // Função para exibir Snackbar na parte inferior da tela
  void _mostrarSnackBar(String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Função para limpar campos e variáveis de edição
  void _limparCampos() {
    descricaoController.clear();
    isEditing = false;
    editingIndex = -1;
  }

  // Construção da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: produtos.isEmpty
          ? Center(child: Text('Nenhum produto encontrado.'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(produto.descricao),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          descricaoController.text = produto.descricao;
                          setState(() {
                            isEditing = true;
                            editingIndex = index;
                          });
                          _mostrarDialogoIncluirEditarProduto(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmarExclusaoProduto(produto.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirEditarProduto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
