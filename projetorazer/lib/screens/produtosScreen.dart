import 'package:flutter/material.dart';
import '../models/classProduto.dart';
import '../models/apiService.dart'; // Import ApiService

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key});

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> produtos = [];
  final ApiService apiService = ApiService('URL_DA_SUA_API');

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final produtos = await apiService.fetchProdutos();
      setState(() {
        this.produtos = produtos;
      });
    } catch (e) {
      // Handle error
      print('Erro ao carregar produtos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return ListTile(
            title: Text(produto.descricao),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _excluirProduto(produto.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirProduto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogoIncluirProduto(BuildContext context) async {
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incluir Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                final descricao = descricaoController.text;

                if (descricao.isNotEmpty) {
                  try {
                    final novoProduto = Produto(
                      id: DateTime.now().millisecondsSinceEpoch,
                      descricao: descricao,
                    );
                    await apiService.criarProduto(novoProduto);
                    _carregarProdutos(); // Atualiza a lista após a inclusão
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Handle error
                    print('Erro ao criar produto: $e');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Por favor, preencha a descrição do produto.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirProduto(int id) async {
    try {
      await apiService.excluirProduto(id);
      _carregarProdutos(); // Atualiza a lista após a exclusão
    } catch (e) {
      // Handle error
      print('Erro ao excluir produto: $e');
    }
  }
}
