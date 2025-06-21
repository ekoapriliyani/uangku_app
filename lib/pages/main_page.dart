import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangku_app/pages/category_page.dart';
import 'package:uangku_app/pages/home_page.dart';
import 'package:uangku_app/pages/sholat_page.dart';
import 'package:uangku_app/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  List<Widget> _children = [];
  late int currentIndex = 0;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      currentIndex = index;
      _children = [HomePage(selectedDate: selectedDate), CategoryPage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          (currentIndex == 0)
              ? CalendarAppBar(
                accent: Colors.green,
                backButton: false,
                locale: 'id',
                onDateChanged: (value) {
                  setState(() {
                    selectedDate = value;
                    updateView(0, selectedDate);
                  });
                },
                firstDate: DateTime.now().subtract(Duration(days: 140)),
                lastDate: DateTime.now(),
              )
              : PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 16,
                  ),
                  child: Text(
                    "Categories",
                    style: GoogleFonts.montserrat(fontSize: 20),
                  ),
                ),
              ),
      body: _children[currentIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                TransactionPage(transactionWithCategory: null),
                      ),
                    )
                    .then((value) {
                      setState(() {});
                    });
              },
              icon: Icon(Icons.add_circle, size: 30, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SholatPage()),
                );
              },
              icon: Icon(Icons.mosque, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
