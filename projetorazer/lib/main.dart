import 'package:flutter/material.dart';
import 'models/classCliente.dart';
import 'package:projetorazer/widgets/drawer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projetorazer/screens/produtosScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  static const appTitle = 'Projeto Razer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Valores fictícios
    int totalClientes = 150;
    int totalVendas = 300;
    int totalProdutos = 75;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardCard(
            title: 'Clientes',
            description: 'Total de clientes cadastrados',
            count: totalClientes,
            onPressed: () {
              // Implemente a navegação para a tela de clientes aqui.
            },
          ),
          DashboardCard(
            title: 'Vendas',
            description: 'Total de vendas realizadas',
            count: totalVendas,
            onPressed: () {
              // Implemente a navegação para a tela de vendas aqui.
            },
          ),
          DashboardCard(
            title: 'Produtos',
            description: 'Total de produtos disponíveis',
            count: totalProdutos,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdutosScreen()),
              );
            },
          ),
          // Adicionando um gráfico de barras
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final int count;
  final VoidCallback onPressed;

  const DashboardCard({
    required this.title,
    required this.description,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Total: $count',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
