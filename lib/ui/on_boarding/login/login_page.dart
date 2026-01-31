import 'package:expenso_450/domain/constants/app_routes.dart';
import 'package:expenso_450/ui/on_boarding/bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passController = TextEditingController();

  bool isPassVisible = false;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hi, Welcome back..",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  RegExp emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  );
                  if (value != null && value.isEmpty) {
                    return "Please enter your email..";
                  }
                  /// _____@____.___
                  else if (!emailRegExp.hasMatch(value!)) {
                    return "Please enter a valid email address..";
                  } else {
                    return null;
                  }
                },
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
              TextFormField(
                validator: (value) {
                  RegExp passRegExp = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                  );

                  if (value != null && value.isEmpty) {
                    return "Please enter your password..";
                  } else if (!passRegExp.hasMatch(value!)) {
                    return "Please enter a strong password \nwhich contains at-least one uppercase,\none lowercase, one digit,\none special character and\ntotal of 8 characters";
                  } else {
                    return null;
                  }
                },
                obscureText: !isPassVisible,
                controller: passController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      isPassVisible = !isPassVisible;
                      setState(() {});
                    },
                    icon: Icon(
                      isPassVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
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
                  listenWhen: (ps, cs){
                    return isLogin;
                  },
                  buildWhen: (ps, cs){
                    return isLogin;
                  },
                  listener: (context, state) {
                    if (state is UserLoadingState) {
                      isLoading = true;
                    }

                    if (state is UserSuccessState) {
                      isLoading = false;
                      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Logged-in successfully!!"),
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
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        isLogin = true;
                        if (formKey.currentState!.validate()) {
                          context.read<UserBloc>().add(
                            AuthenticateUserEvent(
                              email: emailController.text,
                              pass: passController.text,
                            ),
                          );
                        }
                      },
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 11),
                                Text(
                                  'Creating your account...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : Text('Sign Up'),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      isLogin = false;
                      Navigator.pushNamed(context, AppRoutes.signUp);
                    },
                    child: Text("Sign Up", style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
