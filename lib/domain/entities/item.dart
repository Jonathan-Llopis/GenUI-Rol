enum ItemType { weapon, armor, consumable, tool, quest, misc }

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.weight = 0.0,
    this.isEquipped = false,
    this.stats = const {},
  });

  final String id;
  final String name;
  final String description;
  final ItemType type;
  final double weight;
  final bool isEquipped;
  final Map<String, int> stats;

  Item copyWith({
    String? id,
    String? name,
    String? description,
    ItemType? type,
    double? weight,
    bool? isEquipped,
    Map<String, int>? stats,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      weight: weight ?? this.weight,
      isEquipped: isEquipped ?? this.isEquipped,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'weight': weight,
    'isEquipped': isEquipped,
    'stats': stats,
  };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    type: ItemType.values.firstWhere((e) => e.name == json['type']),
    weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    isEquipped: json['isEquipped'] as bool? ?? false,
    stats: Map<String, int>.from(json['stats'] as Map? ?? {}),
  );
}
