import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/data/models/expense_filter_model.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_event.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  DBHelper dbHelper;
  DateFormat df = DateFormat.yMMMEd();

  ExpenseBloc({required this.dbHelper}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      bool isExpenseAdded = await dbHelper.addExpense(
        title: event.title,
        remark: event.remark,
        amt: event.amt,
        catId: event.catId,
        type: event.type,
        createdAt: event.created_at,
      );

      if (isExpenseAdded) {
        List<Map<String, dynamic>> allExp = await dbHelper.fetchAllExpense();
        emit(ExpenseLoadedState(mExpense: filterExpensesByType(allExp)));
      } else {
        emit(ExpenseErrorState(errorMsg: "Something went wrong"));
      }
    });

    on<FetchInitialExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      List<Map<String, dynamic>> allExp = await dbHelper.fetchAllExpense();

      emit(ExpenseLoadedState(mExpense: filterExpensesByType(allExp)));
    });
  }

  List<ExpenseFilterModel> filterExpensesByType(
    List<Map<String, dynamic>> allExp,
  ) {
    List<ExpenseFilterModel> mFilteredExpense = [];

    List<String> uniqueDates = [];

    for (Map<String, dynamic> eachExp in allExp) {
      String eachDate = df.format(
        DateTime.fromMillisecondsSinceEpoch(
          int.parse(eachExp[DBHelper.COLUMN_EXPENSE_CREATED_AT]),
        ),
      );

      if (!uniqueDates.contains(eachDate)) {
        uniqueDates.add(eachDate);
      }
    }

    for (String eachDate in uniqueDates) {
      num totalAmt = 0;
      List<Map<String, dynamic>> eachDateExpenses = [];

      for (Map<String, dynamic> eachExp in allExp) {
        String eachExpDate = df.format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(eachExp[DBHelper.COLUMN_EXPENSE_CREATED_AT]),
          ),
        );

        if (eachDate == eachExpDate) {
          eachDateExpenses.add(eachExp);

          if (eachExp[DBHelper.COLUMN_EXPENSE_TYPE] == 0) {
            totalAmt -= eachExp[DBHelper.COLUMN_EXPENSE_AMOUNT];
          } else {
            totalAmt += eachExp[DBHelper.COLUMN_EXPENSE_AMOUNT];
          }
        }
      }

      mFilteredExpense.add(
        ExpenseFilterModel(
          type: eachDate,
          totalAmt: totalAmt,
          allExpenses: eachDateExpenses,
        ),
      );
    }

    return mFilteredExpense;
  }
}
