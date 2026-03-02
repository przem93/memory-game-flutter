import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_start_payload.dart';
import 'package:memory_game/features/select_set/domain/select_set_catalog.dart';

void main() {
  test('resolveSetEntry returns animals-set for animals-set key', () {
    final entry = resolveSetEntry('animals-set');
    expect(entry.setKey, 'animals-set');
    expect(entry.label, 'Animals');
    expect(entry.iconAsset, 'assets/sets/animals-set/bear-svgrepo-com.svg');
  });

  test('resolveSetEntry returns food-set for food-set key', () {
    final entry = resolveSetEntry('food-set');
    expect(entry.setKey, 'food-set');
    expect(entry.label, 'Food');
    expect(entry.iconAsset, 'assets/sets/food-set/coffee-svgrepo-com.svg');
  });

  test('resolveSetEntry falls back to food-set for unknown key', () {
    final entry = resolveSetEntry('unknown-set');
    expect(entry.setKey, CustomizeStartPayload.defaultSetKey);
    expect(entry.label, 'Food');
  });

  test('lockedSetCatalog contains exactly two entries', () {
    expect(lockedSetCatalog.length, 2);
    expect(lockedSetCatalog.map((e) => e.setKey).toList(), ['animals-set', 'food-set']);
  });
}
