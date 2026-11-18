import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BrowserScrollController _controller = BrowserScrollController();
  final List<FocusNode> _nodes = List<FocusNode>.generate(
    30,
    (_) => FocusNode(),
  );
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.hasClients && _controller.offset != _offset) {
      setState(() {
        _offset = _controller.offset;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            BrowserScroller(
              controller: _controller,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < 30; i++)
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: ElevatedButton(
                          focusNode: _nodes[i],
                          onPressed: () => _nodes[i].requestFocus(),
                          child: Text('Button $i'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      'Flutter offset: ${_offset.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
