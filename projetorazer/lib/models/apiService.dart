import 'package:http/http.dart' as http;
import 'package:projetorazer/models/classProduto.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl;
  final apiService = ApiService('http://localhost:3000');

  ApiService(this.baseUrl);

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar produtos da API');
    }
  }

  Future<void> criarProduto(Produto novoProduto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(novoProduto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar produto na API');
    }
  }

  Future<void> editarProduto(int id, Produto produtoEditado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produtoEditado.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar produto na API');
    }
  }

  Future<void> excluirProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produtos/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir produto na API');
    }
  }
}
