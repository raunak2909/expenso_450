import 'package:expenso_450/data/models/expense_model.dart';

abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  ExpenseModel mExp;

  AddExpenseEvent({
    required this.mExp
  });
}

class FetchInitialExpenseEvent extends ExpenseEvent {
  int filterFlag;
  FetchInitialExpenseEvent({this.filterFlag = 1});
}
