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

  factory Item.fromJson(Map<String, dynamic> json) {
    // Permissive parsing to avoid crashes with local LLMs
    return Item(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Objeto desconocido',
      description: json['description']?.toString() ?? 'Sin descripción',
      type: _parseType(json['type']?.toString()),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      isEquipped: json['isEquipped'] as bool? ?? false,
      stats: json['stats'] is Map
          ? Map<String, int>.from(json['stats'] as Map)
          : const {},
    );
  }

  static ItemType _parseType(String? typeStr) {
    if (typeStr == null) return ItemType.misc;
    final clean = typeStr.toLowerCase().trim();
    for (final val in ItemType.values) {
      if (val.name == clean) return val;
    }
    // Fallbacks comunes que la IA podría usar
    if (clean.contains('arma') || clean.contains('sword')) return ItemType.weapon;
    if (clean.contains('escudo') || clean.contains('armor')) return ItemType.armor;
    if (clean.contains('pocion') || clean.contains('potion')) return ItemType.consumable;
    return ItemType.misc;
  }
}
