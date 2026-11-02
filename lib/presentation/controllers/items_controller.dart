import 'package:flutter/foundation.dart';

import '../../domain/models/found_item.dart';
import '../../domain/models/item_situation.dart';
import '../../domain/repositories/item_repository.dart';

enum ItemsStatus { initial, loading, loaded, error }

enum SubmitStatus { idle, submitting, success, error }

class ItemsController extends ChangeNotifier {
  ItemsController({required this._repository});

  final ItemRepository _repository;

  ItemsStatus status = ItemsStatus.initial;
  SubmitStatus submitStatus = SubmitStatus.idle;
  List<FoundItem> items = const [];
  String? errorMessage;
  String? submitErrorMessage;

  bool get isSubmitting => submitStatus == SubmitStatus.submitting;
  bool get isLoading => status == ItemsStatus.loading;

  Future<void> loadItems() async {
    status = ItemsStatus.loading;
    notifyListeners();
    try {
      items = await _repository.fetchItems();
      errorMessage = null;
      status = ItemsStatus.loaded;
    } catch (_) {
      status = items.isEmpty ? ItemsStatus.error : ItemsStatus.loaded;
      errorMessage = 'Não foi possível carregar os registros. Verifique sua conexão e tente novamente.';
    }
    notifyListeners();
  }

  Future<bool> submitItem({
    required String name,
    required String description,
    required String location,
    required ItemSituation situation,
  }) async {
    if (isSubmitting) return false;

    submitStatus = SubmitStatus.submitting;
    submitErrorMessage = null;
    notifyListeners();

    try {
      final item = FoundItem(
        name: name.trim(),
        description: description.trim(),
        location: location.trim(),
        situation: situation,
        createdAt: DateTime.now(),
      );
      await _repository.addItem(item);
      submitStatus = SubmitStatus.success;
      notifyListeners();
      await loadItems();
      return true;
    } catch (_) {
      submitStatus = SubmitStatus.error;
      submitErrorMessage = 'Não foi possível salvar o registro. Verifique sua conexão e tente novamente.';
      notifyListeners();
      return false;
    }
  }

  void resetSubmitStatus() {
    if (submitStatus != SubmitStatus.submitting) {
      submitStatus = SubmitStatus.idle;
      notifyListeners();
    }
  }
}
