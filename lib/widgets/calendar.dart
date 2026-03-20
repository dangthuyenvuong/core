import 'dart:async';

import 'package:core/core.dart';
import 'package:core/extensions/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

enum SCalendarShowMode { week, month, year }

var _titleFormat = {
  SCalendarShowMode.week: "'Week' w, MMM, yyyy",
  SCalendarShowMode.month: "MMM, yyyy",
  SCalendarShowMode.year: "yyyy",
};

class SCalendar extends StatefulWidget {
  const SCalendar({
    super.key,
    // this.title,
    this.onTap,
    this.itemBuilder,
    this.after,
    this.onChangeMonth,
    this.padding,
    this.buildItemWeek,
    this.onChangeWeek,
    this.onChangeYear,
    this.buildItemMonth,
    this.buildItemYear,
    this.mode = SCalendarShowMode.week,
    this.isAllowChangeDate = true,
    this.weekItemHeight = 90,
    this.showTitle = true,
  });
  final SCalendarShowMode mode;
  final Widget? after;
  final bool showTitle;

  // final Widget? title;
  final Function(DateTime)? onTap;
  final Function(DateTime)? itemBuilder;
  final Function(DateTime)? onChangeMonth;
  final Function(DateTime)? onChangeWeek;
  final Function(DateTime)? onChangeYear;
  final Function(DateTime)? buildItemWeek;
  final Function(DateTime)? buildItemMonth;
  final Function(DateTime)? buildItemYear;
  final EdgeInsets? padding;
  final bool isAllowChangeDate;
  final double? weekItemHeight;

  @override
  State<SCalendar> createState() => _SCalendarState();
}

final toDay = DateTime.now();
final _startDate = DateTime(2000, 1, 1).startOfWeek();

class _SCalendarState extends State<SCalendar> {
  late DateTime date;
  late int numOfDaysInMonth;
  late int numOfDayOffset;
  GlobalKey<_CalendarWeekState> calendarWeekKey = GlobalKey();
  GlobalKey<_CalendarMonthState> calendarMonthKey = GlobalKey();

  late DateTime from;
  late DateTime to;
  final ScrollController scrollController = ScrollController();
  late int totalItemWeek;
  late double _w;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onChangeMonth(DateTime.now());

    resetDate(toDay);

    // from = toDay.startOfWeek();
    // to = toDay.endOfWeek();
    // date = from;

    totalItemWeek = toDay.difference(_startDate).inDays ~/ 7 + 1;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _w = MediaQuery.of(context).size.width - Spacing.medium * 2;
    //   scrollController.jumpTo(totalItemWeek * _w);
    // });
  }

  void resetDate(DateTime selectDate) {
    from = selectDate.startOfWeek();
    to = selectDate.endOfWeek();
    date = from;
    calendarWeekKey.currentState?.resetDate(date);
  }

  void _onChangeMonth(DateTime date) {
    setState(() {
      this.date = date;
      numOfDaysInMonth = DateTime(date.year, date.month + 1, 0).day;
      numOfDayOffset = DateTime(date.year, date.month, 1).weekday - 1;
    });
  }

  void _onChangeWeek(int days) {
    setState(() {
      from = from.add(Duration(days: days));
      to = to.add(Duration(days: days));
      date = from;
    });
    widget.onChangeWeek?.call(date);
  }

  void _onChangeYear(DateTime date) {
    setState(() {
      from = date.startOfWeek();
      to = date.endOfWeek();
      this.date = date;
    });
  }

  CupertinoDatePickerMode _getMode() {
    if (widget.mode == SCalendarShowMode.month) {
      return CupertinoDatePickerMode.monthYear;
    }

    if (widget.mode == SCalendarShowMode.year) {
      return CupertinoDatePickerMode.monthYear;
    }

    return CupertinoDatePickerMode.date;
  }

  @override
  Widget build(BuildContext context) {
    final bg = getBgMode(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isAllowChangeDate)
                  SIconButton(
                    onTap: () {
                      if (widget.mode == SCalendarShowMode.month) {
                        calendarMonthKey.currentState?.previousMonth();
                        _onChangeMonth(DateTime(date.year, date.month - 1, 1));
                        widget.onChangeMonth?.call(date);
                      } else if (widget.mode == SCalendarShowMode.year) {
                        _onChangeYear(DateTime(date.year - 1, 1, 1));
                        widget.onChangeYear?.call(date);
                      } else {
                        calendarWeekKey.currentState?.previousWeek();
                        _onChangeWeek(-7);
                        widget.onChangeWeek?.call(date);
                      }
                    },
                    child: Icon(Icons.chevron_left),
                    // package: 'core',
                    // svgPath: 'assets/svg/chevron-left.svg',
                    // size: 18,
                  ),
                Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Cupertino.showDatePicker(
                      context: context,
                      initialDateTime: date,
                      mode: _getMode(),
                      onDateTimeComplete: (value) {
                        _onChangeMonth(value);
                      },
                    );
                  },
                  child:
                      Text('${date.format(_titleFormat[widget.mode] ?? '')}'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          )),
                ),
                Spacer(),
                if (widget.isAllowChangeDate)
                  SIconButton(
                    onTap: () {
                      if (widget.mode == SCalendarShowMode.month) {
                        calendarMonthKey.currentState?.nextMonth();
                        _onChangeMonth(DateTime(date.year, date.month + 1, 1));
                        widget.onChangeMonth?.call(date);
                      } else if (widget.mode == SCalendarShowMode.year) {
                        _onChangeYear(DateTime(date.year + 1, 1, 1));
                        widget.onChangeYear?.call(date);
                      } else {
                        calendarWeekKey.currentState?.nextWeek();
                        _onChangeWeek(7);
                        widget.onChangeWeek?.call(date);
                      }
                    },
                    child: Icon(Icons.chevron_right),
                    // size: 18,
                    // package: 'core',
                    // svgPath: 'assets/svg/chevron-right.svg'
                  ),
              ],
            ),
          ),
        if (widget.mode == SCalendarShowMode.week)
          SizedBox(
            height: widget.weekItemHeight,
            child: _CalendarWeek(
              key: calendarWeekKey,
              buildItem: widget.buildItemWeek,
              date: date,
              onChangeDate: (date) {
                _onChangeWeek(date.difference(from).inDays);
              },
            ),
          ),
        if (widget.mode == SCalendarShowMode.month)
          _CalendarMonth(
            key: calendarMonthKey,
            date: date,
            buildItem: widget.buildItemMonth,
            onChangeMonth: (date) {
              _onChangeMonth(date);
              widget.onChangeMonth?.call(date);
            },
          ),
        if (widget.mode == SCalendarShowMode.year)
          _CalendarYear(date: date, buildItem: widget.buildItemYear),
        if (widget.after != null) widget.after!,
      ],
    );
  }
}

class _CalendarYear extends StatefulWidget {
  const _CalendarYear({
    super.key,
    required this.date,
    required this.buildItem,
  });

  final DateTime date;
  final Function(DateTime)? buildItem;

  @override
  State<_CalendarYear> createState() => _CalendarYearState();
}

class _CalendarYearState extends State<_CalendarYear> {
  late int numOfDaysInYear;
  late int numOfDayOffsetYear;
  GlobalKey globalKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  final double _w = 200;

  @override
  void initState() {
    super.initState();
    numOfDaysInYear = widget.date.numOfDaysInYear;
    numOfDayOffsetYear = widget.date.numOfDayOffsetYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final indexColumn =
          (DateTime(widget.date.year, 1, 1).difference(widget.date).inDays + 1)
                  .abs() ~/
              7;
      scrollController.jumpTo(indexColumn * (_w / 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(bottom: Spacing.small),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: List.generate(12, (index) {
        //       return Text("${index + 1}",
        //           style: TextStyle(
        //             fontSize: 12,
        //             fontWeight: FontWeight.bold,
        //             color: onSurface.withAlpha(100),
        //           ));
        //     }),
        //   ),
        // ),
        SizedBox(
          height: _w,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: Spacing.small),
                      child: Text(daysOfWeek[index].tr,
                          // textAlign: TextAlign.,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: onSurface.withAlpha(100),
                          )),
                    ),
                  );
                }),
              ),
              Expanded(
                child: GridView.builder(
                  key: globalKey,
                  shrinkWrap: true,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    // mainAxisSpacing: 1,
                    // crossAxisSpacing: 1,
                  ),
                  itemCount: numOfDaysInYear + numOfDayOffsetYear,
                  itemBuilder: (context, index) {
                    if (index < numOfDayOffsetYear) {
                      return SizedBox.shrink();
                    }

                    final date = DateTime(
                        widget.date.year, 1, index - numOfDayOffsetYear + 1);

                    if (widget.buildItem != null) {
                      return Container(child: widget.buildItem!(date));
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        // LayoutBuilder(builder: (context, constraints) {
        //   final width = constraints.maxWidth;
        //   final _row = (365 / 7).ceil();

        //   return SizedBox(
        //     height: (width / _row) * 7 - 1,
        //     child: GridView.builder(
        //       shrinkWrap: true,
        //       // physics: const NeverScrollableScrollPhysics(),
        //       scrollDirection: Axis.horizontal,
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 7,
        //         mainAxisSpacing: 1,
        //         crossAxisSpacing: 1,
        //         // childAspectRatio: 1.5,
        //         // mainAxisSpacing: Spacing.medium,
        //         // crossAxisSpacing: Spacing.medium,
        //       ),
        //       itemCount: 365,
        //       itemBuilder: (context, index) {
        //         // return Text("${index + 1}");
        //         return buildItem?.call(DateTime(date.year, 1, 1)) ??
        //             Container(
        //               decoration: BoxDecoration(
        //                 color: Colors.green,
        //                 borderRadius: BorderRadius.circular(2),
        //                 border: Border.all(
        //                   color: Colors.green,
        //                   width: 1,
        //                 ),
        //               ),
        //             );
        //       },
        //     ),
        //   );
        // }),
      ],
    );
  }
}

class _CalendarMonth extends StatefulWidget {
  const _CalendarMonth({
    super.key,
    required this.buildItem,
    required this.date,
    required this.onChangeMonth,
  });

  final DateTime date;
  final Function(DateTime)? buildItem;
  final Function(DateTime) onChangeMonth;

  @override
  State<_CalendarMonth> createState() => _CalendarMonthState();
}

class _CalendarMonthState extends State<_CalendarMonth> {
  // late int numOfDaysInMonth;
  // late int numOfDayOffset;
  final PageController scrollController = PageController(initialPage: 1);
  late DateTime _date;
  Timer? _debounce;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    scrollController.addListener(() {
      _debounce?.cancel();
      if (isLoading && scrollController.page!.isInt()) {
        listener();
      }
    });
  }

  void listener() {
    isLoading = false;
    final page = scrollController.page!;
    setState(() {
      _date = _date.addMonths(page.toInt() - 1);
    });
    scrollController.jumpToPage(1);
    widget.onChangeMonth(_date);
    Future.delayed(Duration(milliseconds: 1), () {
      isLoading = true;
    });
  }

  void previousMonth() {
    scrollController.animateToPage(scrollController.page!.toInt() - 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void nextMonth() {
    scrollController.animateToPage(scrollController.page!.toInt() + 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return SizedBox(
      height: 360,
      child: PageView(
        controller: scrollController,
        onPageChanged: (index) {
          // if (index == 1) return;
          // setState(() {
          //   _date = _date.addMonths(index - 1);
          //   scrollController.jumpToPage(1);
          // });
          // widget.onChangeMonth(_date);
        },
        children: List.generate(3, (indexMonth) {
          // if (index == 0) {
          //   return Container();
          // }
          // if (index == 2) {
          //   return Container();
          // }

          // final date = widget.date.add(Duration(days: (index - 1) * 30));

          final date =
              DateTime(_date.year, _date.month + indexMonth, 0).endOfMonth();

          final numOfDaysInMonth = date.numOfDaysInMonth;
          final numOfDayOffset = date.numOfDayOffset;

          return GridView.count(
            padding: EdgeInsets.zero,
            childAspectRatio: 1,
            shrinkWrap: true,
            crossAxisCount: 7,
            // mainAxisSpacing: Spacing.small,
            // addAutomaticKeepAlives: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              DayOfWeek(day: 'Mon'.tr),
              DayOfWeek(day: 'Tue'.tr),
              DayOfWeek(day: 'Wed'.tr),
              DayOfWeek(day: 'Thu'.tr),
              DayOfWeek(day: 'Fri'.tr),
              DayOfWeek(day: 'Sat'.tr),
              DayOfWeek(day: 'Sun'.tr),
              ...List.generate(numOfDayOffset, (index) {
                return SizedBox.shrink();
              }),
              ...List.generate(
                numOfDaysInMonth,
                (index) {
                  final current = DateTime(date.year, date.month, index + 1);
                  final isToday = toDay.isAtSameDay(current);
                  if (indexMonth == 1) {
                    return widget.buildItem?.call(current) ??
                        Day(
                          day: '${index + 1}',
                          isinRange: index >= 1 && index <= 20,
                          isFirst: index == 1,
                          isLast: index == 20,
                        );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      padding: EdgeInsets.all(Spacing.small),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Spacing.small),
                        color: isToday ? onSurface : onSurface.withAlpha(10),
                      ),
                      alignment: Alignment.topCenter,
                      child: Text('${index + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isToday ? bg : onSurface)),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CalendarWeek extends StatefulWidget {
  const _CalendarWeek({
    super.key,
    // required this.scrollController,
    // required this.totalItemWeek,
    this.buildItem,
    required this.date,
    required this.onChangeDate,
  });
  final DateTime date;

  final Function(DateTime)? buildItem;
  final Function(DateTime) onChangeDate;

  @override
  State<_CalendarWeek> createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<_CalendarWeek> {
  final PageController scrollController = PageController(initialPage: 1);
  Timer? _debounce;
  late DateTime _date;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    scrollController.addListener(() {
      _debounce?.cancel();
      if (isLoading && scrollController.page!.isInt()) {
        listener();
      }
    });
  }

  void resetDate(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  void listener() {
    isLoading = false;
    final page = scrollController.page!;
    setState(() {
      _date = _date.add(Duration(days: (page.toInt() - 1) * 7));
    });
    scrollController.jumpToPage(1);
    widget.onChangeDate(_date);
    Future.delayed(Duration(milliseconds: 1), () {
      isLoading = true;
    });
  }

  void previousWeek() {
    scrollController.animateToPage(scrollController.page!.toInt() - 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void nextWeek() {
    scrollController.animateToPage(scrollController.page!.toInt() + 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(builder: (context, constraints) {
    //   final _w = constraints.maxWidth / 7;
    //   return SizedBox(
    //     child: ListView.builder(
    //       padding: EdgeInsets.zero,
    //       itemExtent: _w,
    //       shrinkWrap: true,
    //       itemCount: 3 * 7,
    //       scrollDirection: Axis.horizontal,
    //       itemBuilder: (context, index) {
    //         final date = _date.add(Duration(days: index));
    //         return IntrinsicHeight(
    //             child: widget.buildItem?.call(date) ?? _CalendarItem());
    //       },
    //     ),
    //   );
    // });

    return PageView(
      // semanticChildCount: 2,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      // shrinkWrap: true,
      // padding: EdgeInsets.zero,
      // physics: PageScrollPhysics(),
      children: List.generate(3, (indexWeek) {
        return Container(
          width: MediaQuery.of(context).size.width - Spacing.medium * 2,
          child: Row(
              children: List.generate(7, (indexDay) {
            final day =
                _date.add(Duration(days: (indexWeek - 1) * 7 + indexDay));
            return Expanded(
                child: widget.buildItem?.call(day) ?? _CalendarItem());
          })),
        );
      }),
    );
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
    return Container(
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
        ));
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

class ECalendar extends StatefulWidget {
  const ECalendar({
    super.key,
    this.buildItemWeek,
    this.buildItemMonth,
    this.buildItemYear,
    this.mode = SCalendarShowMode.week,
    this.isAllowChangeDate = true,
    this.after,
    this.weekItemHeight,
    this.showTitle = true,
    this.onChangeDate,
    this.selectedDate,
    this.onChangeWeek,
  });
  final Widget Function(DateTime)? buildItemWeek;
  final Widget Function(DateTime)? buildItemMonth;
  final Widget Function(DateTime)? buildItemYear;
  final SCalendarShowMode mode;
  final bool isAllowChangeDate;
  final Widget? after;
  final double? weekItemHeight;
  final bool showTitle;
  final Function(DateTime)? onChangeDate;
  final DateTime? selectedDate;
  final Function(DateTime)? onChangeWeek;
  @override
  State<ECalendar> createState() => ECalendarState();
}

class ECalendarState extends State<ECalendar> {
  // DateTime selectedDate = DateTime.now();
  final GlobalKey<_SCalendarState> calendarWeekKey =
      GlobalKey<_SCalendarState>();

  void resetDate(DateTime date) {
    calendarWeekKey.currentState?.resetDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = getOnSurface(context);
    final bgMode = getBgMode(context);
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return SCalendar(
      key: calendarWeekKey,
      mode: widget.mode,
      isAllowChangeDate: widget.isAllowChangeDate,
      after: widget.after,
      weekItemHeight: widget.weekItemHeight,
      showTitle: widget.showTitle,
      onChangeWeek: widget.onChangeWeek,
      buildItemWeek: (date) {
        return widget.buildItemWeek!.call(date);
        // final isToday = widget.selectedDate?.isAtSameDay(date) ?? false;
        // final bgColor =
        //     DateTime.now().compareTo(date) > 0 ? Colors.green : Colors.yellow;
        // return GestureDetector(
        //   onTap: () {
        //     // setState(() {
        //     //   selectedDate = date;
        //     // });
        //     widget.onChangeDate?.call(date);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(right: Spacing.xSmall),
        //     padding: EdgeInsets.symmetric(
        //       horizontal: Spacing.xSmall,
        //       vertical: Spacing.small,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(Spacing.medium),
        //       color: isToday ? onSurface : bgMode,
        //       // border: Border.all(
        //       //   color: isToday
        //       //       ? Colors.transparent
        //       //       : onSurface.withAlpha(isToday ? 255 : 50),
        //       // ),
        //     ),
        //     child: DefaultTextStyle(
        //       style: TextStyle(color: isToday ? bg : onSurface),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Opacity(
        //             opacity: 0.3,
        //             child: Text(
        //               date.format('EEE'),
        //               style: TextStyle(
        //                 fontSize: 12,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //           ),
        //           SizedBox(height: Spacing.xSmall),
        //           Text(
        //             date.day.toString(),
        //             style: TextStyle(
        //               fontSize: 12,
        //               fontWeight: FontWeight.w600,
        //               // color: onSurface,
        //             ),
        //           ),
        //           if (widget.buildItemWeek != null)
        //             widget.buildItemWeek!.call(date),

        //           // Container(
        //           //   width: 8,
        //           //   height: 8,
        //           //   margin: EdgeInsets.only(top: Spacing.small),
        //           //   decoration: BoxDecoration(
        //           //     shape: BoxShape.circle,
        //           //     color: date.weekday == 7 ? onSurface : bgColor,
        //           //   ),
        //           // ),
        //           // Text(date.weekday.toString()),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
      buildItemMonth: (date) {
        final isToday = widget.selectedDate?.isAtSameDay(date) ?? false;

        return GestureDetector(
          onTap: () {
            widget.onChangeDate?.call(date);
            // setState(() {
            //   selectedDate = date;
            // });
          },
          child: DefaultTextStyle(
            style: TextStyle(color: isToday ? bg : onSurface),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isToday ? onSurface : bgMode,
                  borderRadius: BorderRadius.circular(Spacing.small),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // spacing: Spacing.xSmall,
                  children: [
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.buildItemMonth?.call(date) ?? Container(),
                    // Container(
                    //   width: 8,
                    //   height: 8,
                    //   margin: EdgeInsets.only(top: Spacing.small),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.greenAccent,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      buildItemYear: (date) {
        final isToday = widget.selectedDate?.isAtSameDay(date) ?? false;
        return GestureDetector(
          onTap: () {
            widget.onChangeDate?.call(date);
            // setState(() {
            //   selectedDate = date;
            // });
          },
          child: Container(
            margin: EdgeInsets.all(01),
            decoration: BoxDecoration(
              color: isToday ? onSurface : onSurface.withAlpha(10),
              borderRadius: BorderRadius.circular(Spacing.small),
            ),
            alignment: Alignment.center,
            // child: Text(
            //   date.format('dd/M'),
            //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            // ),
          ),
        );
      },
    );
  }
}
