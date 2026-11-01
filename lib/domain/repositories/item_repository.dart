import '../models/found_item.dart';

abstract interface class ItemRepository {
  Future<List<FoundItem>> fetchItems();

  Future<void> addItem(FoundItem item);
}
