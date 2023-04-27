import 'package:email_validator/email_validator.dart';
import 'package:farmerica/ui/Welcome.dart';
import 'package:farmerica/ui/widgets/input_outline_button.dart';
import 'package:farmerica/ui/widgets/input_text_button.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:farmerica/constant.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/TokenResponse.dart';

import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';

import 'package:farmerica/ui/ForgotPassword.dart';

import 'package:farmerica/ui/SignUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/ui/homepage.dart';
import 'package:farmerica/ui/widgets/mytextbutton.dart';
import 'package:farmerica/utils/sharedServices.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username, password, mail;
  String error1, error2;
  bool showPassword = true;
  Customers customer;
  final _formKey = GlobalKey<FormState>();
  Api_Services api_services = Api_Services();
  SharedServices sharedServices = SharedServices();
  void toggle() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const Text("Welcome,",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      const Text(
                        "Sign in to continue!",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        onChanged: (text) {
                          mail = text;
                        },
                        validator: (text) {
                          bool valid = EmailValidator.validate(text);
                          if (valid) {
                            return null;
                          } else {
                            return "Please Enter Valid Mail ";
                          }
                        },
                        decoration: const InputDecoration(
                          suffix: Icon(Icons.person),
                          hintText: "Email Address",
                          labelText: "Email",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: showPassword,
                        onChanged: (text) {
                          password = text;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the passcode';
                          }
                          if (value.length <= 6) {
                            return "Password must be more than 10 letters";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Password",
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            labelText: "Password",
                            suffix: GestureDetector(
                              child: showPassword
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined),
                              onTap: () {
                                toggle();
                              },
                            )),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      InputTextButton(
                        title: "Sign In",
                        onClick: () async {
                          if (_formKey.currentState.validate()) {
                            username = await api_services.getUsernameByMail(mail);
                            if (username == null) {
                              Fluttertoast.showToast(
                                  msg: "E-Mail is not registered",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              var token = await api_services.getToken(
                                  username, password);
                              print('tokenResponse: $token');
                              if (token == 403) {
                                Fluttertoast.showToast(
                                    msg: "Wrong Password",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (token == null) {
                                Fluttertoast.showToast(
                                    msg: "Wrong Credential",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                Customers customer =
                                    await api_services.getCustomersByMail(mail);
                                Fluttertoast.showToast(
                                    msg: "Login Successful",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                sharedServices.setLoginDetails(customer);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BasePage(
                                              title: "Farmerica App",
                                              customer: customer,
                                            )));
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      InputOutlineButton(
                        title: "Back",
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => WelcomePage()));
                        },
                      ),
                      const Spacer(
                        flex: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("I'm new user, "),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ])),
          ),
        ));
  }
}
