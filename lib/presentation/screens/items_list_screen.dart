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
                : () => _refresh(context, controller),
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

  Future<void> _refresh(
    BuildContext context,
    ItemsController controller,
  ) async {
    await controller.loadItems();
    final message = controller.errorMessage;
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _buildBody(BuildContext context, ItemsController controller) {
    return switch (controller.status) {
      ItemsStatus.initial || ItemsStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
      ItemsStatus.error => _ErrorStateView(
          message: controller.errorMessage ??
              'Não foi possível carregar os registros.',
          onRetry: controller.loadItems,
        ),
      ItemsStatus.loaded when controller.items.isEmpty =>
        const _EmptyStateView(),
      ItemsStatus.loaded => RefreshIndicator(
          onRefresh: () => _refresh(context, controller),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                ItemCard(item: controller.items[index]),
          ),
        ),
    };
  }
}

final class _ErrorStateView extends StatelessWidget {
  const _ErrorStateView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

final class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro ainda.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cadastre um objeto perdido ou encontrado.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
