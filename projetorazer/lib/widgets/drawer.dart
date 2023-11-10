import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Vendinha do Razer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Página Inicial',
            onTap: () {
              // Implemente a navegação para a página inicial aqui.
            },
          ),
          _createDrawerItem(
            icon: Icons.people,
            text: 'Clientes',
            onTap: () {
              // Implemente a navegação para a tela de clientes aqui.
            },
          ),
          _createDrawerItem(
            icon: Icons.shopping_cart,
            text: 'Produtos',
            onTap: () {
              // Implemente a navegação para a tela de produtos aqui.
            },
          ),
          _createDrawerItem(
            icon: Icons.attach_money,
            text: 'Vendas',
            onTap: () {
              // Implemente a navegação para a tela de vendas aqui.
            },
          ),
          // Adicione mais itens de menu conforme necessário.
        ],
      ),
    );
  }
}
