# `flutter_browser_scroll` review

Bugs I found while reviewing [`flutter_browser_scroll`](https://github.com/flutter-zl/flutter-browser-scroll) v0.3.0 ([`7193d20`](https://github.com/flutter-zl/flutter-browser-scroll/commit/7193d2085cbb836bec3a3bf5e371e2250a9d5136)).

Each folder has a description of one bug, a small app that reproduces it, and a video. The folders are ordered by how much I think the bug hurts users, worst first.

| # | Bug | Impact |
|---|---|---|
| 01 | [Content that loads after the first frame cannot be scrolled](01-async-content-unscrollable) | Page unusable |
| 02 | [Replacing a page with another page kills scrolling](02-page-replace-kills-scroll) | Page unusable until reload |
| 03 | [A page pushed after scrolling opens blank](03-pushed-page-opens-blank) | Page unusable |
| 04 | [The bottom of the page is unreachable under an `AppBar`](04-appbar-cuts-off-bottom) | Content lost |
| 05 | [The `End` key and the scrollbar stop short of the bottom](05-end-key-stops-short) | Annoying |
| 06 | [The scroll made by `Tab` focus traversal snaps back](06-tab-focus-snaps-back) | Keyboard users lose focus |
| 07 | [Typing in a text field that is off-screen doesn't bring it back](07-caret-stays-offscreen) | Typing blind |
| 08 | [Tests that import the package fail to compile on the VM](08-vm-tests-fail-to-compile) | Blocks `flutter test` |
| 09 | [An embedded Flutter view swallows clicks on the rest of the page](09-embedded-view-swallows-clicks) | Blocks embedding |
| 10 | [Dragging a text selection past the edge doesn't scroll the page](10-selection-drag-no-autoscroll) | Minor |
| 11 | [Reloading the page loses the scroll position](11-reload-loses-scroll-position) | Minor |

## Shared causes

Some of these have the same cause, so they are probably cheaper to fix together:

- **02 and 03.** Every `BrowserScroller` creates its own `JsViewScroller`, and they all change the same `<body>` styles and read the same `window.scrollY`. One scroller per Flutter view would fix both.
- **06, 07, and 10.** Flutter moves the `ScrollPosition` directly in these cases, and `BrowserScrollController` only forwards the calls made on the controller. A custom `ScrollPosition` that sends every offset change through the browser would cover all three.
- **04 and 05.** Both come from how the placeholder height is computed.

## Running the apps

Every `app/` depends on the package at v0.3.0 through a Git dependency, so there is nothing to set up:

```
cd 01-async-content-unscrollable/app
flutter run -d chrome --release
```

The apps for 02 and 10 pick a variant with a `?mode=` query parameter. Their READMEs have the exact URLs.

## How I tested

- Flutter master [`4d19bda07a`](https://github.com/flutter/flutter/commit/4d19bda07ae859c5d3a205e3a61619ff485a1182) (3.51.0-1.0.pre-191), CanvasKit, release mode.
- Chrome 158.0.8127.36 on Linux, with mouse and keyboard.
- I didn't test other browsers or touch input.

The videos are recordings of scripted runs that send real input events. The bar at the bottom shows the current step. The last step checks the expected behavior, and it says `FAIL` when the bug is there.

The video for 11 is the exception. I recorded it by hand on a slightly older setup (Flutter [`b98afb5240`](https://github.com/flutter/flutter/commit/b98afb52407777ee1b2544b93b064335ed56e340), Chrome 157). A scripted reload on the setup above gives the same result.
