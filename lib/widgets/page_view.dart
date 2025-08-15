import 'package:flutter/material.dart';

class PageViewController {
  PageController controller = PageController(keepPage: true);

  PageViewController() {
    print('PageViewController');
  }

  ValueNotifier<List<Widget>> children = ValueNotifier([]);
  ValueNotifier<int> _currentIndex = ValueNotifier(0);

  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) {
    _currentIndex.value = value;
  }

  void init(Widget initPage) {
    children.value = [initPage];
    _currentIndex.value = 0;
  }

  void push(Widget child) {
    children.value = [...children.value, child];
    currentIndex = children.value.length - 1;

    Future.delayed(Duration(milliseconds: 0), () {
      controller.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }

  void pop() {
    controller.animateToPage(children.value.length - 2,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    Future.delayed(Duration(milliseconds: 200), () {
      children.value = children.value.sublist(0, currentIndex);
    });
  }

  void reset() {
    children.value = [children.value[0]];
  }

  void dispose() {
    controller.dispose();
    children.dispose(); // Giải phóng ValueNotifier khi không còn sử dụng
  }
}

class SPageView extends StatefulWidget {
  const SPageView({super.key, required this.controller, required this.child});
  final PageViewController controller;
  final Widget child;

  static SPageViewProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SPageViewProvider>();
  }

  @override
  State<SPageView> createState() => _SPageViewState();
}

class _SPageViewState extends State<SPageView> {
  @override
  void initState() {
    super.initState();
    widget.controller.init(widget.child);
  }

  @override
  Widget build(BuildContext context) {
    return SPageViewProvider(
        controller: widget.controller, child: widget.child);
  }
}

class SPageViewProvider extends InheritedWidget {
  SPageViewProvider({Key? key, required this.controller, required Widget child})
      : super(
            key: key,
            child: ValueListenableBuilder<List<Widget>>(
              valueListenable: controller.children,
              builder: (context, value, child) {
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.controller,
                  children: value,
                );
              },
            )) {}
  final PageViewController controller;
  // final List<Widget>? children;

  // static SPageViewProvider? of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<SPageViewProvider>();
  // }

  @override
  bool updateShouldNotify(SPageViewProvider oldWidget) {
    // return controller.children != oldWidget.controller.children;
    return false;
  }
}

// class _SPageView extends StatelessWidget {
//   final PageViewController controller;

//   const _SPageView({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<List<Widget>>(
//       valueListenable: controller.children,
//       builder: (context, value, child) {
//         return PageView(
//           physics: NeverScrollableScrollPhysics(),
//           controller: controller.controller,
//           children: value,
//         );
//       },
//     );
//   }
// }
