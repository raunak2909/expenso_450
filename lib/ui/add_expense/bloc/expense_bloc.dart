import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_event.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  DBHelper dbHelper;

  ExpenseBloc({required this.dbHelper}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      bool isExpenseAdded = await dbHelper.addExpense(
          title: event.title,
          remark: event.remark,
          amt: event.amt,
          catId: event.catId,
          type: event.type,
          createdAt: event.created_at);

      if(isExpenseAdded){
        List<Map<String, dynamic>> allExp = await dbHelper.fetchAllExpense();
        emit(ExpenseLoadedState(mExpense: allExp));
      } else {
        emit(ExpenseErrorState(errorMsg: "Something went wrong"));
      }
    });
  }

}