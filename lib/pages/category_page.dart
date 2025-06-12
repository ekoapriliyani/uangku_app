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
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categoryNameController = TextEditingController();

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
    print('MASUK : ' + row.toString());
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
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
                    controller: categoryNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      insert(categoryNameController.text, isExpense ? 2 : 1);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {});
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
                      type = value ? 2 : 1;
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
          FutureBuilder<List<Category>>(
            future: getAllCategory(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return Text(
                      "Ada data : " + snapshot.data!.length.toString(),
                    );
                  } else {
                    return Center(child: Text("No has data"));
                  }
                } else {
                  return Center(child: Text("No has data"));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
