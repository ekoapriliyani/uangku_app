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
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(
                            "Kumpulan Doa Harian",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Sebelum Tidur"),
                                    subtitle: Text(
                                      "بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Bangun Tidur"),
                                    subtitle: Text(
                                      "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Masuk Kamar Mandi"),
                                    subtitle: Text(
                                      "اللّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Keluar Kamar Mandi"),
                                    subtitle: Text("غُفْرَانَكَ"),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Masuk Masjid"),
                                    subtitle: Text(
                                      "اللّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Keluar Masjid"),
                                    subtitle: Text(
                                      "اللّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Sebelum Makan"),
                                    subtitle: Text(
                                      "اللّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا، وَقِنَا عَذَابَ النَّارِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Sesudah Makan"),
                                    subtitle: Text(
                                      "الْـحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا، وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Ketika Hujan Turun"),
                                    subtitle: Text(
                                      "اللّهُمَّ صَيِّبًا نَافِعًا",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Ketika Mendengar Petir"),
                                    subtitle: Text(
                                      "سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Keluar Rumah"),
                                    subtitle: Text(
                                      "بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Masuk Rumah"),
                                    subtitle: Text(
                                      "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Naik Kendaraan"),
                                    subtitle: Text(
                                      "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Melihat Cermin"),
                                    subtitle: Text(
                                      "اللَّهُمَّ كَمَا أَحْسَنْتَ خَلْقِي فَحَسِّنْ خُلُقِي",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Memulai Pekerjaan"),
                                    subtitle: Text(
                                      "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذِهِ الْيَوْمِ",
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text("Doa Mengakhiri Majelis"),
                                    subtitle: Text(
                                      "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ",
                                    ),
                                  ),
                                ),
                                // Tambahkan doa lainnya sesuai kebutuhan
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.info_outline, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
