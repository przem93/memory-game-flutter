import 'package:flutter/material.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
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

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _phoneHorizontalMargin = 29.0;
  static const _tabletHorizontalInset = 48.0;
  static const _topBarToBoardGap = 20.0;
  static const _phoneBoardBottomPadding = 138.0;
  static const _tabletBoardBottomPadding = 166.0;

  late List<GameBoardGridCardData> _cards;
  String? _generationError;

  @override
  void initState() {
    super.initState();
    _hydrateBoard();
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startConfig != widget.startConfig ||
        oldWidget.seed != widget.seed) {
      _hydrateBoard();
    }
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
                  elapsed: widget.elapsed,
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
                              onCardTap: null,
                              isInteractionEnabled: false,
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
    _generationError = null;
    _cards = _buildInitialHiddenCards();
  }

  List<GameBoardGridCardData> _buildInitialHiddenCards() {
    final provider = widget.iconSetProvider ?? GameIconSetProvider();
    try {
      final icons = provider.generateForStartConfig(
        widget.startConfig,
        seed: widget.seed,
      );

      return List<GameBoardGridCardData>.generate(icons.length, (index) {
        final icon = icons[index];
        return GameBoardGridCardData(
          id: '${icon.id}-$index',
          state: GameCardShellState.hidden,
          symbolAssetPath: icon.assetPath,
          semanticLabel:
              'Card ${index + 1} of ${icons.length} ${GameCardShellState.hidden.name}',
        );
      });
    } on GameIconSetProviderException catch (error) {
      _generationError =
          'Unable to start game (${error.failure.name}). Please try again.';
      return const <GameBoardGridCardData>[];
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
