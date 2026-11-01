import 'item_situation.dart';

class FoundItem {
  const FoundItem({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.situation,
    required this.createdAt,
  });

  final String? id;
  final String name;
  final String description;
  final String location;
  final ItemSituation situation;
  final DateTime createdAt;

  factory FoundItem.fromJson(Map<String, dynamic> json) => FoundItem(
    id: json['id'] as String?,
    name: json['name'] as String,
    description: json['description'] as String,
    location: json['location'] as String,
    situation: ItemSituationX.fromStorage(json['situation'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toInsertJson() => {
    'name': name,
    'description': description,
    'location': location,
    'situation': situation.storageValue,
  };
}
