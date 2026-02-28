import 'package:expenso_450/domain/constants/app_constants.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_bloc.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_event.dart';
import 'package:expenso_450/ui/add_expense/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../on_boarding/bloc/user_bloc.dart';
import '../on_boarding/bloc/user_event.dart';

class AddExpensePage extends StatefulWidget {
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  var titleController = TextEditingController();

  var remarkController = TextEditingController();

  var amountController = TextEditingController();

  DateFormat df = DateFormat.yMMMEd();

  DateTime? selectedDate;

  int selectedCatIndex = -1;

  List<String> mType = ["Debit", "Credit", "Loan", "Lend", "Borrow"];
  String selectedType = "Debit";

  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            ///title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                labelText: "Title",
                hintText: "Enter title here..",
                prefixIcon: Icon(Icons.title),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Color(0xffE78BBC), width: 2),
                ),
              ),
            ),
            SizedBox(height: 14),

            ///remark
            TextField(
              maxLines: 4,
              controller: remarkController,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                labelText: "Remark",
                hintText: "Enter any remark here..",
                prefixIcon: Icon(Icons.description),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Color(0xffE78BBC), width: 2),
                ),
              ),
            ),
            SizedBox(height: 14),

            ///amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                labelText: "Amount",
                hintText: "Enter amount here..",
                prefixIcon: Icon(Icons.currency_rupee_outlined),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Color(0xffE78BBC), width: 2),
                ),
              ),
            ),
            SizedBox(height: 14),

            ///date
            InkWell(
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(Duration(days: 730)),
                  lastDate: DateTime.now(),
                );
                setState(() {});
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: Colors.black54, width: 1),
                ),
                child: Center(
                  child: Text(df.format(selectedDate ?? DateTime.now())),
                ),
              ),
            ),
            SizedBox(height: 14),

            ///category
            InkWell(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      padding: EdgeInsets.all(11),
                      width: double.infinity,
                      height: double.infinity,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              selectedCatIndex = index;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppConstants.mCategories[index]["imgPath"],
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 5),
                                Text(AppConstants.mCategories[index]["name"]),
                              ],
                            ),
                          );
                        },
                        itemCount: AppConstants.mCategories.length,
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: Colors.black54),
                ),
                child: Center(
                  child: selectedCatIndex >= 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppConstants
                                  .mCategories[selectedCatIndex]["imgPath"],
                              width: 34,
                              height: 34,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "- ${AppConstants.mCategories[selectedCatIndex]["name"]}",
                            ),
                          ],
                        )
                      : Text("Choose a Category"),
                ),
              ),
            ),
            SizedBox(height: 14),

            ///type
            ///DropdownButton
            /*StatefulBuilder(
              builder: (context, ss) {
                return DropdownButton(
                  value: selectedType,
                  items: mType.map((element) {
                    return DropdownMenuItem(child: Text(element), value: element);
                  }).toList(),
                  onChanged: (value) {
                    selectedType = value!;
                    ss((){});
                  },
                );
              }
            ),*/
            DropdownMenu(
              width: double.infinity,
              inputDecorationTheme: InputDecorationThemeData(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              initialSelection: selectedType,
              onSelected: (value) {
                selectedType = value!;
              },
              dropdownMenuEntries: mType.map((element) {
                return DropdownMenuEntry(value: element, label: element);
              }).toList(),
            ),
            SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: BlocConsumer<ExpenseBloc, ExpenseState>(
                listener: (_, state){
                  if(state is ExpenseLoadingState){
                    isAdding = true;
                  }

                  if(state is ExpenseErrorState){
                    isAdding = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );

                  }

                  if(state is ExpenseLoadedState){
                    isAdding = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Expense added successfully!!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<UserBloc>().add(GetUserBalanceEvent());
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(
                        AddExpenseEvent(
                          title: titleController.text,
                          remark: remarkController.text,
                          amt: double.parse(amountController.text),
                          catId: AppConstants.mCategories[selectedCatIndex]["id"],
                          type: mType.indexWhere((element) {
                            return element == selectedType;
                          }),
                          created_at: (selectedDate ?? DateTime.now())
                              .millisecondsSinceEpoch,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE78BBC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: isAdding ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 11),
                        Text('Adding Expense..'),
                      ],
                    ) : Text('Add Expense'),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
