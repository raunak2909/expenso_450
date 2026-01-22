import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/ic_logo.png", width: 250, height: 250,),
            SizedBox(
              height: 11,
            ),
            Text('Expenso')
          ],
        ),
      ),
    );
  }
}
