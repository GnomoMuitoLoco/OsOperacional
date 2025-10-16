import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../db/database_helper.dart';
import '../models/order.dart';

class OsFormPage extends StatefulWidget {
  const OsFormPage({super.key});

  @override
  State<OsFormPage> createState() => _OsFormPageState();
}

class _OsFormPageState extends State<OsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<String> _materials = [];
  final List<Map<String, String>> _photos = [];

  @override
  void dispose() {
    _clientCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_photos.length >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite de 100 fotos atingido')),
      );
      return;
    }
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera);
    if (xfile == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final newPath = p.join(dir.path, p.basename(xfile.path));
    await File(xfile.path).copy(newPath);

    setState(() {
      _photos.add({'path': newPath, 'caption': ''});
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final order = Order(
      clientName: _clientCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: 'Em Andamento', // sempre inicia em andamento
      materials: _materials,
      photos: _photos,
      signaturePath: null,
      createdAt: DateTime.now(),
    );

    await DatabaseHelper.instance.insert('orders', order.toMap());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OS criada com sucesso!')),
    );
    Navigator.pop(context, true); // retorna true para recarregar lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Nova OS'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _clientCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome do cliente',
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (v) =>
              v == null || v.isEmpty ? 'Informe o cliente' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
              validator: (v) =>
              v == null || v.isEmpty ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Material (Enter para adicionar)',
                filled: true,
                fillColor: Colors.white,
              ),
              onFieldSubmitted: (v) {
                if (v.trim().isEmpty) return;
                setState(() => _materials.add(v.trim()));
              },
            ),
            Wrap(
              spacing: 8,
              children: _materials
                  .map(
                    (m) => Chip(
                  label: Text(m),
                  onDeleted: () => setState(() => _materials.remove(m)),
                ),
              )
                  .toList(),
            ),
            const Divider(),
            Row(
              children: [
                const Text('Fotos'),
                const Spacer(),
                IconButton(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            ..._photos.asMap().entries.map((e) {
              final i = e.key;
              final p = e.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Image.file(
                    File(p['path']!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                  title: TextFormField(
                    initialValue: p['caption'],
                    decoration: const InputDecoration(labelText: 'Legenda'),
                    onChanged: (v) => _photos[i]['caption'] = v,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => _photos.removeAt(i)),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Salvar OS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}