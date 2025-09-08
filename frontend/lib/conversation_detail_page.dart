// lib/conversation_detail_page.dart

import 'package:flutter/material.dart';

class ConversationDetailPage extends StatelessWidget {
  // Esta variable almacenará los datos del usuario que recibamos de la pantalla principal
  final Map<String, dynamic> user;

  // El constructor requiere que se le pasen los datos del usuario
  const ConversationDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Extraemos el historial de conversaciones de los datos del usuario
    // Si no existe, usamos una lista vacía para evitar errores
    final List<dynamic> history = user['conversationHistory'] ?? [];
    final String userName = user['business_name'] ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        // El título de la pantalla será el nombre del negocio del usuario
        title: Text(userName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        // El número de elementos en la lista es la cantidad de mensajes en el historial
        itemCount: history.length,
        itemBuilder: (context, index) {
          final message = history[index];
          final bool isUserMessage = message['sender'] == 'user';

          // Usamos un Align para poner los mensajes del 'user' a la derecha
          // y los del 'bot' a la izquierda, como en un chat normal.
          return Align(
            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Card(
              color: isUserMessage ? Colors.blue[600] : Colors.grey[800],
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  message['message'] ?? 'Mensaje no disponible',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}