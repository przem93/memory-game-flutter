import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_start_payload.dart';

void main() {
  test('resolves locked mapping for all supported card counts', () {
    const expected = <int, ({int rows, int columns, int pairCount})>{
      6: (rows: 2, columns: 3, pairCount: 3),
      8: (rows: 2, columns: 4, pairCount: 4),
      10: (rows: 2, columns: 5, pairCount: 5),
      12: (rows: 3, columns: 4, pairCount: 6),
      14: (rows: 2, columns: 7, pairCount: 7),
      16: (rows: 4, columns: 4, pairCount: 8),
      18: (rows: 3, columns: 6, pairCount: 9),
      20: (rows: 4, columns: 5, pairCount: 10),
      24: (rows: 4, columns: 6, pairCount: 12),
    };

    for (final entry in expected.entries) {
      final payload = resolveCustomizeStartPayload(
        entry.key,
        CustomizeStartPayload.defaultSetKey,
      );
      expect(payload.setKey, CustomizeStartPayload.defaultSetKey);
      expect(payload.cardCount, entry.key);
      expect(payload.rows, entry.value.rows);
      expect(payload.columns, entry.value.columns);
      expect(payload.pairCount, entry.value.pairCount);
    }
  });

  test('falls back to 16 cards mapping for unsupported values', () {
    final payload = resolveCustomizeStartPayload(
      9,
      CustomizeStartPayload.defaultSetKey,
    );
    expect(payload.setKey, CustomizeStartPayload.defaultSetKey);
    expect(payload.cardCount, CustomizeStartPayload.fallbackCardCount);
    expect(payload.rows, 4);
    expect(payload.columns, 4);
    expect(payload.pairCount, 8);
  });

  test('passes through animals-set and food-set', () {
    final animalsPayload = resolveCustomizeStartPayload(16, 'animals-set');
    expect(animalsPayload.setKey, 'animals-set');

    final foodPayload = resolveCustomizeStartPayload(16, 'food-set');
    expect(foodPayload.setKey, 'food-set');
  });

  test('falls back to food-set for unknown set key', () {
    final payload = resolveCustomizeStartPayload(16, 'unknown-set');
    expect(payload.setKey, CustomizeStartPayload.defaultSetKey);
  });

  test('toSelectLevelStartConfig passes setKey for animals-set and food-set', () {
    final animalsPayload = resolveCustomizeStartPayload(16, 'animals-set');
    final animalsConfig = animalsPayload.toSelectLevelStartConfig();
    expect(animalsConfig.setKey, 'animals-set');

    final foodPayload = resolveCustomizeStartPayload(16, 'food-set');
    final foodConfig = foodPayload.toSelectLevelStartConfig();
    expect(foodConfig.setKey, 'food-set');
  });
}
