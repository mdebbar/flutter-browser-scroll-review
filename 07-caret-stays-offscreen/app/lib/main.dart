import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BrowserScroller(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(24),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Top Input',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              for (int i = 0; i < 60; i++)
                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Spacer Item $i'),
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
