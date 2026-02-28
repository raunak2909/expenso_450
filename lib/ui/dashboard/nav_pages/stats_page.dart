import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/bloc/expense_bloc.dart';
import '../../add_expense/bloc/expense_event.dart';

class StatsPage extends StatefulWidget {
  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int filterIndex = 1;

  List<String> mFilters = ["Date", "Month", "Year", "Category"];

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchInitialExpenseEvent(filterFlag: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 21, right: 21, top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statistic',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                DropdownMenu(
                  initialSelection: filterIndex,
                  onSelected: (value) {
                    context.read<ExpenseBloc>().add(
                      FetchInitialExpenseEvent(filterFlag: value ?? 0),
                    );
                  },
                  inputDecorationTheme: InputDecorationThemeData(
                    filled: true,
                    fillColor: Color(0xffEEF2FD),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  dropdownMenuEntries: List.generate(mFilters.length, (index) {
                    return DropdownMenuEntry(
                      value: index + 1,
                      label: mFilters[index],
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 11),

            ///2
            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (_, state) {
                  if (state is ExpenseLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ExpenseErrorState) {
                    return Center(child: Text(state.errorMsg));
                  }

                  if (state is ExpenseLoadedState) {
                    return state.mExpense.isNotEmpty
                        ? Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(21),
                                decoration: BoxDecoration(
                                  color: Color(0xff6674D3),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Expense',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white12,
                                          child: Center(
                                            child: Icon(
                                              Icons.more_horiz_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "₹3734",
                                        style: TextStyle(
                                          fontSize: 37,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: " / ₹4000 per month",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 11),
                                    /*LinearProgressIndicator(
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(21),
                      backgroundColor: Color(0xff5969BC),
                      color: Color(0xffEBC696),
                      value: 3734/4000,
                    ),*/
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            color: Color(0xff5969BC),
                                            borderRadius: BorderRadius.circular(
                                              21,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 70),
                                          height: 7,
                                          decoration: BoxDecoration(
                                            color: Color(0xffEBC696),
                                            borderRadius: BorderRadius.circular(
                                              21,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 11),

                              ///3
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expense BreakDown',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Limit ₹1000 / week',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  DropdownMenu(
                                    initialSelection: filterIndex,
                                    onSelected: (value) {
                                      context.read<ExpenseBloc>().add(
                                        FetchInitialExpenseEvent(
                                          filterFlag: value ?? 0,
                                        ),
                                      );
                                    },
                                    inputDecorationTheme:
                                        InputDecorationThemeData(
                                          filled: true,
                                          fillColor: Color(0xffEEF2FD),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                    dropdownMenuEntries: List.generate(
                                      mFilters.length,
                                      (index) {
                                        return DropdownMenuEntry(
                                          value: index + 1,
                                          label: mFilters[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 21),

                              ///4
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: BarChart(
                                  BarChartData(
                                    barGroups: List.generate(
                                      state.mExpense.length,
                                      (index) {
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              width: 21,
                                              color: Colors.pinkAccent,
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                              toY:
                                                  state
                                                          .mExpense[index]
                                                          .totalAmt >=
                                                      0
                                                  ? state
                                                        .mExpense[index]
                                                        .totalAmt
                                                        .toDouble()
                                                  : state
                                                            .mExpense[index]
                                                            .totalAmt
                                                            .toDouble() *
                                                        -1,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    maxY: 50000,
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        axisNameSize: 6,
                                        sideTitles: SideTitles(
                                          getTitlesWidget: (value, _){
                                            return Text(state.mExpense[value.toInt()].type);
                                          },
                                          showTitles: true
                                        )
                                      )
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),

                              ///5
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spending Details',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Your expense are divided into 6 categories',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 11),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 30,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(height: 5),
                                        Text("40%"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.pinkAccent,
                                        ),
                                        SizedBox(height: 5),
                                        Text("25%"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(height: 5),
                                        Text("15%"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.lightBlueAccent,
                                        ),
                                        SizedBox(height: 5),
                                        Text("10%"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: 5),
                                        Text("5%"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                          color: Colors.green,
                                        ),
                                        SizedBox(height: 5),
                                        Text("5%"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Center(child: Text('No Expense yet!!'));
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
