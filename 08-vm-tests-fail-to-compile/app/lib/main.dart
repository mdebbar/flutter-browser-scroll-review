import 'package:flutter/widgets.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: BrowserScroller(child: SizedBox()),
    ),
  );
}
