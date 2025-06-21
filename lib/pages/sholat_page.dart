import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SholatPage extends StatefulWidget {
  const SholatPage({super.key});

  @override
  State<SholatPage> createState() => _SholatPageState();
}

class _SholatPageState extends State<SholatPage> {
  Map<String, dynamic>? jadwal;
  bool isLoading = true;
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    fetchJadwalSholat();
    updateTime(); // update jam setiap detik
  }

  void updateTime() {
    currentTime = _formatTime(DateTime.now());
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          updateTime();
        });
      }
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  Future<void> fetchJadwalSholat() async {
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=Bekasi&country=Indonesia&method=11',
    );

    try {
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jadwal = data['data']['timings'];
          isLoading = false;
        });
      } else {
        throw Exception("Gagal memuat data");
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jadwal Sholat"),
        backgroundColor: Colors.green,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : (jadwal == null)
              ? Center(child: Text("Gagal memuat data"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header tanggal dan jam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tanggal: ${DateTime.now().toString().substring(0, 10)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 4),
                            Text(
                              currentTime,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Jadwal sholat dalam bentuk card
                    Expanded(
                      child: ListView(
                        children: [
                          buildSholatCard(
                            "Subuh",
                            "Fajr",
                            jadwal!['Fajr'],
                            Icons.wb_twilight,
                          ),
                          buildSholatCard(
                            "Dzuhur",
                            "Dhuhr",
                            jadwal!['Dhuhr'],
                            Icons.wb_sunny,
                          ),
                          buildSholatCard(
                            "Ashar",
                            "Asr",
                            jadwal!['Asr'],
                            Icons.sunny,
                          ),
                          buildSholatCard(
                            "Maghrib",
                            "Maghrib",
                            jadwal!['Maghrib'],
                            Icons.nightlight,
                          ),
                          buildSholatCard(
                            "Isya",
                            "Isha",
                            jadwal!['Isha'],
                            Icons.nights_stay,
                          ),

                          SizedBox(height: 20),

                          // Footer DKM info
                          Center(
                            child: Text(
                              "DKM Halimatul Amin\nTaman Kertamukti Residence Blok C\nCibitung, Kab. Bekasi, Jawa Barat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget buildSholatCard(
    String label,
    String key,
    String waktu,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.green[800]),
        title: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          waktu,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
