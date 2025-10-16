import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import '../db/database_helper.dart';
import '../models/order.dart';

class OsDetailPage extends StatefulWidget {
  final Order order;
  const OsDetailPage({super.key, required this.order});

  @override
  State<OsDetailPage> createState() => _OsDetailPageState();
}

class _OsDetailPageState extends State<OsDetailPage> {
  bool _signMode = false;
  final _clientNameCtrl = TextEditingController();

  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _clientNameCtrl.text = widget.order.clientName;
  }

  @override
  void dispose() {
    _clientNameCtrl.dispose();
    _sigController.dispose();
    super.dispose();
  }

  Future<void> _saveSignature(String clientName, String newStatus) async {
    if (_sigController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assinatura vazia')),
      );
      return;
    }

    final Uint8List? data = await _sigController.toPngBytes();
    if (data == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/signature_${widget.order.id}.png');
    await file.writeAsBytes(data);

    // Atualiza a OS no banco
    final updated = widget.order
      ..signaturePath = file.path
      ..clientName = clientName
      ..status = newStatus;

    await DatabaseHelper.instance.update(
      'orders',
      updated.toMap(),
      updated.id!,
    );

    setState(() {
      _signMode = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OS marcada como $newStatus')),
    );

    Navigator.pop(context, true); // volta para lista e recarrega
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Detalhe da OS'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(title: Text('Cliente: ${order.clientName}')),
          ),
          Card(
            child: ListTile(title: Text('Status: ${order.status}')),
          ),
          Card(
            child: ListTile(title: Text('Descrição: ${order.description}')),
          ),
          if (order.materials.isNotEmpty)
            Card(
              child: ListTile(
                title: const Text('Materiais usados'),
                subtitle: Text(order.materials.join(', ')),
              ),
            ),
          if (order.photos.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fotos:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: order.photos.map((p) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.file(
                          File(p['path']!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        if (p['caption'] != null && p['caption']!.isNotEmpty)
                          Text(p['caption']!, style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Mostra assinatura já existente
          if (order.signaturePath != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Assinatura do cliente:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Image.file(File(order.signaturePath!), height: 150),
                const SizedBox(height: 16),
              ],
            ),

          if (!_signMode)
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _signMode = true),
                  icon: const Icon(Icons.border_color),
                  label: const Text('Coletar assinatura'),
                ),
              ],
            ),

          if (_signMode)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _clientNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome digitado pelo cliente',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Signature(
                    controller: _sigController,
                    backgroundColor: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _sigController.clear(),
                      child: const Text('Limpar'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_clientNameCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Digite o nome do cliente')),
                          );
                          return;
                        }
                        _saveSignature(_clientNameCtrl.text.trim(), "Concluída");
                      },
                      child: const Text('Finalizar como Concluída'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (_clientNameCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Digite o nome do cliente')),
                      );
                      return;
                    }
                    _saveSignature(_clientNameCtrl.text.trim(), "Reportada");
                  },
                  child: const Text('Finalizar como Reportada'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}