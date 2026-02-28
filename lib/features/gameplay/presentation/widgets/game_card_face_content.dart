import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

/// Reusable face overlay content rendered inside [GameCardShell].
class GameCardFaceContent extends StatelessWidget {
  const GameCardFaceContent({
    required this.state,
    this.symbolAssetPath,
    this.semanticLabel,
    this.semanticEnabled = true,
    super.key,
  }) : assert(
         state == GameCardShellState.hidden ||
             (symbolAssetPath != null && symbolAssetPath != ''),
         'symbolAssetPath is required for revealed and matched states',
       );

  static const rootKey = ValueKey<String>('gameCardFaceContent');
  static const overlayAssetKey = ValueKey<String>('gameCardFaceContentOverlayAsset');
  static const hiddenAssetPath = 'assets/card-brain.svg';
  static const hiddenIconMaxScale = 0.7;
  static const revealedIconScale = 0.52;

  final GameCardShellState state;
  final String? symbolAssetPath;
  final String? semanticLabel;
  final bool semanticEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: rootKey,
      enabled: semanticEnabled,
      image: true,
      label: semanticLabel ?? _defaultSemanticLabelFor(state),
      child: ExcludeSemantics(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: _overlayScaleFor(state),
            heightFactor: _overlayScaleFor(state),
            child: SvgPicture.asset(
              _overlayAssetPathFor(state: state, symbolAssetPath: symbolAssetPath),
              key: overlayAssetKey,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  static String _overlayAssetPathFor({
    required GameCardShellState state,
    required String? symbolAssetPath,
  }) {
    return switch (state) {
      GameCardShellState.hidden => hiddenAssetPath,
      GameCardShellState.revealed || GameCardShellState.matched =>
        symbolAssetPath ?? hiddenAssetPath,
    };
  }

  static String _defaultSemanticLabelFor(GameCardShellState state) {
    return switch (state) {
      GameCardShellState.hidden => 'Hidden card symbol',
      GameCardShellState.revealed || GameCardShellState.matched =>
        'Card symbol',
    };
  }

  static double _overlayScaleFor(GameCardShellState state) {
    return switch (state) {
      GameCardShellState.hidden => hiddenIconMaxScale,
      GameCardShellState.revealed || GameCardShellState.matched =>
        revealedIconScale,
    };
  }
}
