import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Shown on [MainMenuScreen] when UMP requires a privacy options entry point.
class MainMenuAdPrivacyOptionsLink extends StatefulWidget {
  const MainMenuAdPrivacyOptionsLink({super.key});

  @override
  State<MainMenuAdPrivacyOptionsLink> createState() =>
      _MainMenuAdPrivacyOptionsLinkState();
}

class _MainMenuAdPrivacyOptionsLinkState
    extends State<MainMenuAdPrivacyOptionsLink> {
  bool _loading = true;
  bool _showLink = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPrivacyOptionsRequirement());
  }

  Future<void> _loadPrivacyOptionsRequirement() async {
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      if (!mounted) {
        return;
      }
      setState(() {
        _showLink = status == PrivacyOptionsRequirementStatus.required;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _onPressed() async {
    await ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) {
        debugPrint('Privacy options form: ${error.message}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || !_showLink) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Center(
        child: TextButton(
          onPressed: _onPressed,
          child: Text(
            'Ad privacy settings',
            style: theme.textTheme.labelLarge?.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
