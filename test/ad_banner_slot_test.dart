import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:memory_game/shared/widgets/ad_banner_slot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const mockAdaptiveHeight = 90.0;

  Future<void> sendAdEvent(
    int adId,
    String eventName,
    Map<String, dynamic>? extra,
  ) async {
    final args = <String, dynamic>{'adId': adId, 'eventName': eventName};
    extra?.forEach((k, v) {
      args[k] = v;
    });
    final MethodCall methodCall = MethodCall('onAdEvent', args);
    final ByteData data = instanceManager.channel.codec.encodeMethodCall(
      methodCall,
    );
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          'plugins.flutter.io/google_mobile_ads',
          data,
          (ByteData? data) {},
        );
  }

  setUp(() {
    instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(instanceManager.channel, (
          MethodCall methodCall,
        ) async {
          switch (methodCall.method) {
            case 'AdSize#getAnchoredAdaptiveBannerAdSize':
              return mockAdaptiveHeight;
            case 'loadBannerAd':
            case 'disposeAd':
              return null;
            default:
              fail('unexpected method: ${methodCall.method}');
          }
        });
  });

  testWidgets(
    'AdBannerSlot reserves mock adaptive height and exposes Semantics',
    (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(393, 852);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SafeArea(child: AdBannerSlot())),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byType(AdBannerSlot)),
        matchesSemantics(label: kAdBannerSemanticsLabel),
      );

      final box = tester.renderObject<RenderBox>(find.byType(SizedBox).first);
      expect(box.size.height, mockAdaptiveHeight);
    },
  );

  testWidgets('AdBannerSlot keeps same height after onAdFailedToLoad', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SafeArea(child: AdBannerSlot())),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    final heightBefore = tester
        .renderObject<RenderBox>(find.byType(SizedBox).first)
        .size
        .height;
    expect(heightBefore, mockAdaptiveHeight);

    final responseInfo = ResponseInfo(
      responseExtras: const <String, dynamic>{},
    );
    final loadError = LoadAdError(1, 'domain', 'message', responseInfo);
    await sendAdEvent(0, 'onAdFailedToLoad', {'loadAdError': loadError});
    await tester.pump();

    final heightAfter = tester
        .renderObject<RenderBox>(find.byType(SizedBox).first)
        .size
        .height;
    expect(heightAfter, mockAdaptiveHeight);
  });
}
