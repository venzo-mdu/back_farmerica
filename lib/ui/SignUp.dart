import 'package:farmerica/ui/Welcome.dart';
import 'package:farmerica/ui/widgets/input_outline_button.dart';
import 'package:farmerica/ui/widgets/input_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/utils/sharedServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/constant.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';

import 'package:farmerica/ui/LoginPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:farmerica/ui/homepage.dart';
import 'package:farmerica/ui/widgets/mytextbutton.dart';
import 'package:string_validator/string_validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Api_Services apiServices = Api_Services();
  var response = "hh";
  bool done = false;
  String firstName, username, lastName;
  String mail;
  TextEditingController t1, t2, t3, t4;
  final _formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedServices sharedServices = SharedServices();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text("Create Account,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text(
                  "Sign up to started!",
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
                  controller: t1,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    bool valid = EmailValidator.validate(text);
                    if (valid) {
                      return null;
                    } else {
                      return "Please Enter Valid Mail ";
                    }
                  },
                  onChanged: (text) {
                    mail = text;
                  },
                  decoration: const InputDecoration(
                      labelStyle: kBodyText,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      hintStyle: kBodyText,
                      hintText: "Email",
                      labelText: "Email Address"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: t2,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    firstName = text;
                    setState(() {});
                    // print(firstName);
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    hintStyle: kBodyText,
                    hintText: "First Name",
                    labelText: "First Name",
                    labelStyle: kBodyText,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (text) {
                    lastName = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      hintStyle: kBodyText,
                      labelStyle: kBodyText,
                      hintText: "Last Name",
                      labelText: "Last Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: t4,
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    username = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      hintText: "Username",
                      labelStyle: kBodyText,
                      labelText: "Username"),
                ),
                const SizedBox(height: 10),
                const Spacer(),
                InputTextButton(
                  title: "Sign Up",
                  onClick: () async {
                    if (_formKey.currentState.validate()) {
                      var msg = await apiServices.createCustomers(
                          email: mail,
                          firstName: firstName,
                          lastName: lastName,
                          username: username);

                      Fluttertoast.showToast(
                          msg: msg,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      if (msg == "Signup successful") {
                        Customers customer =
                            await apiServices.getCustomersByMail(mail);
                        sharedServices.setLoginDetails(customer);
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => BasePage(
                                      title: "Farmerica",
                                      customer: customer,
                                    )));
                        // print(customer);
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
                    const Text("I'm already a member, "),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
    //
    // This trailing comma makes auto-formatting nicer fos.
  }
}
