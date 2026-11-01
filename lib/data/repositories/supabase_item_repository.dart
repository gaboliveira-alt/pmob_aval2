import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/found_item.dart';
import '../../domain/repositories/item_repository.dart';

class SupabaseItemRepository implements ItemRepository {
  SupabaseItemRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const String _table = 'items';

  @override
  Future<List<FoundItem>> fetchItems() async {
    final rows = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return rows.map(FoundItem.fromJson).toList(growable: false);
  }

  @override
  Future<void> addItem(FoundItem item) async {
    await _client.from(_table).insert(item.toInsertJson());
  }
}
