import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import 'os_form_page.dart';
import 'os_detail_page.dart';

class OsListPage extends StatefulWidget {
  final String status; // status recebido da HomePage

  const OsListPage({super.key, required this.status});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
  late Future<List<Order>> _orders;

  Future<List<Order>> _loadOrders() async {
    // Busca direto no banco apenas as OS com o status desejado
    final data = await DatabaseHelper.instance.queryByStatus(widget.status);
    return data.map((e) => Order.fromMap(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _orders = _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // fundo cinza claro
      appBar: AppBar(
        title: Text(widget.status),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Nenhuma OS cadastrada'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OsFormPage()),
                      );
                      setState(() => _orders = _loadOrders());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Criar nova OS"),
                  ),
                ],
              ),
            );
          }

          final orders = snap.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final o = orders[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(o.clientName),
                  subtitle: Text('${o.status} • ${o.description}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OsDetailPage(order: o),
                      ),
                    );
                    setState(() => _orders = _loadOrders());
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OsFormPage()),
          );
          setState(() => _orders = _loadOrders());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}