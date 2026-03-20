import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

// class SAutocomplete extends StatelessWidget {
//   const SAutocomplete({
//     super.key,
//     required this.optionsBuilder,
//     this.hintText,
//     this.style,
//     this.initialValue,
//     this.contentPadding = const EdgeInsets.only(bottom: 10, top: 10),
//   });
//   final FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
//   final String? hintText;
//   final TextStyle? style;
//   final String? initialValue;
//   final EdgeInsets contentPadding;

//   @override
//   Widget build(BuildContext context) {
//     final onSurface = Theme.of(context).colorScheme.onSurface;
//     final bg = Theme.of(context).scaffoldBackgroundColor;
//     final primary = Theme.of(context).colorScheme.primary;
//     return Autocomplete(
//       optionsBuilder: optionsBuilder,
//       onSelected: (String option) {
//         print(option);
//       },
//       initialValue: TextEditingValue(text: initialValue ?? ''),
//       // optionsMaxHeight: 100,
//       // optionsViewOpenDirection: OptionsViewOpenDirection.up,
//       fieldViewBuilder: (
//         BuildContext context,
//         TextEditingController _controller,
//         FocusNode _focusNode,
//         VoidCallback onFieldSubmitted,
//       ) {
//         return TextField(
//           controller: _controller,
//           focusNode: _focusNode,
//           style: style,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             isDense: true,
//             contentPadding: contentPadding,
//             hintText: hintText,
//             hintStyle: TextStyle(
//               fontSize: 14,
//               color: onSurface.withAlpha(100),
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: onSurface.withAlpha(50),
//               ),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: primary,
//               ),
//             ),
//           ),
//           // onSubmitted: onFieldSubmitted,
//         );
//       },
//       optionsViewBuilder: (context, onSelected, options) {
//         return IntrinsicHeight(
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: bg.lighter(0.02),
//               borderRadius: BorderRadius.circular(Spacing.small),
//             ),
//             alignment: Alignment.bottomCenter,
//             child: Column(
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(
//                 options.length,
//                 (index) => GestureDetector(
//                   onTap: () {
//                     onSelected(options.elementAt(index));
//                   },
//                   behavior: HitTestBehavior.opaque,
//                   child: Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       vertical: Spacing.medium,
//                       horizontal: Spacing.medium,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: index == options.length - 1
//                             ? BorderSide.none
//                             : BorderSide(color: onSurface.withAlpha(20)),
//                       ),
//                     ),
//                     child: Text(options.elementAt(index)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class SAutocomplete<T extends Object> extends StatefulWidget {
  const SAutocomplete({
    super.key,
    // required this.optionsBuilder,
    this.hintText,
    this.style,
    this.initialValue,
    this.onSelected,
    required this.options,
    this.onChanged,
    required this.optionToString,
    this.isExactMatch = false,
    required this.compare,
    this.autofocus = false,
  });
  // final FutureOr<Iterable<T>> Function(TextEditingValue) optionsBuilder;
  final String? hintText;
  final TextStyle? style;
  final String? initialValue;
  final Function(T)? onSelected;
  final Function(String)? onChanged;
  final String Function(T) optionToString;
  final bool isExactMatch;
  final List<T> options;
  final bool Function(String value, T item) compare;
  final bool autofocus;

  @override
  State<SAutocomplete> createState() => _SAutocompleteState<T>();
}

class _SAutocompleteState<T extends Object> extends State<SAutocomplete<T>> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Iterable<T> _options = [];

  Function(T)? _onSelected;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _submit();
      }
    });
  }

  void _submit() {
    if (_options.isNotEmpty) {
      _onSelected?.call(_options.first);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Autocomplete<T>(
      optionsBuilder: (value) {
        final res = widget.options.where((option) {
          return widget.compare(value.text, option);
        });
        _options = res;
        return res;
      },
      onSelected: widget.onSelected,
      // initialValue: TextEditingValue(text: widget.initialValue ?? ''),
      // optionsMaxHeight: 100,
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
      textEditingController: _controller,
      focusNode: _focusNode,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController _controller,
        FocusNode _focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: widget.style,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: (value) {
            _submit();
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: onSurface.withAlpha(100),
            ),
          ),
          // onSubmitted: onFieldSubmitted,
        );
      },
      displayStringForOption: widget.optionToString,
      optionsViewBuilder: (context, onSelected, options) {
        _onSelected = onSelected;
        return IntrinsicHeight(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: bg.lighter(0.02),
              borderRadius: BorderRadius.circular(Spacing.small),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                options.length,
                (index) => GestureDetector(
                  onTap: () {
                    onSelected(options.elementAt(index));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: Spacing.medium,
                      horizontal: Spacing.medium,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == options.length - 1
                            ? BorderSide.none
                            : BorderSide(color: onSurface.withAlpha(20)),
                      ),
                    ),
                    child:
                        Text(widget.optionToString(options.elementAt(index))),
                    // child: Text(options.elementAt(index).toString()),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
