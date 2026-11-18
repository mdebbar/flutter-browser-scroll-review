// A list page that pushes a detail page. Each page has its own BrowserScroller.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_browser_scroll/flutter_browser_scroll.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: ListPage()));
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrowserScroller(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < 60; i++)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => DetailPage(product: i),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: i.isEven ? Colors.grey.shade100 : Colors.white,
                  child: Text('Product $i (tap to open)'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.product});

  final int product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey _titleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(_reportTitlePosition);
  }

  // Publishes the on-screen y coordinate of the detail title as
  // `window.__detailTitleY`, so a script can check that the detail content is
  // inside the window.
  void _reportTitlePosition(Duration timestamp) {
    if (!mounted) {
      return;
    }
    final RenderBox box = _titleKey.currentContext!.findRenderObject()! as RenderBox;
    globalContext['__detailTitleY'] = box.localToGlobal(Offset.zero).dy.toJS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      body: BrowserScroller(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              key: _titleKey,
              height: 80,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'DETAIL PAGE for product ${widget.product}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            for (int j = 0; j < 5; j++)
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Detail line $j'),
              ),
          ],
        ),
      ),
    );
  }
}
