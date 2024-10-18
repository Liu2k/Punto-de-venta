import 'package:flutter/material.dart';
import 'clients_page.dart';
import 'CategoriesPage.dart';
import 'products_page.dart';
import 'sales_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Punto de Venta',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.black45,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(
            'Bienvenido a Punto de Venta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              shadows: [
                Shadow(color: Colors.black87, offset: Offset(3, 3), blurRadius: 5),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent.shade100, Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black38, offset: Offset(0, 4), blurRadius: 10),
                  ],
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _createDrawerItem(
                context: context,
                icon: Icons.person,
                text: 'Clientes',
                page: ClientsPage(),
              ),
              _createDrawerItem(
                context: context,
                icon: Icons.store,
                text: 'Categorias',
                page: CategoriesPage(),
              ),
              _createDrawerItem(
                context: context,
                icon: Icons.inventory,
                text: 'Productos',
                page: ProductsPage(),
              ),
              _createDrawerItem(
                context: context,
                icon: Icons.shopping_cart,
                text: 'Ventas',
                page: SalesPage(),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                onTap: () {
                  // Lógica para cerrar sesión
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem({required BuildContext context, required IconData icon, required String text, required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 30), // Icono más grande
      title: Text(
        text,
        // ignore: prefer_const_constructors
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      tileColor: Colors.deepPurpleAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}


