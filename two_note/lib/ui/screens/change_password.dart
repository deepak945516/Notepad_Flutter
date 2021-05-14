import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_note/common/dart_helper.dart';
import 'package:two_note/common/shared_pref.dart';
import 'package:two_note/main.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // MARK: - Properties
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  var _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text(
          "Change Password",
        ),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Icon(
              Icons.apps,
              size: 100,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: getForm(context),
          ),
        ],
      ),
    );
  }

  Widget getForm(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  //fillColor: AppColors.sBg,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  labelText: "Password",
                  hintText: "Please enter password",
                  helperText: "Minimum password length should be of 8",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                validator: (password) {
                  return password.trim().length > 7
                      ? null
                      : "Minimum password length should be of 8";
                },
              ),
              SizedBox(
                height: 30,
              ),
              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  //fillColor: AppColors.sBg,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.confirmation_number_outlined,
                  ),
                  labelText: "Confirm password",
                  hintText: "Reenter your password",
                  helperText: "Password & confirm password should be same",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      //color: AppColors.themeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                ),
                validator: (password) {
                  return password.trim().length > 7 &&
                          password == _passwordController.text
                      ? null
                      : "Password & confirm password should be same";
                },
              ),
              SizedBox(
                height: 30,
              ),
              // Sign up
              MaterialButton(
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
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      PreferenceData.setStringData(
                          "password", _confirmPasswordController.text.trim());
                      Navigator.pop(context);
                    } else {
                      DartHelper.showToast(message: "Something went wrong!");
                    }
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
