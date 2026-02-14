class ExpenseFilterModel {
  String type;
  num totalAmt;
  List<Map<String, dynamic>> allExpenses;

  ExpenseFilterModel({
    required this.type,
    required this.totalAmt,
    required this.allExpenses,
  });
}
