import 'package:flutter/material.dart';

enum GameCardShellState { hidden, revealed, matched }

/// Reusable card background shell for gameplay board states.
class GameCardShell extends StatelessWidget {
  const GameCardShell({
    required this.state,
    this.child,
    this.semanticLabel,
    this.semanticEnabled = true,
    super.key,
  });

  static const shellKey = ValueKey<String>('gameCardShell');
  static const backgroundAssetKey = ValueKey<String>('gameCardShellBackgroundAsset');
  static const _cornerRadius = 6.0;
  static const _borderWidth = 2.0;
  static const _hiddenFill = Color(0xFFF3F3F3);
  static const _revealedFill = Color(0xFFFFFFFF);
  static const _matchedFill = Color(0xFF03EBD0);

  final GameCardShellState state;
  final Widget? child;
  final String? semanticLabel;
  final bool semanticEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: semanticEnabled,
      label: semanticLabel,
      child: Container(
        key: shellKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cornerRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                key: backgroundAssetKey,
                decoration: BoxDecoration(
                  color: _fillColorFor(state),
                  borderRadius: BorderRadius.circular(_cornerRadius),
                  border: Border.all(color: Colors.black, width: _borderWidth),
                ),
              ),
            ),
            if (child != null)
              Center(
                child: child,
              ),
          ],
        ),
      ),
    );
  }

  static Color _fillColorFor(GameCardShellState state) {
    return switch (state) {
      GameCardShellState.hidden => _hiddenFill,
      GameCardShellState.revealed => _revealedFill,
      GameCardShellState.matched => _matchedFill,
    };
  }
}
