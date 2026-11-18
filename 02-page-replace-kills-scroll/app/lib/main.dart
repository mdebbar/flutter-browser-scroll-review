// Replaces one BrowserScroller page with another BrowserScroller page. Each
// page creates its own scroller and its own controller.
//
//   ?mode=swap     Scaffold body switches between two tab widgets (setState).
//   ?mode=replace  Navigator.pushReplacement to a second page.
import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  final String mode = Uri.base.queryParameters['mode']!;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: switch (mode) {
        'swap' => const TabShell(),
        'replace' => const FirstPage(),
        _ => throw ArgumentError.value(mode, 'mode'),
      },
    ),
  );
}

class ScrollingPage extends StatelessWidget {
  const ScrollingPage({
    super.key,
    required this.name,
    required this.color,
    required this.buttonLabel,
    required this.onButtonPressed,
  });

  final String name;
  final Color color;
  final String buttonLabel;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return BrowserScroller(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonLabel, style: const TextStyle(fontSize: 22)),
            ),
          ),
          for (int i = 0; i < 60; i++)
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: i.isEven ? color : Colors.white,
              child: Text('$name item $i'),
            ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onGoToSettings});

  final VoidCallback onGoToSettings;

  @override
  Widget build(BuildContext context) {
    return ScrollingPage(
      name: 'Home',
      color: Colors.blue.shade50,
      buttonLabel: 'Go to Settings tab',
      onButtonPressed: onGoToSettings,
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key, required this.onGoToHome});

  final VoidCallback onGoToHome;

  @override
  Widget build(BuildContext context) {
    return ScrollingPage(
      name: 'Settings',
      color: Colors.green.shade50,
      buttonLabel: 'Go to Home tab',
      onButtonPressed: onGoToHome,
    );
  }
}

class TabShell extends StatefulWidget {
  const TabShell({super.key});

  @override
  State<TabShell> createState() => _TabShellState();
}

class _TabShellState extends State<TabShell> {
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showSettings
          ? SettingsTab(onGoToHome: () => setState(() => _showSettings = false))
          : HomeTab(onGoToSettings: () => setState(() => _showSettings = true)),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollingPage(
        name: 'First page',
        color: Colors.blue.shade50,
        buttonLabel: 'pushReplacement to second page',
        onButtonPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SecondPage(),
            ),
          );
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollingPage(
        name: 'Second page',
        color: Colors.green.shade50,
        buttonLabel: '(second page)',
        onButtonPressed: () {},
      ),
    );
  }
}
