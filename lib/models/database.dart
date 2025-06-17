import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uangku_app/models/category.dart';
import 'package:uangku_app/models/transaction.dart';
import 'package:uangku_app/models/transaction_with_category.dart';

part 'database.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD Category
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)
      ..where((tbl) => tbl.type.equals(type))).get();
  }

  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where(
      (tbl) => tbl.id.equals(id),
    )).write(CategoriesCompanion(name: Value(name)));
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // TRANSACTION
  Stream<List<TransactionWithCategory>> getTransactionByDate(DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ])..where(transactions.transaction_date.equals(date)));
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
