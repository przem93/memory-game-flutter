import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memory_game/core/admob_banner_ad_unit_ids.dart';

/// Semantics label for the banner region (matches English labels used elsewhere).
const String kAdBannerSemanticsLabel = 'Advertisement';

/// Bottom anchored adaptive banner with a stable reserved height (Spec Lock: loading / error / no-fill).
class AdBannerSlot extends StatefulWidget {
  const AdBannerSlot({super.key});

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  BannerAd? _bannerAd;
  bool _loaded = false;

  int _loadGeneration = 0;
  int? _trackedWidth;
  Orientation? _trackedOrientation;

  bool _slotSizeResolved = false;
  double _slotWidth = 0;
  double _slotHeight = AdSize.banner.height.toDouble();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.sizeOf(context).width.truncate();
    final orientation = MediaQuery.orientationOf(context);
    if (_trackedWidth == width && _trackedOrientation == orientation) {
      return;
    }
    _trackedWidth = width;
    _trackedOrientation = orientation;
    unawaited(_resolveAndLoad());
  }

  Future<void> _resolveAndLoad() async {
    final gen = ++_loadGeneration;

    await _bannerAd?.dispose();
    if (!mounted || gen != _loadGeneration) {
      return;
    }
    _bannerAd = null;
    _loaded = false;

    final width = MediaQuery.sizeOf(context).width.truncate();
    final AnchoredAdaptiveBannerAdSize? anchored =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || gen != _loadGeneration) {
      return;
    }

    final AdSize size =
        anchored ?? AdSize(width: width, height: AdSize.banner.height);

    setState(() {
      _slotSizeResolved = true;
      _slotWidth = size.width.toDouble();
      _slotHeight = size.height.toDouble();
    });

    if (!mounted || gen != _loadGeneration) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: anchoredAdaptiveBannerAdUnitId(),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad _) {
          if (!mounted || gen != _loadGeneration) {
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          if (!mounted || gen != _loadGeneration) {
            return;
          }
          setState(() {
            _bannerAd = null;
            _loaded = false;
          });
        },
      ),
    );

    await _bannerAd!.load();
  }

  @override
  void dispose() {
    _loadGeneration++;
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final w = _slotSizeResolved ? _slotWidth : width;
    final h = _slotSizeResolved ? _slotHeight : AdSize.banner.height.toDouble();

    return Semantics(
      container: true,
      label: kAdBannerSemanticsLabel,
      child: SizedBox(
        width: w,
        height: h,
        child: _loaded && _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : const _AdBannerPlaceholder(),
      ),
    );
  }
}

class _AdBannerPlaceholder extends StatelessWidget {
  const _AdBannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Color(0x00000000));
  }
}
