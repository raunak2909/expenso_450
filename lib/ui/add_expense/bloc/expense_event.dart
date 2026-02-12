abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  String title, remark;
  double amt;
  int catId, type, created_at;

  AddExpenseEvent({
    required this.title,
    required this.remark,
    required this.amt,
    required this.catId,
    required this.type,
    required this.created_at,
  });
}

class FetchInitialExpenseEvent extends ExpenseEvent {}
