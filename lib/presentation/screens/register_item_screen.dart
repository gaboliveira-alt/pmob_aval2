import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/item_situation.dart';
import '../controllers/items_controller.dart';

final class RegisterItemScreen extends StatefulWidget {
  const RegisterItemScreen({super.key});

  @override
  State<RegisterItemScreen> createState() => _RegisterItemScreenState();
}

final class _RegisterItemScreenState extends State<RegisterItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ItemSituation? _situation;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final controller = context.read<ItemsController>();
    final success = await controller.submitItem(
      name: _nameController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      situation: _situation!,
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo com sucesso!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.submitErrorMessage ?? 'Erro ao salvar.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ItemsController>();
    final isEnabled = !controller.isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar objeto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                enabled: isEnabled,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do objeto',
                  hintText: 'Ex.: Mochila preta, carteira, chaves',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do objeto';
                  }
                  if (value.trim().length > 60) {
                    return 'Use no máximo 60 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                enabled: isEnabled,
                maxLength: 200,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva características, cor, marcas ou detalhes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descrição do objeto';
                  }
                  if (value.trim().length > 200) {
                    return 'Use no máximo 200 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                enabled: isEnabled,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Local',
                  hintText: 'Ex.: Sala 204, biblioteca, refeitório',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o local';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ItemSituation>(
                value: _situation,
                decoration: const InputDecoration(
                  labelText: 'Situação',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  DropdownMenuItem(
                    value: ItemSituation.lost,
                    child: Text(ItemSituation.lost.label),
                  ),
                  DropdownMenuItem(
                    value: ItemSituation.found,
                    child: Text(ItemSituation.found.label),
                  ),
                ],
                onChanged: isEnabled
                    ? (value) => setState(() => _situation = value)
                    : null,
                validator: (value) {
                  if (value == null) {
                    return 'Selecione a situação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: controller.isSubmitting ? null : _submit,
                icon: controller.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(controller.isSubmitting ? 'Salvando...' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
