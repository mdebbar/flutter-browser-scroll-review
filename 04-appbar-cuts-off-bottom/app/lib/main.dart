import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AppBar Cutoff Repro')),
        body: BrowserScroller(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 60; i++)
                SizedBox(
                  height: 50,
                  child: ColoredBox(
                    color: i == 59
                        ? Colors.amber
                        : (i.isEven ? Colors.grey.shade100 : Colors.white),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(i == 59 ? 'Item 59 (bottom)' : 'Item $i'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
