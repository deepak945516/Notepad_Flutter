import 'package:flutter/material.dart';
import 'package:two_note/main.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  var onTapRecognizer;
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 30),
          // Logo
          Center(
            child: Icon(
              Icons.apps,
              size: 100,
            ),
          ),
          SizedBox(height: 20),

          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: TextFormField(
                controller: _passwordController,
                //keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                decoration: InputDecoration(
                  //fillColor: AppColors.sBg,
                  filled: true,
                  prefixIcon: Icon(Icons.security_outlined),
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                validator: (password) {
                  print("Password $password");
                  print("SPass: $storedPassword");
                  return password == storedPassword || storedPassword == null
                      ? null
                      : "Incorrect password, please try again!";
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Verify Button
          Container(
            margin: EdgeInsets.all(20),
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  isPasswordValidated = true;
                  main();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
