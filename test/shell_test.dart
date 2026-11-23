import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantit/main.dart';
import 'package:plantit/ui.dart';
import 'package:plantit/trees.dart';
import 'package:plantit/more.dart';

Widget wrap(Widget w) => MaterialApp(theme: ThemeData(), home: w);

void main() {
  for (final e in {
    'shell': const Shell(),
    'trees': const Scaffold(body: MyTreesScreen()),
    'care': const Scaffold(body: CareScreen()),
    'impact': const Scaffold(body: ImpactScreen()),
    'profile': const ProfileScreen(),
    'notes': const NotificationsScreen(),
    'recommend': const RecommendScreen(),
  }.entries) {
    testWidgets(e.key, (t) async {
      await t.binding.setSurfaceSize(const Size(390, 844));
      await t.pumpWidget(wrap(e.value));
      await t.pump(const Duration(seconds: 1));
      expect(C.green, isNotNull);
    });
  }
}
