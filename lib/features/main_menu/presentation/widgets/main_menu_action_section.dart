import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_primary_button.dart';

/// Action definition used by [MainMenuActionSection].
class MainMenuActionItem {
  const MainMenuActionItem({
    required this.label,
    this.onPressed,
    this.enabled = true,
  }) : assert(label != '');

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
}

/// Arranges Main Menu primary actions into a reusable section.
class MainMenuActionSection extends StatelessWidget {
  const MainMenuActionSection({
    super.key,
    required this.actions,
    this.buttonSpacing = 10,
    this.semanticsLabel = 'Main menu actions',
  }) : assert(actions.length > 0),
       assert(buttonSpacing >= 0);

  static const sectionKey = ValueKey<String>('mainMenuActionSection');

  static ValueKey<String> buttonSlotKeyAt(int index) =>
      ValueKey<String>('mainMenuActionSectionSlot$index');

  static ValueKey<String> actionButtonKeyAt(int index) =>
      ValueKey<String>('mainMenuActionSectionButton$index');

  final List<MainMenuActionItem> actions;
  final double buttonSpacing;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: sectionKey,
      container: true,
      label: semanticsLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) SizedBox(height: buttonSpacing),
            SizedBox(
              key: buttonSlotKeyAt(i),
              width: double.infinity,
              child: MainMenuPrimaryButton(
                key: actionButtonKeyAt(i),
                label: actions[i].label,
                onPressed: actions[i].onPressed,
                enabled: actions[i].enabled,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
