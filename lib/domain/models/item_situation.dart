enum ItemSituation { lost, found }

extension ItemSituationX on ItemSituation {
  String get label => switch (this) {
    ItemSituation.lost => 'Perdido',
    ItemSituation.found => 'Encontrado',
  };

  String get storageValue => switch (this) {
    ItemSituation.lost => 'lost',
    ItemSituation.found => 'found',
  };

  static ItemSituation fromStorage(String value) => switch (value) {
    'found' => ItemSituation.found,
    _ => ItemSituation.lost,
  };
}
