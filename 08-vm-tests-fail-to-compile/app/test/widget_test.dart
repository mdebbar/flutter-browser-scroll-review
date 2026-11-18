import 'package:flutter/widgets.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BrowserScroller builds in VM widget test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: BrowserScroller(child: SizedBox()),
      ),
    );
  });
}
