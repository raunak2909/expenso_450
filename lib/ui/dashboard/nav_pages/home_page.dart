import 'dart:math';

import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/data/models/expense_filter_model.dart';
import 'package:expenso_450/domain/constants/app_constants.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_bloc.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_event.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int filterIndex = 1;

  List<String> mFilters = [
    "Date",
    "Month",
    "Year",
    "Category",
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchInitialExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/ic_logo.png",
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 7),
                    Text(
                      "Expenso",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, size: 25),
                ),
              ],
            ),
            SizedBox(height: 11),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/5556/5556499.png",
                          ),
                        ),
                        SizedBox(width: 11),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Morning",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Blakowski",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        DropdownMenu(
                          onSelected: (value){
                            context.read<ExpenseBloc>().add(FetchInitialExpenseEvent(filterFlag: value??1));
                          },
                          trailingIcon: Icon(Icons.keyboard_arrow_down_rounded),
                          inputDecorationTheme: InputDecorationThemeData(
                            filled: true,
                            fillColor: Color(0xffEEF2FD),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                          initialSelection: filterIndex,
                            dropdownMenuEntries: List.generate(mFilters.length, (index){
                              return DropdownMenuEntry(value: index+1, label: mFilters[index]);
                            })


                          /*mFilters.map((eachFilter){
                          return DropdownMenuEntry(value: eachFilter, label: eachFilter);
                        }).toList()*/),
                      ],
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (_, state) {
                        if (state is ExpenseLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is ExpenseLoadedState) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.mExpense.length,
                            itemBuilder: (_, index) {
                              ExpenseFilterModel eachFilterExp =
                                  state.mExpense[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 11),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            eachFilterExp.type,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "₹${eachFilterExp.totalAmt.toString()}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 11),
                                      Divider(height: 1, color: Colors.black12),
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            eachFilterExp.allExpenses.length,
                                        itemBuilder: (_, childIndex) {
                                          String imgPath = AppConstants
                                              .mCategories
                                              .firstWhere((e) {
                                                return e["id"] ==
                                                    eachFilterExp
                                                        .allExpenses[childIndex][DBHelper
                                                        .COLUMN_EXPENSE_CAT_ID];
                                              })["imgPath"];

                                          return ListTile(
                                            leading: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .primaries[Random().nextInt(
                                                      Colors.primaries.length,
                                                    )]
                                                    .shade100,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Image.asset(imgPath),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              eachFilterExp
                                                  .allExpenses[childIndex][DBHelper
                                                  .COLUMN_EXPENSE_TITLE],
                                            ),
                                            subtitle: Text(
                                              eachFilterExp
                                                  .allExpenses[childIndex][DBHelper
                                                  .COLUMN_EXPENSE_REMARK],
                                            ),
                                            trailing: Text(
                                              "₹ ${eachFilterExp.allExpenses[childIndex][DBHelper.COLUMN_EXPENSE_AMOUNT]}",
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        if (state is ExpenseErrorState) {
                          return Center(child: Text(state.errorMsg));
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
