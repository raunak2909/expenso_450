import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/data/models/expense_filter_model.dart';
import 'package:expenso_450/data/models/expense_model.dart';
import 'package:expenso_450/domain/constants/app_constants.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_event.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  DBHelper dbHelper;


  ExpenseBloc({required this.dbHelper}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      bool isExpenseAdded = await dbHelper.addExpense(
        newExp: event.mExp
      );

      if (isExpenseAdded) {
        List<ExpenseModel> allExp = await dbHelper.fetchAllExpense();
        emit(ExpenseLoadedState(mExpense: filterExpensesByType(allExp)));
      } else {
        emit(ExpenseErrorState(errorMsg: "Something went wrong"));
      }
    });

    on<FetchInitialExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());

      List<ExpenseModel> allExp = await dbHelper.fetchAllExpense();

      emit(ExpenseLoadedState(mExpense: filterExpensesByType(allExp, flag: event.filterFlag)));
    });
  }

  ///1->date wise
  ///2->month wise
  ///3->year wise
  ///4->cat wise
  List<ExpenseFilterModel> filterExpensesByType(
      List<ExpenseModel> allExp, {int flag = 1}) {
    List<ExpenseFilterModel> mFilteredExpense = [];

    if (flag < 4) {
      /// date, month, year

      DateFormat df = DateFormat.yMMMEd();
      if (flag == 3) {
        df = DateFormat.y();
      } else if (flag == 2) {
        df = DateFormat.yMMM();
      } else {
        df = DateFormat.yMMMEd();
      }

      List<String> uniqueDates = [];

      for (ExpenseModel eachExp in allExp) {
        String eachDate = df.format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(eachExp.eCreatedAt),
          ),
        );

        if (!uniqueDates.contains(eachDate)) {
          uniqueDates.add(eachDate);
        }
      }

      for (String eachDate in uniqueDates) {
        num totalAmt = 0;
        List<ExpenseModel> eachDateExpenses = [];

        for (ExpenseModel eachExp in allExp) {
          String eachExpDate = df.format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(eachExp.eCreatedAt),
            ),
          );

          if (eachDate == eachExpDate) {
            eachDateExpenses.add(eachExp);

            if (eachExp.eType == 0) {
              totalAmt -= eachExp.eAmt;
            } else {
              totalAmt += eachExp.eAmt;
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
    } else {
      ///cat wise

      for (Map<String, dynamic> eachCat in AppConstants.mCategories) {
        num totalAmt = 0;
        List<ExpenseModel> eachCatExpenses = [];

        for (ExpenseModel eachExp in allExp) {
          if (eachCat["id"] == eachExp.eCatId) {
            eachCatExpenses.add(eachExp);
            if (eachExp.eType == 0) {
              totalAmt -= eachExp.eAmt;
            } else {
              totalAmt += eachExp.eAmt;
            }
          }
        }

        if(eachCatExpenses.isNotEmpty) {
          mFilteredExpense.add(ExpenseFilterModel(type: eachCat["name"],
              totalAmt: totalAmt,
              allExpenses: eachCatExpenses));
        }
      }
    }

    return mFilteredExpense;
  }
}
