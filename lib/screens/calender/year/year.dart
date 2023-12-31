import 'package:alertnukeapp/screens/calender/month/month.dart';
import 'package:flutter/material.dart';
import 'package:alertnukeapp/screens/wrapper.dart';

class YearCalendar extends StatelessWidget {
  YearCalendar({Key? key});

  int daysInMonth(int month) {
    var now = DateTime.now();
    var firstDayThisMonth = DateTime(now.year, month, 1);
    var firstDayNextMonth = DateTime(now.year, month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6CA7BE), Color(0xFF2E0B4B)],
            tileMode: TileMode.repeated,
            stops: [0.1, 0.7],
            transform: GradientRotation(45 * 3.1415926535897932 / 180),
          ),
        ),
        padding: const EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/logo.png"),
              width: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToMonthView(context, index + 1);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          monthNames[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF568493),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: daysInMonth(index + 1),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                childAspectRatio: .9,
                              ),
                              itemBuilder: (context, index1) {
                                return AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: .80,
                                        color: const Color.fromARGB(
                                          117,
                                          127,
                                          76,
                                          229,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        (index1 + 1).toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(188, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
           const LogoBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  void navigateToMonthView(BuildContext context, int month) {
    // Hier rufst du die gewünschte Monatsansicht auf
    Navigator.push(context, MaterialPageRoute(builder: (context) => MonthCalendar(selectedMonth: month,)));
    print('Navigating to Month View - $month');
  }
}