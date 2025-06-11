import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangku_app/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  final AppDatabase database = AppDatabase();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now,
          ),
        );
    print(row);
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense) ? "Add Expense" : "Add Income",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      insert("Makan makan", 2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpense,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    openDialog();
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading:
                    (isExpense)
                        ? Icon(Icons.upload, color: Colors.red)
                        : Icon(Icons.download, color: Colors.green),
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    SizedBox(width: 10),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading:
                    (isExpense)
                        ? Icon(Icons.upload, color: Colors.red)
                        : Icon(Icons.download, color: Colors.green),
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    SizedBox(width: 10),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
