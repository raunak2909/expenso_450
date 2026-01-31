import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? mDB;
  static const String DB_NAME = "expenso.db";
  static const String TABLE_EXPENSE = "expense";
  static const String TABLE_USER = "user";

  ///Expense(eid, uid, title, remarks, amount, date, cat_id, e_type(credit/debit/investment/loan/borrow/lend))
  ///User(uid(PK), name, email, mobNo, pass, budget, balance, created_at)
  ///Category(Optional)
  static const String COLUMN_USER_ID = "u_id";
  static const String COLUMN_USER_NAME = "u_name";
  static const String COLUMN_USER_EMAIL = "u_email";
  static const String COLUMN_USER_MOB_NO = "u_mob_no";
  static const String COLUMN_USER_PASS = "u_pass";
  static const String COLUMN_USER_BUDGET = "u_budget";
  static const String COLUMN_USER_BALANCE = "u_bal";
  static const String COLUMN_USER_CREATED_AT = "u_created_at";

  static const String COLUMN_EXPENSE_ID = "e_id";
  static const String COLUMN_EXPENSE_TITLE = "e_title";
  static const String COLUMN_EXPENSE_REMARK = "e_remark";
  static const String COLUMN_EXPENSE_AMOUNT = "e_amt";
  static const String COLUMN_EXPENSE_CAT_ID = "e_cat_id";
  static const String COLUMN_EXPENSE_TYPE = "e_type";
  static const String COLUMN_EXPENSE_CREATED_AT = "e_created_at";

  Future<Database> initDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' Create table $TABLE_USER ( 
          $COLUMN_USER_ID integer primary key autoincrement, 
          $COLUMN_USER_NAME text, 
          $COLUMN_USER_EMAIL text, 
          $COLUMN_USER_BALANCE real, 
          $COLUMN_USER_BUDGET real, 
          $COLUMN_USER_MOB_NO text, 
          $COLUMN_USER_CREATED_AT text, 
          $COLUMN_USER_PASS )''');
        db.execute(
          "Create table $TABLE_EXPENSE ( $COLUMN_EXPENSE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_EXPENSE_TITLE text, $COLUMN_EXPENSE_REMARK text, $COLUMN_EXPENSE_AMOUNT real, $COLUMN_EXPENSE_TYPE integer, $COLUMN_EXPENSE_CAT_ID integer, $COLUMN_EXPENSE_CREATED_AT text )",
        );
      },
    );
  }

  ///queries
  ///1->success
  ///2->email already exists
  ///3->user not created
  Future<int> createUser({
    required String email,
    required String mobNo,
    required String name,
    required String pass,
  }) async {
    var db = await initDB();

    bool check = await isEmailAlreadyExists(email: email);

    if (!check) {
      int rowsEffected = await db.insert(TABLE_USER, {
        COLUMN_USER_EMAIL: email,
        COLUMN_USER_NAME: name,
        COLUMN_USER_MOB_NO: mobNo,
        COLUMN_USER_PASS: pass,
        COLUMN_USER_BUDGET: 5000,
        COLUMN_USER_BALANCE: 0,
        COLUMN_USER_CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      });

      if (rowsEffected > 0) {
        return 1;

        ///1->success
      } else {
        return 3;

        ///3->user not created
      }
    } else {
      return 2;

      ///2->email already exists
    }
  }

  Future<bool> isEmailAlreadyExists({required String email}) async {
    var db = await initDB();

    List<Map<String, dynamic>> mUsers = await db.query(
      TABLE_USER,
      where: "$COLUMN_USER_EMAIL = ?",
      whereArgs: [email],
    );

    return mUsers.isNotEmpty;
  }

  ///login
  Future<bool> authenticateUser({required String email, required String pass}) async {
    var db = await initDB();

    List<Map<String, dynamic>> mUsers = await db.query(
      TABLE_USER,
      where: "$COLUMN_USER_EMAIL = ? and $COLUMN_USER_PASS = ?",
      whereArgs: [email, pass],
    );

    if(mUsers.isNotEmpty){
      ///user is authenticated
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("uid", mUsers[0][COLUMN_USER_ID]);
    }

    return mUsers.isNotEmpty;
  }

  ///add expense
  ///update expense
  ///delete expense
}
