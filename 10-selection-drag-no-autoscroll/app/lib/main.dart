// Selection-drag autoscroll, with a stock Flutter control.
//
// One app, two modes selected by `?mode=`:
//   package  SelectionArea > BrowserScroller       > Column
//   stock    SelectionArea > SingleChildScrollView > Column
//
// The bottom bar keeps the scroll viewport's bottom edge above the bottom of
// the browser window, so a mouse drag can cross that edge while staying inside
// the page. Flutter starts selection autoscroll only when the pointer is past
// the viewport edge.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  final String mode = Uri.base.queryParameters['mode']!;
  runApp(MyApp(mode: mode));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.mode});

  final String mode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ScrollController _controller = switch (widget.mode) {
    'package' => BrowserScrollController(),
    'stock' => ScrollController(),
    _ => throw ArgumentError.value(widget.mode, 'mode'),
  };
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    // Published for automated checks; the bottom bar shows the same value.
    globalContext['__flutterOffset'] = 0.toJS;
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    globalContext['__flutterOffset'] = _controller.offset.toJS;
    setState(() {
      _offset = _controller.offset;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 60; i++)
          SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Selectable line $i with enough text to drag across'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScrollable() {
    final ScrollController controller = _controller;
    if (controller is BrowserScrollController) {
      return BrowserScroller(controller: controller, child: _buildLines());
    }
    return SingleChildScrollView(controller: controller, child: _buildLines());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SelectionArea(child: _buildScrollable()),
        bottomNavigationBar: Container(
          height: 120,
          color: Colors.black87,
          alignment: Alignment.center,
          child: Text(
            'mode: ${widget.mode}   |   Flutter offset: ${_offset.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
