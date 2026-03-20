import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.hintText = 'Search Everything...',
    required this.builder,
    this.onSearch,
    this.delay = 300,
    this.controller,
  });

  final String hintText;
  final Function(String) builder;
  final Function(String)? onSearch;
  final int delay;
  final TextEditingController? controller;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kThemeAnimationDuration * 1.2,
      vsync: this,
    );

    _textEditingController = widget.controller ?? TextEditingController();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hintTextColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: SAppBar(
        leftPadding: 0,
        rightPadding: 0,
        spacing: 0,
        leading: SIconButton(
          onTap: () {
            Navigator.pop(context);
          },
          // svgPath: 'assets/images/svg/chevron-left.svg',
          child: Icon(CupertinoIcons.chevron_left),
        ),
        actions: [SIconButton(onTap: () {}, child: Icon(Icons.send, size: 24))],
        title: Hero(
            tag: 'input_search',
            child: Material(
              color: Colors.transparent,
              child: InputSearch(
                hintText: widget.hintText,
                autofocus: true,
                controller: _textEditingController,
                onChanged: (value) {
                  setState(() {});
                  DelayController.run(() {
                    widget.onSearch?.call(value.trim());
                  }, key: 'search', delay: widget.delay);
                },
              ),
            )),
        // title: AnimatedBuilder(
        //   animation: _controller,
        //   builder: (context, child) {
        //     return Padding(
        //       padding: const EdgeInsets.only(right: 0),
        //       child: Hero(
        //           tag: 'input_search',
        //           child: InputSearch(
        //             hintText: widget.hintText,
        //           )),
        //       // child: Row(
        //       //   mainAxisAlignment: MainAxisAlignment.end,
        //       //   children: [
        //       //     Flexible(
        //       //       flex: 1,
        //       //       child: FractionallySizedBox(
        //       //         widthFactor: _controller.value,
        //       //         child: Container(
        //       //           height: 36,
        //       //           // padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
        //       //           decoration: BoxDecoration(
        //       //             color: bgColor.withAlpha(50),
        //       //             borderRadius: BorderRadius.circular(100),
        //       //           ),
        //       //           child: Row(
        //       //             children: [
        //       //               Expanded(
        //       //                 child: TextField(
        //       //                   controller: _textEditingController,
        //       //                   onChanged: (value) {
        //       //                     setState(() {});
        //       //                   },

        //       //                   // inputFormatters: [
        //       //                   //   LengthLimitingTextInputFormatter(30)
        //       //                   // ],
        //       //                   style: TextStyle(
        //       //                     color: textColor,
        //       //                     fontSize: 14,
        //       //                   ),
        //       //                   cursorHeight: 16,
        //       //                   autofocus: true,
        //       //                   decoration: InputDecoration(
        //       //                     hintText: widget.hintText,
        //       //                     hintStyle: TextStyle(
        //       //                         color: hintTextColor.withAlpha(100)),

        //       //                     // focusedBorder: InputBorder.none,
        //       //                     // enabledBorder: InputBorder.none,
        //       //                     // errorBorder: InputBorder.none,
        //       //                     // disabledBorder: InputBorder.none,
        //       //                     border: OutlineInputBorder(
        //       //                       borderRadius: BorderRadius.circular(10),
        //       //                       borderSide: BorderSide.none,
        //       //                     ),
        //       //                     contentPadding:
        //       //                         EdgeInsets.only(left: Spacing.medium),
        //       //                   ),
        //       //                 ),
        //       //               ),
        //       //               if (_textEditingController.text.isNotEmpty)
        //       //                 SIconButton(
        //       //                   child: Icon(CupertinoIcons.xmark),
        //       //                   // child: SvgPicture.asset(
        //       //                   //   'assets/images/svg/x-fill.svg',
        //       //                   //   width: 20,
        //       //                   //   height: 20,
        //       //                   //   colorFilter: ColorFilter.mode(
        //       //                   //       Theme.of(context)
        //       //                   //           .colorScheme
        //       //                   //           .surface
        //       //                   //           .withAlpha(200),
        //       //                   //       BlendMode.srcIn),
        //       //                   // ),
        //       //                   onTap: () {
        //       //                     _textEditingController.clear();
        //       //                     setState(() {});
        //       //                   },
        //       //                 )
        //       //             ],
        //       //           ),
        //       //         ),
        //       //       ),
        //       //     ),
        //       //   ],
        //       // ),
        //     );
        //   },
        // ),
      ),

      // body: widget.builder(''),
      body: widget.builder(_textEditingController.text.trim()),
    );
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.circular(Spacing.small),
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SIconButton(
              child: SvgPicture.asset(
                'assets/images/svg/search.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.surface.withAlpha(200),
                    BlendMode.srcIn),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SIconButton(
              child: SvgPicture.asset(
                'assets/images/svg/arrow-up-right.svg',
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.surface.withAlpha(200),
                    BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
