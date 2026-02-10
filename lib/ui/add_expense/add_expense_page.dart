import 'package:expenso_450/domain/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                        itemBuilder: (_, index){
                          return InkWell(
                            onTap: (){
                              selectedCatIndex = index;
                              setState(() {

                              });
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Image.asset(AppConstants.mCategories[index]["imgPath"], width: 50, height: 50,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(AppConstants.mCategories[index]["name"])
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
                child: Center(child: selectedCatIndex >= 0 ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppConstants.mCategories[selectedCatIndex]["imgPath"], width: 34, height: 34,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("- ${AppConstants.mCategories[selectedCatIndex]["name"]}")
                  ],
                ) : Text("Choose a Category")),
              ),
            ),

            ///type
          ],
        ),
      ),
    );
  }
}
