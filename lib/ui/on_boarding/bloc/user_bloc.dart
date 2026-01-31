import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_event.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  DBHelper dbHelper;

  UserBloc({required this.dbHelper}) : super(UserInitialState()) {
    on<CreateUserEvent>((event, emit) async {
      emit(UserLoadingState());

      int checkValue = await dbHelper.createUser(
        email: event.email,
        mobNo: event.mobNo,
        name: event.name,
        pass: event.pass,
      );

      if (checkValue == 3) {
        emit(UserFailureState(errorMsg: "Something went wrong!!"));
      } else if (checkValue == 2) {
        emit(
          UserFailureState(
            errorMsg:
                "Email already exists, either login or use another email.",
          ),
        );
      } else {
        emit(UserSuccessState());
      }
    });

    on<AuthenticateUserEvent>((event, emit) async {
      emit(UserLoadingState());

      bool check = await dbHelper.authenticateUser(email: event.email, pass: event.pass);

      if(check){
        emit(UserSuccessState());
      } else {
        emit(UserFailureState(errorMsg: "Invalid credentials!!"));
      }
    });
  }
}
