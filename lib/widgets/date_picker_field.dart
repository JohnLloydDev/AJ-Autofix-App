import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
  late DateTime _startOfMonth;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _startOfMonth = _getStartOfMonth(widget.selectedDate);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to today's date at the start of the scrollable view
  void _scrollToToday() {
    DateTime today = DateTime.now();
    int daysDifference = today.difference(_startOfMonth).inDays;
    double scrollPosition = daysDifference * 68.0; // Approximate width of each date tile
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  DateTime _getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  List<DateTime> _getMonthDays(DateTime startOfMonth) {
    int daysInMonth = DateUtils.getDaysInMonth(startOfMonth.year, startOfMonth.month);
    return List.generate(daysInMonth, (index) => startOfMonth.add(Duration(days: index)));
  }

  Future<void> _showFullCalendar(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 110, 136, 161),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 110, 136, 161),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateSelected(picked);
      setState(() {
        _startOfMonth = _getStartOfMonth(picked);
      });
      _scrollToToday();  // Ensure that the list scrolls to today or the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthDays = _getMonthDays(_startOfMonth);
    DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  DateFormat('MMMM dd, yyyy').format(widget.selectedDate),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today,
                  color: Color.fromARGB(255, 110, 136, 161)),
              onPressed: () {
                _showFullCalendar(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade200,
          ),
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: monthDays.length,
            itemBuilder: (context, index) {
              DateTime date = monthDays[index];
              bool isSelected = date.day == widget.selectedDate.day &&
                  date.month == widget.selectedDate.month &&
                  date.year == widget.selectedDate.year;

              bool isPast = date.isBefore(today);

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        widget.onDateSelected(date);
                        setState(() {
                          _startOfMonth = _getStartOfMonth(date);
                        });
                      },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 110, 136, 161)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          color: isPast
                              ? Colors.grey
                              : (isSelected ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        decoration: isPast
                            ? const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              )
                            : null,
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isPast
                                ? Colors.white
                                : (isSelected ? Colors.white : Colors.black),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
