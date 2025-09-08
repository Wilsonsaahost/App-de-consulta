// lib/main.dart
import 'conversation_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ¡¡¡IMPORTANTE!!! Reemplaza esto con TU URL REAL de Render
const String apiUrl = "https://app-de-consulta.onrender.com/api/users";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta DB',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    fetchItems(); // Carga los datos iniciales
  }

  Future<void> fetchItems({String busqueda = ''}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      String requestUrl = apiUrl;
      if (busqueda.isNotEmpty) {
        requestUrl = '$apiUrl?busqueda=$busqueda';
      }

      final Uri uri = Uri.parse(requestUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          _items = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Fallo al cargar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'No se pudo conectar al servidor: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre de negocio...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    fetchItems(busqueda: _searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) => fetchItems(busqueda: value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                      : _items.isEmpty
                          ? const Center(child: Text('No se encontraron resultados.'))
                          : RefreshIndicator(
                            onRefresh: () => fetchItems(),
                            child: ListView.builder(
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                 // ... dentro del ListView.builder en main.dart

return Card(
  margin: const EdgeInsets.symmetric(vertical: 4.0),
  child: ListTile(
    title: Text(item['business_name'] ?? 'Sin nombre de negocio'),
    subtitle: Text(item['whatsapp_number'] ?? 'Sin número'),
    trailing: const Icon(Icons.person),

    // --- AÑADE ESTO ---
    onTap: () {
      // Esto es lo que sucede cuando tocas un usuario
      Navigator.push(
        context,
        MaterialPageRoute(
          // Le decimos que vaya a nuestra nueva pantalla y le pasamos los datos del 'item'
          builder: (context) => ConversationDetailPage(user: item),
        ),
      );
    },
    // ------------------
  ),
);

// ...
                                },
                              ),
                          ),
            ),
          ],
        ),
      ),
    );
  }
}
