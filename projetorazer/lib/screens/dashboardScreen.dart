import 'package:flutter/material.dart';
import 'package:projetorazer/screens/produtosScreen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem-vindo à Dashboard!',
            style: TextStyle(fontSize: 24),
          ),
          // Adicione aqui os elementos da Dashboard, como estatísticas, gráficos, etc.
        ],
      ),
    );
  }
}
