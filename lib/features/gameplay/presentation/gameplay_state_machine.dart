import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

enum GameplayFlipResultType {
  ignored,
  firstCardRevealed,
  matchedPairResolved,
  mismatchPending,
  boardCompleted,
}

class GameplayFlipResult {
  const GameplayFlipResult({
    required this.type,
    required this.isInteractionEnabled,
    required this.isBoardCompleted,
  });

  final GameplayFlipResultType type;
  final bool isInteractionEnabled;
  final bool isBoardCompleted;
}

class GameplayBoardCard {
  const GameplayBoardCard({
    required this.id,
    required this.symbolAssetPath,
    required this.state,
  });

  final String id;
  final String symbolAssetPath;
  final GameCardShellState state;

  GameplayBoardCard copyWith({GameCardShellState? state}) {
    return GameplayBoardCard(
      id: id,
      symbolAssetPath: symbolAssetPath,
      state: state ?? this.state,
    );
  }
}

/// Deterministic card-state machine for one game board session.
class GameplayStateMachine {
  GameplayStateMachine({required List<GameIconIdentity> icons})
    : _cards = List<GameplayBoardCard>.generate(icons.length, (index) {
        final icon = icons[index];
        return GameplayBoardCard(
          id: '${icon.id}-$index',
          symbolAssetPath: icon.assetPath,
          state: GameCardShellState.hidden,
        );
      }),
      _totalPairs = icons.length ~/ 2;

  final int _totalPairs;
  final List<GameplayBoardCard> _cards;
  String? _firstRevealedCardId;
  ({String firstCardId, String secondCardId})? _pendingMismatch;
  int _matchedPairs = 0;

  List<GameplayBoardCard> get cards => List.unmodifiable(_cards);
  bool get isBoardCompleted => _matchedPairs >= _totalPairs;
  bool get isInteractionEnabled => !isBoardCompleted && _pendingMismatch == null;

  GameplayFlipResult flipCard(String cardId) {
    if (!isInteractionEnabled || isBoardCompleted) {
      return _snapshotResult(type: GameplayFlipResultType.ignored);
    }

    final tappedIndex = _indexOf(cardId);
    if (tappedIndex == null) {
      return _snapshotResult(type: GameplayFlipResultType.ignored);
    }

    final tappedCard = _cards[tappedIndex];
    if (tappedCard.state != GameCardShellState.hidden) {
      return _snapshotResult(type: GameplayFlipResultType.ignored);
    }

    _cards[tappedIndex] = tappedCard.copyWith(state: GameCardShellState.revealed);

    if (_firstRevealedCardId == null) {
      _firstRevealedCardId = cardId;
      return _snapshotResult(type: GameplayFlipResultType.firstCardRevealed);
    }

    final firstIndex = _indexOf(_firstRevealedCardId!);
    if (firstIndex == null) {
      _firstRevealedCardId = null;
      return _snapshotResult(type: GameplayFlipResultType.ignored);
    }

    final firstCard = _cards[firstIndex];
    final secondCard = _cards[tappedIndex];
    _firstRevealedCardId = null;

    if (firstCard.symbolAssetPath == secondCard.symbolAssetPath) {
      _cards[firstIndex] = firstCard.copyWith(state: GameCardShellState.matched);
      _cards[tappedIndex] = secondCard.copyWith(state: GameCardShellState.matched);
      _matchedPairs += 1;

      if (isBoardCompleted) {
        return _snapshotResult(type: GameplayFlipResultType.boardCompleted);
      }

      return _snapshotResult(type: GameplayFlipResultType.matchedPairResolved);
    }

    _pendingMismatch = (firstCardId: firstCard.id, secondCardId: secondCard.id);
    return _snapshotResult(type: GameplayFlipResultType.mismatchPending);
  }

  void resolvePendingMismatch() {
    final pendingMismatch = _pendingMismatch;
    if (pendingMismatch == null || isBoardCompleted) {
      return;
    }

    final firstIndex = _indexOf(pendingMismatch.firstCardId);
    final secondIndex = _indexOf(pendingMismatch.secondCardId);
    if (firstIndex != null) {
      final card = _cards[firstIndex];
      if (card.state == GameCardShellState.revealed) {
        _cards[firstIndex] = card.copyWith(state: GameCardShellState.hidden);
      }
    }
    if (secondIndex != null) {
      final card = _cards[secondIndex];
      if (card.state == GameCardShellState.revealed) {
        _cards[secondIndex] = card.copyWith(state: GameCardShellState.hidden);
      }
    }
    _pendingMismatch = null;
  }

  GameplayFlipResult _snapshotResult({required GameplayFlipResultType type}) {
    return GameplayFlipResult(
      type: type,
      isInteractionEnabled: isInteractionEnabled,
      isBoardCompleted: isBoardCompleted,
    );
  }

  int? _indexOf(String cardId) {
    final index = _cards.indexWhere((card) => card.id == cardId);
    if (index < 0) {
      return null;
    }
    return index;
  }
}
