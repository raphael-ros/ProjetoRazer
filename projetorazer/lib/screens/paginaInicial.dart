import 'package:flutter/material.dart';
import 'package:projetorazer/models/dashboardInfo.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardInfo dashboardInfo;

  const DashboardScreen({Key? key, required this.dashboardInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyures Topzera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações do Aplicativo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Nome do App: ${dashboardInfo.nomeApp}'),
            SizedBox(height: 16),
            Text(
              'Estatísticas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Número de Vendas: ${dashboardInfo.numeroVendas}'),
            Text('Número de Clientes: ${dashboardInfo.numeroClientes}'),
          ],
        ),
      ),
    );
  }
}
