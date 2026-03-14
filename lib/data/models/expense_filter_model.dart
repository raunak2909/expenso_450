import 'package:expenso_450/data/models/expense_model.dart';

class ExpenseFilterModel {
  String type;
  num totalAmt;
  List<ExpenseModel> allExpenses;

  ExpenseFilterModel({
    required this.type,
    required this.totalAmt,
    required this.allExpenses,
  });
}
