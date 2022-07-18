import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/task_calendar/task_calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TaskCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueSetter<DateTime>? onSelectDate;

  const TaskCalendar({Key? key, this.initialDate, this.onSelectDate}) : super(key: key);

  @override
  State<TaskCalendar> createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {

  DateTime date = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      date = widget.initialDate ?? DateTime.now();
      selectedDate = widget.initialDate ?? DateTime.now();
    });
  }

  Widget buildHeader(BuildContext context) {
    final value = DateFormat("MMM y").format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          key: const Key("textMonth"),
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        Row(
          children: [
            GestureDetector(
              key: const Key("buttonPrevious"),
              onTap: () {
                setState(() {
                  date = DateTime(date.year, date.month - 1, date.day);
                });
              },
              child: SvgPicture.asset(
                CustomIcons.chevronLeft,
                key: const Key("iconChevronLeft"),
                height: 24,
                width: 24
              )
            ),
            const SizedBox(width: 16),
            GestureDetector(
              key: const Key("buttonNext"),
              onTap: () {
                setState(() {
                  date = DateTime(date.year, date.month + 1, date.day);
                });
              },
              child: SvgPicture.asset(
                CustomIcons.chevronRight,
                key: const Key("iconChevronRight"),
                height: 24,
                width: 24
              )
            ),
          ],
        )
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final firstWeekday = DateTime(date.year, date.month, 1).weekday;
    final lastDay = DateTime(date.year, date.month + 1, 0).day;

    // Get some dates from previous month
    List<TaskCalendarModel> prevDays = [];
    if (firstWeekday < 7) { // Calendar starts from sunday where sunday is 7th day, so that we can't substract the day because sunday is the first left date on the calendar
      prevDays = List<int>.generate(firstWeekday, (index) => index + 1).map((day) {
        final raw = DateTime(date.year, date.month, 1).subtract(Duration(days: day));
        return TaskCalendarModel(label: raw.day.toString(), value: raw, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5));
      }).toList().reversed.toList();
    }

    // Get some dates from displayed/current month
    List<TaskCalendarModel> currentDays = List<int>.generate(lastDay, (index) => index + 1).map((day) {
      final raw = DateTime(date.year, date.month, day);
      return TaskCalendarModel(label: raw.day.toString(), value: raw, color: Theme.of(context).colorScheme.onBackground);
    }).toList();

    // Get some date from next month where 42 is taken from the number of days that should be displayed in each month
    List<TaskCalendarModel> nextDays = List<int>.generate(42 - (prevDays.length + currentDays.length), (index) => index + 1).map((day) {
      final raw = DateTime(date.year, date.month + 1, 0).add(Duration(days: day));
      return TaskCalendarModel(label: raw.day.toString(), value: raw, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5));
    }).toList();

    // Get Sun, Mon, Tue, Wed, Thu, Fri, Sat 
    List<DateTime> firstWeekDate = [...prevDays.map((item) => item.value!), ...currentDays.map((item) => item.value!)].take(7).toList();
    List<TaskCalendarModel> abbrNameOfWeekday = firstWeekDate.map((item) {
      return TaskCalendarModel(label: DateFormat("E").format(item), color: Theme.of(context).colorScheme.onBackground);
    }).toList();

    List<TaskCalendarModel> combined = [
      ...abbrNameOfWeekday,
      ...prevDays,
      ...currentDays,
      ... nextDays
    ];

    Size size = MediaQuery.of(context).size;

    return Wrap(
      children: combined.map((item) {

        if (item.value == null) {
          return SizedBox(
            width: size.width / 7,
            child: Center(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: item.color
                ),
              ),
            ),
          );
        }

        final composedInitialDate = widget.initialDate ?? DateTime.now();
        final isNow = DateFormat("y-M-d").format(composedInitialDate) == DateFormat("y-M-d").format(item.value!);
        final isSelected = DateFormat("y-M-d").format(selectedDate) == DateFormat("y-M-d").format(item.value!);

        return GestureDetector(
          key: Key("button${DateFormat("yyyyMMdd").format(item.value!)}"),
          onTap: () {
            final currentMonth = int.parse(DateFormat("yyyyMM").format(date));
            final itemMonth = int.parse(DateFormat("yyyyMM").format(item.value!));

            if (widget.onSelectDate != null) {
              widget.onSelectDate!(item.value!);
            }

            if (itemMonth < currentMonth) {
              setState(() {
                selectedDate = item.value!;
                date = DateTime(date.year, date.month - 1, date.day);
              });
              return;
            }

            if (itemMonth > currentMonth) {
              setState(() {
                selectedDate = item.value!;
                date = DateTime(date.year, date.month + 1, date.day);
              });
              return;
            }

            setState(() {
              selectedDate = item.value!;
            });
          },
          child: SizedBox(
            height: size.width / 7,
            width: size.width / 7,
            child: Center(
              child: Container(
                key: Key("container${DateFormat("yyyyMMdd").format(item.value!)}"),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNow ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent
                  )
                ),
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isNow ? Theme.of(context).colorScheme.onPrimary : item.color
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(context),
        const SizedBox(height: 32),
        buildBody(context)
      ],
    );
  }
}