import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class Schedule {
//   final DateTime from;
//   final DateTime to;
//   final bool monday;
//   final bool tuesday;
//   final bool wednesday;
//   final bool thursday;
//   final bool friday;
//   final bool saturday;
//   final bool sunday;

//   Schedule({
//     required this.from,
//     required this.to,
//     required this.monday,
//     required this.tuesday,
//     required this.wednesday,
//     required this.thursday,
//     required this.friday,
//     required this.saturday,
//     required this.sunday,
//   });
// }

const _repeatItems = [
  "Every Monday",
  "Every Tuesday",
  "Every Wednesday",
  "Every Thursday",
  "Every Friday",
  "Every Saturday",
  "Every Sunday",
];

const _acronym = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

class ScheduleItem {
  String id;
  int from;
  int to;
  Map<int, bool> repeat;
  bool isActive;

  ScheduleItem({
    required this.id,
    required this.from,
    required this.to,
    required this.repeat,
    this.isActive = true,
  }) {
    if (this.to < this.from) {
      final temp = this.to;
      this.to = this.from;
      this.from = temp;
    }
  }
}

String _getAcronym(Map<int, bool> selected) {
  var selectedItems = selected.entries.where((e) => e.value).map((e) => e.key);
  selectedItems = selectedItems.toList()..sort();

  if (selectedItems.isEmpty) return "No repeat";
  if (selectedItems.length == 7) return "Every day";

  return 'Every ${selectedItems.map((e) => _acronym[e]).join(", ")}';
}

class SettingScheduleNotificationScreen extends StatefulWidget {
  @override
  State<SettingScheduleNotificationScreen> createState() =>
      _SettingScheduleNotificationScreenState();

  // final Future<List<ScheduleItem>> Function() getSchedule;

  const SettingScheduleNotificationScreen({
    super.key,
    // required this.getSchedule,
  });
}

class _SettingScheduleNotificationScreenState
    extends State<SettingScheduleNotificationScreen> {
  List<ScheduleItem> schedules = [];

  @override
  void initState() {
    super.initState();
    // NotificationService.getSchedule().then((value) {
    //   setState(() {
    //     schedules = value;
    //   });
    // });
  }

  // void _addSchedule() async {
  //   final result = await Modal.showBottomSheet(
  //     context: context,
  //     size: 0.85,
  //     builder: (context, scrollController) => _AddOrEditScreen(),
  //   );
  //   if (result != null) {
  //     setState(() {
  //       schedules.add(result);
  //     });
  //   }
  // }

  void _action(ScheduleItem? oldSchedule) async {
    final result = await Modal.showBottomSheet(
      context: context,
      initialSize: 0.85,
      builder: (context, scrollController) => _AddOrEditScreen(
        schedule: oldSchedule,
      ),
    );

    if (result != null && result is Map) {
      switch (result['action']) {
        case 'add':
          if (result['schedule'] is ScheduleItem) {
            final schedule = result['schedule'] as ScheduleItem;
            setState(() {
              schedules.add(schedule);
            });
          }
          break;
        case 'edit':
          if (result['schedule'] is ScheduleItem) {
            final schedule = result['schedule'] as ScheduleItem;
            setState(() {
              schedules = schedules
                  .map((e) => e.id == schedule.id ? schedule : e)
                  .toList();
            });
          }
          break;
        case 'delete':
          if (result['schedule'] is ScheduleItem) {
            final schedule = result['schedule'] as ScheduleItem;
            setState(() {
              schedules.removeWhere((e) => e.id == schedule.id);
            });
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Scaffold(
      appBar: SAppBar(
        leading: SIconBack(),
        // padding: const EdgeInsets.only(right: 40),
        title: Text(
          tr("Push notification schedule"),
          textAlign: TextAlign.center,
        ),
        actions: [
          SIconButton(
            // svgPath: 'assets/images/svg/plus.svg',
            child: Icon(CupertinoIcons.plus),
            onTap: () => _action(null),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Spacing.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
            child: Text(
              tr("We will send push notification at the following times:"),
              style: TextStyle(
                color: onSurface.withAlpha(100),
              ),
            ),
          ),
          if (schedules.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.large),
                child: Center(
                  child: Text(
                    tr("You need to add at least one schedule, leave empty to receive push notification any time."),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onSurface.withAlpha(100),
                    ),
                  ),
                ),
              ),
            ),
          if (schedules.isNotEmpty)
            ListView.builder(
              itemCount: schedules.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _ScheduleItem(
                schedule: schedules[index],
                onTap: () => _action(schedules[index]),
                onChangeActive: (active) {
                  setState(() {
                    schedules[index].isActive = active;
                  });
                  // NotificationService.addOrEdit(
                  //   NotificationScheduleItem.fromSchedule(schedules[index]),
                  // );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    super.key,
    required this.schedule,
    this.onTap,
    required this.onChangeActive,
  });
  final ScheduleItem schedule;
  final Function()? onTap;
  final Function(bool active) onChangeActive;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final fromHour = schedule.from ~/ 60;
    final fromMinute = schedule.from % 60;
    final toHour = schedule.to ~/ 60;
    final toMinute = schedule.to % 60;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Spacing.medium),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(Spacing.medium),
          border: Border(
            bottom: BorderSide(color: onSurface.withAlpha(10)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: schedule.isActive ? 1 : 0.4,
                    child: Text(
                      "${fromHour.toString().padLeft(2, '0')}:${fromMinute.toString().padLeft(2, '0')} - ${toHour.toString().padLeft(2, '0')}:${toMinute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                SSwitch(
                  value: schedule.isActive,
                  onChanged: (value) {
                    onChangeActive(value);
                  },
                  height: 25,
                  width: 40,
                )
              ],
            ),
            Opacity(
              opacity: schedule.isActive ? 1 : 0.4,
              child: Text(_getAcronym(schedule.repeat)),
            )
          ],
        ),
      ),
    );
  }
}

class _AddOrEditScreen extends StatefulWidget {
  const _AddOrEditScreen({
    super.key,
    this.schedule,
  });
  final ScheduleItem? schedule;

  @override
  State<_AddOrEditScreen> createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<_AddOrEditScreen> {
  Map<int, bool> _selected = {
    0: true,
    1: true,
    2: true,
    3: true,
    4: true,
    5: true,
    6: true,
  };
  int from = 7 * 60;
  int to = 19 * 60;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _selected = widget.schedule!.repeat;
      from = widget.schedule!.from;
      to = widget.schedule!.to;
    }
  }

  void _save() async {
    if (widget.schedule != null) {
      // final result = await NotificationService.addOrEdit(
      //   NotificationScheduleItem.fromSchedule(ScheduleItem(
      //     id: widget.schedule!.id,
      //     from: from,
      //     to: to,
      //     repeat: _selected,
      //   )),
      // );
      // Get.back(result: {
      //   'action': 'edit',
      //   'schedule': result,
      // });
    } else {
      final schedule = ScheduleItem(
        id: uniqueID(),
        from: from,
        to: to,
        repeat: _selected,
      );
      // final result = await NotificationService.addOrEdit(
      //   NotificationScheduleItem.fromSchedule(schedule),
      // );
      // Get.back(result: {
      //   'action': 'add',
      //   'schedule': result,
      // });
    }

    // Get.back(
    //     result: ScheduleItem(
    //   id: uniqueID(),
    //   from: from,
    //   to: to,
    //   repeat: _selected,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Navigator(
      onGenerateRoute: (setting) {
        return MaterialPageRoute(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.medium, vertical: Spacing.small),
            child: Column(
              children: [
                _AppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      tr("Cancel"),
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(tr("Add schedule")),
                  trailing: GestureDetector(
                    onTap: _save,
                    child: Text(
                      tr("Save"),
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Spacing.large),
                Row(
                  children: [
                    Expanded(
                      child: CustomTimePicker(
                        time: from,
                        onChanged: (hour, minute) {
                          setState(() {
                            from = hour * 60 + minute;
                          });
                        },
                        // mode: CupertinoTimerPickerMode
                        //     .hm, // hour + minute

                        // initialTimerDuration: Duration(hours: 7),
                        // onTimerDurationChanged: (newDuration) {},
                      ),
                    ),
                    Opacity(opacity: 0.5, child: Text(" - ")),
                    Expanded(
                      child: CustomTimePicker(
                        time: to,
                        onChanged: (hour, minute) {
                          setState(() {
                            to = hour * 60 + minute;
                          });
                        },
                        // mode: CupertinoTimerPickerMode
                        //     .hm, // hour + minute

                        // initialTimerDuration: Duration(hours: 7),
                        // onTimerDurationChanged: (newDuration) {},
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: onSurface.withAlpha(10),
                    borderRadius: BorderRadius.circular(Spacing.small),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => _EditRepeatScreen(
                                selected: _selected,
                                onChange: (value) {
                                  setState(() {
                                    _selected = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(Spacing.medium),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(child: Text(tr("Repeat"))),
                              Row(
                                spacing: Spacing.xSmall,
                                children: [
                                  Text(
                                    _getAcronym(_selected),
                                    style: TextStyle(
                                      color: onSurface.withAlpha(100),
                                    ),
                                  ),
                                  Icon(CupertinoIcons.chevron_right,
                                      size: 16,
                                      color: onSurface.withAlpha(100)),
                                  // SvgPicture.asset(
                                  //   "assets/images/svg/chevron-right.svg",
                                  //   width: 16,
                                  //   height: 16,
                                  //   colorFilter: ColorFilter.mode(
                                  //     onSurface.withAlpha(100),
                                  //     BlendMode.srcIn,
                                  //   ),
                                  // )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: Spacing.large),
                if (widget.schedule != null)
                  SButton(
                    size: SSize.large,
                    bgColor: onSurface.withAlpha(10),
                    child: Text(tr("Delete this time slot"),
                        style: TextStyle(
                          color: Colors.red,
                        )),
                    onTap: () {
                      Get.back(
                        result: {
                          'action': 'delete',
                        },
                      );
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EditRepeatScreen extends StatefulWidget {
  const _EditRepeatScreen({
    super.key,
    required this.selected,
    required this.onChange,
  });
  final Map<int, bool> selected;
  final Function(Map<int, bool>) onChange;

  @override
  State<_EditRepeatScreen> createState() => _EditRepeatScreenState();
}

class _EditRepeatScreenState extends State<_EditRepeatScreen> {
  late Map<int, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.selected};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.colorScheme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final bgColor = isDarkMode
        ? Color(0xFF142127)
        : Theme.of(context).scaffoldBackgroundColor;
    return Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.medium, vertical: Spacing.small),
        child: Column(
          children: [
            _AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    spacing: Spacing.xSmall,
                    children: [
                      Icon(CupertinoIcons.chevron_left,
                          size: 16, color: Colors.orange),
                      // SvgPicture.asset(
                      //   "assets/images/svg/chevron-left.svg",
                      //   width: 16,
                      //   height: 16,
                      //   colorFilter: ColorFilter.mode(
                      //     Colors.orange,
                      //     BlendMode.srcIn,
                      //   ),
                      // ),
                      Text(
                        tr("Back"),
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(tr("Repeat")),
            ),
            SizedBox(height: Spacing.large * 2),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.small),
                color: onSurface.withAlpha(10),
              ),
              child: Column(
                children: List.generate(_repeatItems.length, (index) {
                  return _RepeatItem(
                    title: _repeatItems[index],
                    selected: _selected[index] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _selected[index] = value;
                      });
                      widget.onChange(_selected);
                    },
                  );
                }),
              ),
            )
          ],
        ));
  }
}

class _RepeatItem extends StatelessWidget {
  const _RepeatItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
  });
  final String title;
  final bool selected;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return OpacityTap(
      onTap: () {
        onChanged(!selected);
      },
      child: Container(
          padding: EdgeInsets.all(Spacing.medium),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: onSurface.withAlpha(10)),
          )),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Opacity(
                opacity: selected ? 1 : 0,
                child: Icon(CupertinoIcons.check_mark_circled_solid,
                    size: 20, color: Colors.orange),
              ),
              // SvgPicture.asset(
              //   "assets/images/svg/check.svg",
              //   width: 20,
              //   height: 20,
              //   colorFilter: ColorFilter.mode(
              //     Colors.orange,
              //     BlendMode.srcIn,
              //   ),
              // )
            ],
          )),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Stack(
        children: [
          if (leading != null) Positioned(left: 0, child: leading!),
          Center(
            child: DefaultTextStyle(
              child: title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null) Positioned(right: 0, child: trailing!),
        ],
      ),
    );
  }
}

class CustomTimePicker extends StatefulWidget {
  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();

  final Function(int hour, int minute)? onChanged;
  final int? time;

  const CustomTimePicker({
    super.key,
    this.onChanged,
    this.time,
  });
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int selectedHour = 7;
  int selectedMinute = 0;

  final List<int> hours = List.generate(24, (i) => i);
  final List<int> minutes = List.generate(60, (i) => i);

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      selectedHour = widget.time! ~/ 60;
      selectedMinute = widget.time! % 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour Picker
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: selectedHour),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = hours[index];
                });
                widget.onChanged?.call(selectedHour, selectedMinute);
              },
              children: hours
                  .map((h) => Center(child: Text(h.toString().padLeft(2, '0'))))
                  .toList(),
            ),
          ),
          // Minute Picker
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: selectedMinute),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = minutes[index];
                });
                widget.onChanged?.call(selectedHour, selectedMinute);
              },
              children: minutes
                  .map((m) => Center(child: Text(m.toString())))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
