import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Box categoriesBox;

  @override
  void initState() {
    super.initState();
    categoriesBox = Hive.box('categoriesBox'); // Caja donde se almacenan las categorías
  }

  // Método para agregar una categoría
  void _addCategory(String categoryName) {
    categoriesBox.add(categoryName);
    setState(() {}); // Refresca la UI para reflejar los cambios
  }

  // Método para eliminar una categoría
  void _deleteCategory(int index) {
    categoriesBox.deleteAt(index);
    setState(() {}); // Refresca la UI para reflejar los cambios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navega a la pantalla para agregar una categoría
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategoryPage(onAddCategory: _addCategory),
                  ),
                );
              },
              child: Text('Agregar Categoría'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navega a la pantalla que muestra las categorías
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowCategoriesPage(
                      categoriesBox: categoriesBox,
                      onDeleteCategory: _deleteCategory,
                    ),
                  ),
                );
              },
              child: Text('Mostrar Categorías'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCategoryPage extends StatefulWidget {
  final Function(String) onAddCategory;

  AddCategoryPage({required this.onAddCategory});

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Categoría'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onAddCategory(_controller.text); // Agrega la categoría
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: Text('Guardar Categoría'),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowCategoriesPage extends StatelessWidget {
  final Box categoriesBox;
  final Function(int) onDeleteCategory;

  ShowCategoriesPage({required this.categoriesBox, required this.onDeleteCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Categorías'),
      ),
      body: ValueListenableBuilder(
        valueListenable: categoriesBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No hay categorías guardadas'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(box.get(index)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Método para mostrar un cuadro de diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                onDeleteCategory(index); // Elimina la categoría
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
