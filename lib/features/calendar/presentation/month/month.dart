// Importing necessary packages and files
import 'package:alertnukeapp/config/colors.dart';
import 'package:alertnukeapp/features/calendar/presentation/components/buildmonth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alertnukeapp/screens/views/timecolumn.dart';

// Defining a StatefulWidget for the MonthCalendar
class MonthCalendar extends StatefulWidget {
  // Constructor to initialize with the selected month index
  final int monthIndex;
  final int selectedMonth;
  final Function(int) dayCallback;
  final int selectedYear;

  const MonthCalendar(
      {Key? key,
      required this.monthIndex,
      required this.selectedYear,
      required this.dayCallback})
      : selectedMonth = monthIndex,
        super(key: key);

  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

// State class for the MonthCalendar
class _MonthCalendarState extends State<MonthCalendar> {
  late PageController _pageController; // Controller for handling the page view
  late TextEditingController
      _timeController; // Controller for handling time input
  int currentPage = 0; // Variable to keep track of the current page (month)

  // Initializing controllers and setting the initial page to the selected month
  @override
  void initState() {
    super.initState();
    currentPage = widget.monthIndex + 1;
    _pageController = PageController(initialPage: currentPage);
    _timeController = TextEditingController();
  }

  // Disposing of controllers when the widget is disposed
  @override
  void dispose() {
    _pageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Building the UI for the MonthCalendar
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    // Scaffold widget for the overall structure of the screen
    return Scaffold(
      body: Stack(
        children: [
          // Background container with gradient and styling
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: BackgroundColor.primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            padding:
                const EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                // PageView for displaying months
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    itemCount: 12, // Number of months
                    itemBuilder: (BuildContext context, int index) {
                      // Calculate the month for the current page
                      int monthIndex = index + 1;

                      // Build a month page using a custom function
                      return buildMonthPage(
                          monthIndex - 2, widget.selectedYear, 0.5, 20,
                          dayCallback: (day) => widget.dayCallback(day));
                    },
                  ),
                ),

                // Displaying the current month's name
                Text(
                  DateFormat('MMMM yyyy').format(DateTime(
                    widget.selectedYear ?? DateTime.now().year,
                    1 + currentPage, // Direkt auf den "ziel"-Monat basierend auf `currentPage`
                    1,
                  )),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
          // Positioned widget for displaying the time column on top of the page
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: TimeColumn(
              timeController: _scrollController,
              now: DateTime.now(),
            ),
          ),
        ],
      ),
    );
  }
}
