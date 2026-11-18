// A Flutter view embedded in a host HTML page (see web/index.html), in the
// setup that works best with BrowserScroller:
//   - The host element is sized by a CSS rule, not an inline style, so the
//     cloned placeholder keeps its size.
//   - BrowserScroller is the root of the route, so nothing opaque is painted
//     outside the placeholder's visible rect.
//   - The host is not nested inside a positioned ancestor.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const EmbeddedApp());
}

class EmbeddedApp extends StatefulWidget {
  const EmbeddedApp({super.key});

  @override
  State<EmbeddedApp> createState() => _EmbeddedAppState();
}

class _EmbeddedAppState extends State<EmbeddedApp> {
  final GlobalKey _firstItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(_reportFirstItemPosition);
  }

  // Publishes the on-screen y coordinate of "Embedded Item 0" as
  // `window.__embeddedItem0Y`, so a script can compare it with the
  // placeholder's position in the host page.
  void _reportFirstItemPosition(Duration timestamp) {
    final BuildContext? itemContext = _firstItemKey.currentContext;
    if (itemContext == null) {
      return;
    }
    final RenderBox box = itemContext.findRenderObject()! as RenderBox;
    if (!box.hasSize) {
      return;
    }
    globalContext['__embeddedItem0Y'] = box.localToGlobal(Offset.zero).dy.toJS;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrowserScroller(
        child: Material(
          color: Colors.blue.shade50,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 30; i++)
                Container(
                  key: i == 0 ? _firstItemKey : null,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: i.isEven ? Colors.blue.shade100 : Colors.blue.shade50,
                  child: Text('Embedded Item $i'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
