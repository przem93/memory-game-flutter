import 'package:memory_game/features/select_set/domain/select_set_entry.dart';

/// Locked set catalog for MVP (Spec Lock §4).
const List<SelectSetEntry> lockedSetCatalog = [
  (setKey: 'animals-set', label: 'Animals', iconAsset: 'assets/sets/animals-set/bear-svgrepo-com.svg'),
  (setKey: 'food-set', label: 'Food', iconAsset: 'assets/sets/food-set/coffee-svgrepo-com.svg'),
];

/// Fallback set key when unknown key is requested (aligned with CustomizeStartPayload.defaultSetKey).
const String _fallbackSetKey = 'food-set';

/// Resolves a set entry by key. Unknown keys fall back to food-set.
SelectSetEntry resolveSetEntry(String setKey) {
  for (final entry in lockedSetCatalog) {
    if (entry.setKey == setKey) return entry;
  }
  return lockedSetCatalog.firstWhere(
    (e) => e.setKey == _fallbackSetKey,
  );
}
