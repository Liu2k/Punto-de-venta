import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late Box salesBox;

  @override
  void initState() {
    super.initState();
    salesBox = Hive.box('salesBox');
  }

  // Método para agregar una venta
  void _addSale(Venta venta) {
    salesBox.add(venta.toMap()); // Guardar la venta en Hive
    setState(() {}); // Actualizar la UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Fondo del botón
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSalePage(onAddSale: _addSale),
                        ),
                      );
                    },
                    child: Text('Realizar Venta'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Fondo del botón
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text('Lista de Ventas'),
                              backgroundColor: Colors.deepPurple,
                            ),
                            body: ValueListenableBuilder(
                              valueListenable: salesBox.listenable(),
                              builder: (context, Box box, _) {
                                if (box.isEmpty) {
                                  return Center(
                                      child: Text('No hay ventas guardadas'));
                                }

                                return ListView.builder(
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    final saleMap = box.get(index);

                                    if (saleMap is Map) {
                                      final venta = Venta.fromMap(Map<String,
                                          dynamic>.from(saleMap));

                                      return Card(
                                        margin: EdgeInsets.all(8.0),
                                        color: Colors.deepPurple[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 4,
                                        child: ExpansionTile(
                                          title: Text('Venta ID: ${venta.id}'),
                                          subtitle: Text(
                                              'Total: \$${venta.total.toStringAsFixed(2)}'),
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  venta.productos.length,
                                              itemBuilder: (context, i) {
                                                final producto =
                                                    venta.productos[i];
                                                return ListTile(
                                                  title: Text(
                                                      '${producto['nombre']}'),
                                                  subtitle: Text(
                                                    'Cantidad: ${producto['cantidad']} | Precio: \$${producto['precio'].toStringAsFixed(2)}',
                                                  ),
                                                  trailing: Text(
                                                    'Subtotal: \$${(producto['cantidad'] * producto['precio']).toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      box.deleteAt(index);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Venta eliminada'),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        Text('Eliminar Venta'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Total Venta: \$${venta.total.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ListTile(
                                        title: Text('Venta inválida'),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Mostrar Ventas'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSalePage extends StatefulWidget {
  final Function(Venta) onAddSale;

  AddSalePage({required this.onAddSale});

  @override
  _AddSalePageState createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  List<Map<String, dynamic>> _productosVendidos = [];

  void _agregarProducto() {
    String nombre = _productoController.text.trim();
    int cantidad = int.parse(_cantidadController.text.trim());
    double precio = double.parse(_precioController.text.trim());

    if (nombre.isNotEmpty && cantidad > 0 && precio > 0) {
      setState(() {
        _productosVendidos.add({
          'nombre': nombre,
          'cantidad': cantidad,
          'precio': precio
        });
      });

      _productoController.clear();
      _cantidadController.clear();
      _precioController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Los datos del producto son incorrectos')),
      );
    }
  }

  double _calcularTotal() {
    return _productosVendidos.fold(0.0, (total, producto) {
      return total + (producto['cantidad'] * producto['precio']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Venta'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_productoController, 'Producto'),
            _buildTextField(_cantidadController, 'Cantidad', TextInputType.number),
            _buildTextField(_precioController, 'Precio', TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agregarProducto,
              child: Text('Agregar Producto a la Venta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_productosVendidos.isNotEmpty) {
                  double total = _calcularTotal();
                  Venta nuevaVenta = Venta(
                    productos: _productosVendidos,
                    total: total,
                  );

                  widget.onAddSale(nuevaVenta);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Debe agregar al menos un producto')),
                  );
                }
              },
              child: Text('Guardar Venta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class Venta {
  final String id;
  final List<Map<String, dynamic>> productos;
  final double total;

  Venta({required this.productos, required this.total})
      : id = Random().nextInt(100000).toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productos': productos,
      'total': total,
    };
  }

  static Venta fromMap(Map<String, dynamic> map) {
    return Venta(
      productos: List<Map<String, dynamic>>.from(map['productos']),
      total: map['total'],
    );
  }

  @override
  String toString() {
    return 'ID: $id - Total: \$${total.toStringAsFixed(2)}';
  }
}


