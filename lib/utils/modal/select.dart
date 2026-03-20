part of "modal.dart";

extension SelectBottomSheet on _Modal {
  void showSelectBottomSheet<T>({
    required BuildContext context,
    required List<T> items,
    required ActionSheet Function(T) buildOption,
    Function(T, int index)? onSelected,
    String? title,
    T? value,
    bool Function(T, T?)? compare,
  }) {
    this.showBottomSheet(
      context: context,
      builder: (context, _) => _SelectBottomSheet(
        items: items,
        title: title,
        buildOption: buildOption,
        onSelected: onSelected,
        value: value,
        compare: compare,
      ),
    );
  }
}

class _SelectBottomSheet<T> extends StatelessWidget {
  const _SelectBottomSheet({
    super.key,
    required this.items,
    this.title,
    this.group,
    this.onSelected,
    required this.buildOption,
    this.value,
    this.compare,
  });
  final List<T> items;
  final bool? group;
  final String? title;
  final Function(T, int index)? onSelected;
  final ActionSheet Function(T) buildOption;
  final T? value;
  final bool Function(T, T?)? compare;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(Spacing.medium),
        //   child: Text(
        //     "Activity Level",
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        if (title != null)
          SAppBar(
            title: Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.symmetric(
                vertical: Spacing.medium, horizontal: Spacing.medium),
            borderBottom: true,
          ),
        SizedBox(height: Spacing.small),
        ...items.mapV2((item, index) {
          var option = buildOption(item);
          option.radioButton = true;
          option.selected = compare?.call(item, value) ?? item == value;
          option.onTap = () {
            onSelected?.call(item, index);
            Navigator.pop(context);
          };
          return option;
        }),
        // ...(items?.map(
        //       (e) => ActionSheet(
        //         onTap: () {
        //           onChanged?.call(e.name);
        //           Navigator.pop(context);
        //         },
        //         title: Text(e.name),
        //         subtitle: Text(e.description),
        //         selected: e.selected,
        //         radioButton: true,
        //       ),
        //     ) ??
        //     []),
      ],
    );
  }
}
