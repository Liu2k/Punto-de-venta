//import 'products_page.dart';

class Venta {
  final List<Map<String, dynamic>> productos; // Cada producto tiene un nombre, cantidad y precio
  final double total;

  Venta({required this.productos, required this.total});

  @override
  String toString() {
    String productosStr = productos.map((producto) {
      return '${producto['nombre']} x${producto['cantidad']} - \$${producto['precio']}';
    }).join(', ');
    return 'Venta: $productosStr | Total: \$${total.toStringAsFixed(2)}';
  }
}
