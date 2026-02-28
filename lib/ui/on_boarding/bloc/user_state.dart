abstract class UserState{}

class UserInitialState extends UserState{}
class UserLoadingState extends UserState{}
class UserSuccessState extends UserState{}
class UserBalanceState extends UserState{
  double bal;
  UserBalanceState({required this.bal});
}
class UserFailureState extends UserState{
  String errorMsg;
  UserFailureState({required this.errorMsg});
}