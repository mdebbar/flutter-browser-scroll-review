# Tests that import the package fail to compile on the VM

Any widget test that imports `package:flutter_browser_scroll/flutter_browser_scroll.dart` fails to compile with plain `flutter test`, which runs on the Dart VM. An app that also ships on mobile or desktop can't import the package either, unless it adds its own conditional import.

The package declares `platforms: web`, so doing nothing off the web is fine. The problem is that importing it breaks the build.

## Steps

1. Run the test:
   ```
   cd app
   flutter test
   ```

Expected: the test compiles and runs.

Actual: compilation fails:

```
.../lib/src/js_view_scroller.dart:6:8: Error: Dart library 'dart:js_interop' is not available on this platform.
import 'dart:js_interop';
       ^
.../lib/src/js_view_scroller.dart:9:8: Error: Dart library 'dart:ui_web' is not available on this platform.
import 'dart:ui_web' as ui_web;
       ^
```

I only ran `flutter test`. A non-web build compiles the same imports, so I expect the same errors there.

## Cause

`js_view_scroller.dart` [imports](https://github.com/flutter-zl/flutter-browser-scroll/blob/7193d2085cbb836bec3a3bf5e371e2250a9d5136/lib/src/js_view_scroller.dart#L5-L11) `dart:js_interop`, `dart:ui_web`, and `package:web`. The package [exports it](https://github.com/flutter-zl/flutter-browser-scroll/blob/7193d2085cbb836bec3a3bf5e371e2250a9d5136/lib/flutter_browser_scroll.dart#L10) unconditionally, and `browser_scroller.dart` imports it for the [default scroller factory](https://github.com/flutter-zl/flutter-browser-scroll/blob/7193d2085cbb836bec3a3bf5e371e2250a9d5136/lib/src/browser_scroller.dart#L59-L61).

## Possible fix

Put `JsViewScroller` behind a conditional import (`if (dart.library.js_interop)`), with a stub for other platforms.
