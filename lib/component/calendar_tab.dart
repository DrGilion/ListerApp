import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  List<ListerItem> _items = [];
  final ValueNotifier<List<ListerItem>> _selectedItems = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _loadItemsForRange(
              context, _focusedDay.copyWith(day: 1), _focusedDay.copyWith(month: _focusedDay.month + 1, day: 0))
          .then((value) {
        _selectedItems.value = _getEventsForDay(_selectedDay);
      });
    });
  }

  @override
  void dispose() {
    _selectedItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).calendar),
      ),
      body: Column(
        children: [
          TableCalendar<ListerItem>(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2100, 1, 1),
            focusedDay: _focusedDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: {CalendarFormat.month: Translations.of(context).month},
            calendarStyle: const CalendarStyle(markersAlignment: Alignment.bottomRight),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                if ([DateTime.saturday, DateTime.sunday].contains(day.weekday)) {
                  return Center(
                    child: Text(
                      DateFormat.E().format(day),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return null;
              },
              markerBuilder: (context, date, items) {
                return items.isNotEmpty ? Badge(backgroundColor: Colors.lightBlue, label: Text(items.length.toString())) : null;
              }
            ),
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                _selectedItems.value = _getEventsForDay(selectedDay);
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
              _selectedDay = focusedDay;
              _loadItemsForRange(
                      context, focusedDay.copyWith(day: 1), focusedDay.copyWith(month: focusedDay.month + 1, day: 0))
                  .then((value) {
                _selectedItems.value = _getEventsForDay(_selectedDay);
              });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<ListerItem>>(
              valueListenable: _selectedItems,
              builder: (context, value, _) {
                return ListView.separated(
                  itemCount: value.length,
                  separatorBuilder: (context, idx) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListerItemTile(key: ValueKey(value[index].id), listItem: value[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _loadItemsForRange(BuildContext context, DateTime from, DateTime to) {
    return PersistenceService.of(context).getItemsByDates(from, to).then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).lists_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          _items = r;
        });
      });
    });
  }

  List<ListerItem> _getEventsForDay(DateTime day) {
    return _items.where((element) => isSameDay(element.createdOn, day)).toList();
  }
}
