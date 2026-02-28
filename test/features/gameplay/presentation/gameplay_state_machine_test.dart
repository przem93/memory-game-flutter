import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/gameplay/presentation/gameplay_state_machine.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

void main() {
  group('GameplayStateMachine', () {
    List<GameIconIdentity> buildIcons() {
      return const <GameIconIdentity>[
        GameIconIdentity(id: 'apple', assetPath: 'assets/sets/food-set/apple.svg'),
        GameIconIdentity(id: 'banana', assetPath: 'assets/sets/food-set/banana.svg'),
        GameIconIdentity(id: 'apple', assetPath: 'assets/sets/food-set/apple.svg'),
        GameIconIdentity(id: 'banana', assetPath: 'assets/sets/food-set/banana.svg'),
      ];
    }

    test('reveals first card on first flip', () {
      final machine = GameplayStateMachine(icons: buildIcons());
      final firstCardId = machine.cards.first.id;

      final result = machine.flipCard(firstCardId);

      expect(result.type, GameplayFlipResultType.firstCardRevealed);
      expect(machine.cards.first.state, GameCardShellState.revealed);
      expect(machine.isInteractionEnabled, isTrue);
      expect(machine.isBoardCompleted, isFalse);
    });

    test('resolves match and marks both cards as matched', () {
      final machine = GameplayStateMachine(icons: buildIcons());
      final cards = machine.cards;
      final firstApple = cards.firstWhere((card) => card.id.startsWith('apple'));
      final secondApple = cards.lastWhere((card) => card.id.startsWith('apple'));

      machine.flipCard(firstApple.id);
      final result = machine.flipCard(secondApple.id);

      expect(result.type, GameplayFlipResultType.matchedPairResolved);
      final updated = machine.cards;
      expect(
        updated.firstWhere((card) => card.id == firstApple.id).state,
        GameCardShellState.matched,
      );
      expect(
        updated.firstWhere((card) => card.id == secondApple.id).state,
        GameCardShellState.matched,
      );
      expect(machine.isInteractionEnabled, isTrue);
    });

    test('locks interaction on mismatch and unlocks after resolve', () {
      final machine = GameplayStateMachine(icons: buildIcons());
      final cards = machine.cards;
      final firstApple = cards.firstWhere((card) => card.id.startsWith('apple'));
      final firstBanana = cards.firstWhere((card) => card.id.startsWith('banana'));

      machine.flipCard(firstApple.id);
      final mismatch = machine.flipCard(firstBanana.id);

      expect(mismatch.type, GameplayFlipResultType.mismatchPending);
      expect(machine.isInteractionEnabled, isFalse);

      final lockedTap = machine.flipCard(cards.last.id);
      expect(lockedTap.type, GameplayFlipResultType.ignored);

      machine.resolvePendingMismatch();
      expect(machine.isInteractionEnabled, isTrue);
      final updated = machine.cards;
      expect(
        updated.firstWhere((card) => card.id == firstApple.id).state,
        GameCardShellState.hidden,
      );
      expect(
        updated.firstWhere((card) => card.id == firstBanana.id).state,
        GameCardShellState.hidden,
      );
    });

    test('completes board after all pairs are matched', () {
      final machine = GameplayStateMachine(icons: buildIcons());
      final cards = machine.cards;
      final apples = cards.where((card) => card.id.startsWith('apple')).toList();
      final bananas = cards.where((card) => card.id.startsWith('banana')).toList();

      machine.flipCard(apples[0].id);
      machine.flipCard(apples[1].id);
      machine.flipCard(bananas[0].id);
      final result = machine.flipCard(bananas[1].id);

      expect(result.type, GameplayFlipResultType.boardCompleted);
      expect(machine.isBoardCompleted, isTrue);
      expect(machine.isInteractionEnabled, isFalse);
    });
  });
}
