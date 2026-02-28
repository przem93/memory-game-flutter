import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum GameTopBarScalePreset { phone, tablet }

/// Reusable top bar for gameplay screen.
class GameTopBar extends StatefulWidget {
  const GameTopBar({
    required this.elapsed,
    this.onCloseTap,
    this.scalePreset,
    super.key,
  });

  static const topRowKey = ValueKey<String>('gameTopBarTopRow');
  static const timerRowKey = ValueKey<String>('gameTopBarTimerCloseRow');
  static const logoIconTileKey = ValueKey<String>('gameTopBarLogoIconTile');
  static const timerTextKey = ValueKey<String>('gameTopBarTimerText');
  static const closeButtonKey = ValueKey<String>('gameTopBarCloseButton');

  final Duration elapsed;
  final VoidCallback? onCloseTap;
  final GameTopBarScalePreset? scalePreset;

  @override
  State<GameTopBar> createState() => _GameTopBarState();
}

class _GameTopBarState extends State<GameTopBar> {
  static const _phoneReferenceWidth = 393.0;
  static const _phoneHorizontalMargin = 29.0;
  static const _tabletHorizontalInset = 48.0;
  static const _phoneTopSpacing = 50.0;
  static const _phoneRowsGap = 22.0;

  static const _logoIconTileSize = 64.0;
  static const _logoIconPadding = 10.0;
  static const _logoWordmarkHeight = 54.0;
  static const _logoWordmarkLeftGap = 28.0;

  static const _closeButtonWidth = 97.0;
  static const _closeButtonHeight = 28.0;
  static const _closeButtonRadius = 10.0;

  static const _enabledFillColor = Color(0xFFFFFFFF);
  static const _pressedFillColor = Color(0xFFF7F7F7);
  static const _disabledFillColor = Color(0xFFF1F1F1);

  bool _isPressed = false;

  bool get _isEnabled => widget.onCloseTap != null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = switch (widget.scalePreset) {
          GameTopBarScalePreset.tablet => true,
          GameTopBarScalePreset.phone => false,
          null => constraints.maxWidth > 600,
        };
        final horizontalPadding = isTablet
            ? _tabletHorizontalInset
            : _phoneHorizontalMargin;
        final effectiveWidth = (constraints.maxWidth - horizontalPadding * 2)
            .clamp(0.0, double.infinity);
        final widthScale = _resolveWidthScale(
          effectiveWidth: effectiveWidth,
          isTablet: isTablet,
        );

        return Padding(
          padding: EdgeInsets.only(
            top: _phoneTopSpacing * widthScale,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopLogoRow(scale: widthScale),
              SizedBox(height: _phoneRowsGap * widthScale),
              _buildTimerCloseRow(scale: widthScale),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopLogoRow({required double scale}) {
    return Row(
      key: GameTopBar.topRowKey,
      children: [
        Container(
          key: GameTopBar.logoIconTileKey,
          width: _logoIconTileSize * scale,
          height: _logoIconTileSize * scale,
          padding: EdgeInsets.all(_logoIconPadding * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20 * scale),
            border: Border.all(color: Colors.black, width: 2.5 * scale),
          ),
          child: SvgPicture.asset('assets/logo-icon.svg', fit: BoxFit.contain),
        ),
        SizedBox(width: _logoWordmarkLeftGap * scale),
        Expanded(
          child: SizedBox(
            height: _logoWordmarkHeight * scale,
            child: SvgPicture.asset('assets/logo-text.svg', fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCloseRow({required double scale}) {
    final timeLabel = _formatDuration(widget.elapsed);
    final closeFillColor = _isEnabled
        ? (_isPressed ? _pressedFillColor : _enabledFillColor)
        : _disabledFillColor;
    final closeShadowColor = Colors.black.withValues(alpha: _isPressed ? 0.18 : 0.25);

    return Row(
      key: GameTopBar.timerRowKey,
      children: [
        Expanded(
          child: Semantics(
            readOnly: true,
            label: 'Elapsed time $timeLabel',
            child: ExcludeSemantics(
              child: Text(
                timeLabel,
                key: GameTopBar.timerTextKey,
                style: TextStyle(
                  fontFamily: 'DynaPuff',
                  fontWeight: FontWeight.w700,
                  fontSize: 24 * scale,
                  height: 1,
                  color: const Color(0xFFFFFFFF),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
        Semantics(
          button: true,
          enabled: _isEnabled,
          label: 'Close game',
          child: AnimatedScale(
            scale: _isEnabled && _isPressed ? 0.98 : 1,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
              onTapCancel: _isEnabled ? () => _setPressed(false) : null,
              onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
              onTap: _isEnabled ? widget.onCloseTap : null,
              child: AnimatedContainer(
                key: GameTopBar.closeButtonKey,
                duration: const Duration(milliseconds: 90),
                width: _closeButtonWidth * scale,
                height: _closeButtonHeight * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: closeFillColor,
                  borderRadius: BorderRadius.circular(_closeButtonRadius * scale),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: closeShadowColor,
                      offset: const Offset(0, 4),
                      blurRadius: _isPressed ? 1.5 : 2,
                    ),
                  ],
                ),
                child: ExcludeSemantics(
                  child: Text(
                    'CLOSE',
                    style: TextStyle(
                      fontFamily: 'DynaPuff',
                      fontWeight: FontWeight.w700,
                      fontSize: 16 * scale,
                      height: 1,
                      letterSpacing: 0,
                      color: const Color(0xFF204235),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _resolveWidthScale({
    required double effectiveWidth,
    required bool isTablet,
  }) {
    if (isTablet) {
      return 1.2;
    }
    const phoneContentWidth = _phoneReferenceWidth - (_phoneHorizontalMargin * 2);
    final scale = effectiveWidth / phoneContentWidth;
    return scale.clamp(0.9, 1.05);
  }

  String _formatDuration(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);

    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }
    setState(() {
      _isPressed = value;
    });
  }
}
