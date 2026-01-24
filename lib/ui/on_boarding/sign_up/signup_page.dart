import 'package:expenso_450/data/helper/db_helper.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_bloc.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_event.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();

  var passController = TextEditingController();

  var nameController = TextEditingController();

  var mobNoController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hi, Welcome back..",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 11),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                labelText: "Name",
                hintText: "Enter name here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: "Email",
                hintText: "Enter email here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: mobNoController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.call_outlined),
                labelText: "Mobile No",
                hintText: "Enter mobile no here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password_outlined),
                labelText: "Password",
                hintText: "Enter password here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserLoadingState) {
                    isLoading = true;
                  }

                  if (state is UserSuccessState) {
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Account created successfully!!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }

                  if (state is UserFailureState) {
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<UserBloc>().add(
                        CreateUserEvent(
                          email: emailController.text,
                          mobNo: mobNoController.text,
                          name: nameController.text,
                          pass: passController.text,
                        ),
                      );
                    },
                    child: isLoading ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        ),
                        SizedBox(width: 11),
                        Text('Creating your account...', style: TextStyle(color: Colors.white),),
                      ],
                    ) : Text('Sign Up'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
