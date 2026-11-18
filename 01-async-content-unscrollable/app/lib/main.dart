import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future<int> _countFuture = Future<int>.delayed(
    const Duration(milliseconds: 800),
    () => 60,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BrowserScroller(
          child: FutureBuilder<int>(
            future: _countFuture,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              final int? count = snapshot.data;
              if (count == null) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('Loading...')),
                );
              }
              return Column(
                children: <Widget>[
                  for (int i = 0; i < count; i++)
                    SizedBox(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Async Item $i'),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
