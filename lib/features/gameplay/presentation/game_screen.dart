import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/gameplay/presentation/gameplay_state_machine.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_scene_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_top_bar.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';

/// Stage 3 gameplay composition screen built from reusable game components.
class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.startConfig,
    this.onCloseTap,
    this.iconSetProvider,
    this.elapsed = Duration.zero,
    this.seed,
    this.semanticsLabel = 'Game screen',
    this.mismatchRevealDuration = const Duration(milliseconds: 650),
    this.timerTick = const Duration(seconds: 1),
    super.key,
  });

  static const contentKey = ValueKey<String>('gameScreenContent');
  static const boardSlotKey = ValueKey<String>('gameScreenBoardSlot');
  static const errorKey = ValueKey<String>('gameScreenError');

  final SelectLevelStartConfig startConfig;
  final VoidCallback? onCloseTap;
  final GameIconSetProvider? iconSetProvider;
  final Duration elapsed;
  final int? seed;
  final String semanticsLabel;
  final Duration mismatchRevealDuration;
  final Duration timerTick;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _phoneHorizontalMargin = 29.0;
  static const _tabletHorizontalInset = 48.0;
  static const _topBarToBoardGap = 20.0;
  static const _phoneBoardBottomPadding = 138.0;
  static const _tabletBoardBottomPadding = 166.0;

  Timer? _ticker;
  GameplayStateMachine? _stateMachine;
  late List<GameBoardGridCardData> _cards;
  String? _generationError;
  late Duration _elapsed;
  int _boardVersion = 0;

  @override
  void initState() {
    super.initState();
    _elapsed = widget.elapsed;
    _hydrateBoard();
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startConfig.rows != widget.startConfig.rows ||
        oldWidget.startConfig.columns != widget.startConfig.columns ||
        oldWidget.startConfig.difficulty != widget.startConfig.difficulty ||
        oldWidget.seed != widget.seed) {
      _hydrateBoard();
    }
  }

  @override
  void dispose() {
    _stopTimer(reset: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameSceneShell(
      semanticsLabel: widget.semanticsLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return Semantics(
            key: GameScreen.contentKey,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameTopBar(
                  elapsed: _elapsed,
                  scalePreset: isTablet
                      ? GameTopBarScalePreset.tablet
                      : GameTopBarScalePreset.phone,
                  onCloseTap:
                      widget.onCloseTap ??
                      () => Navigator.of(context).maybePop(),
                ),
                SizedBox(height: _topBarToBoardGap),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isTablet
                          ? _tabletHorizontalInset
                          : _phoneHorizontalMargin,
                      right: isTablet
                          ? _tabletHorizontalInset
                          : _phoneHorizontalMargin,
                      bottom: isTablet
                          ? _tabletBoardBottomPadding
                          : _phoneBoardBottomPadding,
                    ),
                    child: Align(
                      key: GameScreen.boardSlotKey,
                      alignment: Alignment.topCenter,
                      child: _generationError == null
                          ? GameBoardGrid(
                              rows: widget.startConfig.rows,
                              columns: widget.startConfig.columns,
                              cards: _cards,
                              onCardTap: _onCardTap,
                              isInteractionEnabled:
                                  _stateMachine?.isInteractionEnabled ?? false,
                            )
                          : _buildErrorState(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _hydrateBoard() {
    _boardVersion += 1;
    _stopTimer(reset: true);
    _stateMachine = null;
    _generationError = null;
    _elapsed = widget.elapsed;
    _cards = const <GameBoardGridCardData>[];
    final provider = widget.iconSetProvider ?? GameIconSetProvider();
    try {
      final icons = provider.generateForStartConfig(
        widget.startConfig,
        seed: widget.seed,
      );
      _stateMachine = GameplayStateMachine(icons: icons);
      _syncCardsFromStateMachine();
      _startTimer();
    } on GameIconSetProviderException catch (error) {
      _generationError =
          'Unable to start game (${error.failure.name}). Please try again.';
    }
  }

  void _onCardTap(String cardId) {
    final stateMachine = _stateMachine;
    if (stateMachine == null) {
      return;
    }

    final result = stateMachine.flipCard(cardId);
    if (result.type == GameplayFlipResultType.ignored) {
      return;
    }

    setState(_syncCardsFromStateMachine);

    if (result.type == GameplayFlipResultType.mismatchPending) {
      _scheduleMismatchResolution(version: _boardVersion);
      return;
    }

    if (result.isBoardCompleted) {
      _stopTimer();
    }
  }

  Future<void> _scheduleMismatchResolution({required int version}) async {
    await Future<void>.delayed(widget.mismatchRevealDuration);
    if (!mounted || version != _boardVersion) {
      return;
    }

    final stateMachine = _stateMachine;
    if (stateMachine == null) {
      return;
    }

    stateMachine.resolvePendingMismatch();
    setState(_syncCardsFromStateMachine);
  }

  void _syncCardsFromStateMachine() {
    final stateMachine = _stateMachine;
    if (stateMachine == null) {
      _cards = const <GameBoardGridCardData>[];
      return;
    }

    final snapshot = stateMachine.cards;
    _cards = List<GameBoardGridCardData>.generate(snapshot.length, (index) {
      final card = snapshot[index];
      return GameBoardGridCardData(
        id: card.id,
        state: card.state,
        symbolAssetPath: card.symbolAssetPath,
        semanticLabel: _semanticLabelFor(
          position: index + 1,
          total: snapshot.length,
          state: card.state,
        ),
      );
    });
  }

  String _semanticLabelFor({
    required int position,
    required int total,
    required GameCardShellState state,
  }) {
    final stateLabel = switch (state) {
      GameCardShellState.hidden => 'hidden',
      GameCardShellState.revealed => 'revealed',
      GameCardShellState.matched => 'matched',
    };
    return 'Card $position of $total $stateLabel';
  }

  void _startTimer() {
    if (_generationError != null || _stateMachine == null) {
      return;
    }

    _ticker?.cancel();
    _ticker = Timer.periodic(widget.timerTick, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _elapsed += widget.timerTick;
      });
    });
  }

  void _stopTimer({bool reset = false}) {
    _ticker?.cancel();
    _ticker = null;
    if (reset) {
      _elapsed = widget.elapsed;
    }
  }

  Widget _buildErrorState() {
    return Container(
      key: GameScreen.errorKey,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Text(
        _generationError ?? 'Unable to start game.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'DynaPuff',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
