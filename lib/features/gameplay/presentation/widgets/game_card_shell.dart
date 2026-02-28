import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(
              child: SvgPicture.asset(
                _assetPathFor(state),
                key: backgroundAssetKey,
                fit: BoxFit.fill,
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

  static String _assetPathFor(GameCardShellState state) {
    return switch (state) {
      GameCardShellState.hidden => 'assets/game-screen/reversed-card.svg',
      GameCardShellState.revealed => 'assets/game-screen/Card.svg',
      GameCardShellState.matched => 'assets/game-screen/matched card.svg',
    };
  }
}
