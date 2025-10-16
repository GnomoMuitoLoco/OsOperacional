import 'package:flutter/material.dart';
import 'os_list_page.dart'; // importa a tela de listagem

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // fundo cinza claro
      appBar: AppBar(
        title: const Text(
          'Ordens de Serviço',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // fundo azul
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuButton(
              context,
              label: "Em Andamento",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OsListPage(status: "Em Andamento"),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              label: "Concluídas",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OsListPage(status: "Concluída"),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              label: "Reportadas",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OsListPage(status: "Reportada"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Botão estilizado moderno
  Widget _buildMenuButton(
      BuildContext context, {
        required String label,
        required VoidCallback onTap,
      }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // fundo azul
        foregroundColor: Colors.white, // texto branco
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 3,
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}