import 'package:equatable/equatable.dart';
import 'package:rol_genui/domain/entities/item.dart';

class InventoryUpdate extends Equatable {
  const InventoryUpdate({required this.action, this.item, this.itemId});
  final String action; // 'add' or 'remove'
  final Item? item;
  final String? itemId;

  @override
  List<Object?> get props => [action, item, itemId];

  factory InventoryUpdate.fromJson(Map<String, dynamic> json) {
    // Permissive parsing for action
    final rawAction = json['action']?.toString().toLowerCase() ?? 'add';
    final action = (rawAction == 'remove' || rawAction == 'delete') ? 'remove' : 'add';

    return InventoryUpdate(
      action: action,
      item: json['item'] is Map
          ? Item.fromJson(json['item'] as Map<String, dynamic>)
          : null,
      itemId: json['id']?.toString() ?? json['itemId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'action': action,
        if (item != null) 'item': item!.toJson(),
        if (itemId != null) 'id': itemId,
      };
}
