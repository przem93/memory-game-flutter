import 'package:flutter/material.dart';

/// Popular phone logical sizes for golden tests (iOS + Android).
const goldenPhoneSizes = <String, Size>{
  'phone_small': Size(360, 800),
  'phone_medium': Size(390, 844),
  'phone_medium_pro': Size(393, 852),
  'phone_large': Size(414, 896),
};

/// Popular tablet logical sizes for golden tests (iOS + Android).
const goldenTabletSizes = <String, Size>{
  'tablet_compact': Size(744, 1133),
  'tablet_standard': Size(834, 1194),
  'tablet_large': Size(1024, 1366),
};
