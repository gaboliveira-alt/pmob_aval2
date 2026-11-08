import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/items_controller.dart';
import '../widgets/item_card.dart';
import 'register_item_screen.dart';

final class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ItemsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achados e Perdidos'),
        actions: [
          IconButton(
            onPressed: controller.isLoading
                ? null
                : () async {
                    await controller.loadItems();
                    final message = controller.errorMessage;
                    if (message != null && context.mounted) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    }
                  },
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, controller),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const RegisterItemScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemsController controller) {
    return switch (controller.status) {
      ItemsStatus.initial || ItemsStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
      ItemsStatus.error => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage ??
                      'Não foi possível carregar os registros.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.loadItems,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ItemsStatus.loaded when controller.items.isEmpty => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum registro ainda.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cadastre um objeto perdido ou encontrado.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ItemsStatus.loaded => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              ItemCard(item: controller.items[index]),
        ),
    };
  }
}
