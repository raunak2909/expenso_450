import 'package:expenso_450/data/helper/db_helper.dart';

class ExpenseModel {
  int uID;
  int? eID;
  String eTitle;
  String eRemark;
  num eAmt;
  int eCatId;
  int eType;
  String eCreatedAt;

  ExpenseModel({
    required this.uID,
    this.eID,
    required this.eTitle,
    required this.eRemark,
    required this.eAmt,
    required this.eCatId,
    required this.eType,
    required this.eCreatedAt,
  });

  ///fromMapToModel
  factory ExpenseModel.fromMap(Map<String, dynamic> map){
    return ExpenseModel(
        eID: map[DBHelper.COLUMN_EXPENSE_ID],
        uID: map[DBHelper.COLUMN_USER_ID],
        eTitle: map[DBHelper.COLUMN_EXPENSE_TITLE],
        eRemark: map[DBHelper.COLUMN_EXPENSE_REMARK],
        eAmt: map[DBHelper.COLUMN_EXPENSE_AMOUNT],
        eCatId: map[DBHelper.COLUMN_EXPENSE_CAT_ID],
        eType: map[DBHelper.COLUMN_EXPENSE_TYPE],
        eCreatedAt: map[DBHelper.COLUMN_EXPENSE_CREATED_AT]);
  }


  ///fromModelToMap
  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_USER_ID: uID,
      DBHelper.COLUMN_EXPENSE_TITLE: eTitle,
      DBHelper.COLUMN_EXPENSE_REMARK: eRemark,
      DBHelper.COLUMN_EXPENSE_AMOUNT: eAmt,
      DBHelper.COLUMN_EXPENSE_CAT_ID: eCatId,
      DBHelper.COLUMN_EXPENSE_TYPE: eType,
      DBHelper.COLUMN_EXPENSE_CREATED_AT: eCreatedAt,
    };
  }

}