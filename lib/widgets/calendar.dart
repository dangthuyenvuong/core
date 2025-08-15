import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SCalendar extends StatefulWidget {
  const SCalendar({
    super.key,
    this.title,
    this.isShowFull = false,
    this.onTap,
    this.itemBuilder,
    this.after,
    this.onChangeMonth,
    this.backgroundColor,
    this.padding,
  });
  final bool isShowFull;
  final Widget? after;

  final Widget? title;
  final Function(DateTime)? onTap;
  final Function(DateTime)? itemBuilder;
  final Function(DateTime)? onChangeMonth;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  State<SCalendar> createState() => _SCalendarState();
}

class _SCalendarState extends State<SCalendar> {
  late DateTime date;
  late int numOfDaysInMonth;
  late int numOfDayOffset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onChangeMonth(DateTime.now());
  }

  void _onChangeMonth(DateTime date) {
    setState(() {
      this.date = date;
      numOfDaysInMonth = DateTime(date.year, date.month + 1, 0).day;
      numOfDayOffset = DateTime(date.year, date.month, 1).weekday - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = getBgMode(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
        padding: widget.padding ?? EdgeInsets.all(Spacing.large),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? bg,
          borderRadius: BorderRadius.circular(Spacing.medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) widget.title!,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SIconButton(
                  onTap: () {
                    _onChangeMonth(DateTime(date.year, date.month - 1, 1));
                    widget.onChangeMonth?.call(date);
                  },
                  svgPath: 'assets/images/svg/chevron-left.svg',
                  size: 18,
                ),
                Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Cupertino.showDatePicker(
                      context: context,
                      initialDateTime: date,
                      mode: CupertinoDatePickerMode.monthYear,
                      onDateTimeChanged: (value) {
                        _onChangeMonth(value);
                      },
                    );
                  },
                  child: Text('${tr(date.format('MMMM'))}, ${date.year}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      )),
                ),
                Spacer(),
                SIconButton(
                    onTap: () {
                      _onChangeMonth(DateTime(date.year, date.month + 1, 1));
                      widget.onChangeMonth?.call(date);
                    },
                    size: 18,
                    svgPath: 'assets/images/svg/chevron-right.svg'),
              ],
            ),
            SizedBox(height: Spacing.small),
            if (!widget.isShowFull)
              Row(
                children: [
                  _CalendarItem(
                    isSelected: true,
                  ),
                  _CalendarItem(),
                  _CalendarItem(),
                  _CalendarItem(),
                  _CalendarItem(),
                  _CalendarItem(),
                  _CalendarItem(),
                ],
              ),
            // SizedBox(height: Spacing.small),
            if (widget.isShowFull)
              GridView.count(
                childAspectRatio: 1,
                shrinkWrap: true,
                crossAxisCount: 7,
                // mainAxisSpacing: Spacing.small,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DayOfWeek(day: tr('Mon')),
                  DayOfWeek(day: tr('Tue')),
                  DayOfWeek(day: tr('Wed')),
                  DayOfWeek(day: tr('Thu')),
                  DayOfWeek(day: tr('Fri')),
                  DayOfWeek(day: tr('Sat')),
                  DayOfWeek(day: tr('Sun')),
                  ...List.generate(numOfDayOffset, (index) {
                    return SizedBox.shrink();
                  }),
                  ...List.generate(
                    numOfDaysInMonth,
                    (index) {
                      return widget.itemBuilder?.call(
                              DateTime(date.year, date.month, index + 1)) ??
                          Day(
                            day: '${index + 1}',
                            isinRange: index >= 1 && index <= 20,
                            isFirst: index == 1,
                            isLast: index == 20,
                          );
                    },
                  ),
                ],
              ),
            if (widget.after != null) widget.after!,
          ],
        ));
  }
}

class _CalendarItem extends StatelessWidget {
  const _CalendarItem({
    super.key,
    this.isSelected = false,
  });
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    final primaryColor = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: Container(
          padding: EdgeInsets.all(Spacing.small),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Spacing.small),
            color: isSelected ? primaryColor.withAlpha(100) : null,
          ),
          child: Column(
            spacing: 4,
            children: [
              Text("Mon",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.white.withAlpha(150)
                        : Colors.black.withAlpha(150),
                    fontWeight: FontWeight.w400,
                  )),
              Text("23",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }
}

class DayOfWeek extends StatelessWidget {
  const DayOfWeek({super.key, required this.day});
  final String day;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Center(
      child: Text(day,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode
                ? Colors.white.withAlpha(150)
                : Colors.black.withAlpha(150),
            fontWeight: FontWeight.w400,
          )),
    );
  }
}

class Day extends StatelessWidget {
  const Day(
      {super.key,
      required this.day,
      this.isinRange = false,
      this.isFirst = false,
      this.isLast = false});
  final String day;
  final bool isinRange;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.all(Spacing.small),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? Radius.circular(999) : Radius.zero,
            right: isLast ? Radius.circular(999) : Radius.zero,
          ),
          color: isinRange ? primaryColor.withAlpha(150) : null,
        ),
        child: Center(
          child: Text(day,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
