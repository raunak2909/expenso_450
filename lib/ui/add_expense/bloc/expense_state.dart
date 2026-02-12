abstract class ExpenseState{}

class ExpenseInitialState extends ExpenseState{}
class ExpenseLoadingState extends ExpenseState{}
class ExpenseLoadedState extends ExpenseState{
  List<Map<String, dynamic>> mExpense;
  ExpenseLoadedState({required this.mExpense});
}
class ExpenseErrorState extends ExpenseState{
  String errorMsg;
  ExpenseErrorState({required this.errorMsg});
}