import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_page.dart'; // Asegúrate de que esta sea la ruta correcta

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter esté completamente inicializado

  // Inicializa Hive
  await Hive.initFlutter();

  // Abre las cajas donde se almacenarán los datos
  await Hive.openBox('puntoDeVentaBox'); // Caja principal
  await Hive.openBox('clientsBox'); // Caja para los clientes
  await Hive.openBox('categoriesBox'); // Caja para las categorias
  await Hive.openBox('salesBox'); // Caja para las ventas
  await Hive.openBox('productsBox'); // Caja para los productos
  

  runApp(MyApp()); // Ejecuta la aplicación
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Página de inicio de la aplicación
      debugShowCheckedModeBanner:false
    );
  }
}
