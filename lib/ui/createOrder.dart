import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:farmerica/form_helper.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/verifyAddress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
// import 'package:intl/intl.dart';

class CreateOrder extends BasePage {
  List<CartProducts> cartProducts;
  List product = [];
  final int id;
  var shippingFee;
  var details;
  var couponSelection;
  CreateOrder({
    this.cartProducts,
    this.product,
    this.id,
    this.shippingFee,
    this.details,
    this.couponSelection,
  });
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends BasePageState<CreateOrder> {
  final _formKey = GlobalKey<FormState>();
  Customers details;
  String first, last, city, state = 'Odisha', postcode, apartmnt, flat, address, country = 'India', mobile, mail, giftFrom, giftMsg;
  int selected = 2;
  String title = "Create Order";
  String dropDownValue;
  // BasePage basePage = BasePage();
  DateTime intialdate = DateTime.now();
  DateTime selectedDate;
  bool isCurrentDaySelected = false;

  String firstName;
  String lastName;
  String emailId;
  String phoneNumber;

  String address1;
  String address2;
  String townCity;
  String pinsCode;
  getPinCode() async {
    SharedPreferences pinCodePrefs = await SharedPreferences.getInstance();
    setState(() {
      pinsCode = pinCodePrefs.getString('pinCode') ?? '';
    });
  }

  Api_Services api_services = Api_Services();

  getUser() async {
    Customers customer = await api_services.getCustomersByMail(emailId);
    return customer;
  }

  var userData;
  getUserData() async {
    userData = await getUser();
    setState(() {
      phoneNumber = userData.billing.phone;
      address1 = userData.billing.address1;
      address2 = userData.billing.address2;
      townCity = userData.billing.city;
      // pinsCode = userData.billing.postcode;
    });

    print('userData: ${phoneNumber}');
    print('userData: ${address1}');
  }

  List<String> timeDropDownValuesT = [
    '08:00 AM - 01:00 PM',
    '01:00 PM - 06:00 PM',
    '06:00 PM - 09:00 PM',
  ];
  List<String> timeDropDownValues = [];
  bool showTime = true;

  @override
  void initState() {
    getPinCode();
    super.initState();
    firstName = widget.details.firstName;
    lastName = widget.details.lastName;
    emailId = widget.details.email;
    // phoneNumber = widget.details.billing.phone;
    print('Test: ${widget.shippingFee}');
    print('Name: $firstName');
    getUserData();
    print('getUserData(): ${getUserData()}');
  }

  TextEditingController datePickerController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    print(widget.product);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Choose Delivery Date"),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: datePickerController,
                    decoration: InputDecoration(
                      labelText: 'Dates',
                      hintText: DateFormat.yMd().format(DateTime.now()),
                    ),
                    onChanged: (value) async {},
                    onTap: () async {
                      DateTime now = DateTime.now();
                      DateTime timeLimit = DateTime(now.year, now.month, now.day, 17, 0);

                      if (widget.shippingFee == 200) {
                        selectedDate = intialdate ?? DateTime.now();

                        final midNightTime = DateTime(now.year, now.month, now.day, 23, 00);
                        final currentDateTime = DateTime.now();
                        bool changeDate = true;

                        if (currentDateTime.isAfter(midNightTime)) {
                          print(currentDateTime.isAfter(midNightTime));
                          changeDate = false;
                        }

                        final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                          initialDatePickerMode: DatePickerMode.day,
                          firstDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                          lastDate: DateTime(2101),
                        );

                        if (picked != null && picked != selectedDate) {
                          selectedDate = picked;
                          isCurrentDaySelected = selectedDate.year == DateTime.now().year && selectedDate.month == DateTime.now().month && selectedDate.day == DateTime.now().day;
                          if (isCurrentDaySelected == true) {
                            print(DateTime.now());

                            if (intialdate.isAfter(timeLimit)) {
                              Fluttertoast.showToast(
                                  msg: "Please order before 5PM to deliver the product in same day midnight. Kindly change the date.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        }
                        if (picked != null) {
                          setState(() {
                            datePickerController.text = DateFormat.yMd().format(picked);
                          });
                        }
                      } else if (widget.shippingFee == 75) {
                        final earlyTime = DateTime(now.year, now.month, now.day, 06, 30);
                        final currentDateTime = DateTime.now();
                        bool changeDate = true;

                        if (currentDateTime.isAfter(earlyTime)) {
                          print(currentDateTime.isAfter(earlyTime));
                          changeDate = false;
                        }

                        selectedDate = intialdate ?? DateTime.now();
                        final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                          initialDatePickerMode: DatePickerMode.day,
                          firstDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                          lastDate: DateTime(2101),
                        );

                        if (picked != null && picked != selectedDate) {
                          selectedDate = picked;
                          isCurrentDaySelected = selectedDate.year == DateTime.now().year && selectedDate.month == DateTime.now().month && selectedDate.day == DateTime.now().day;
                          if (isCurrentDaySelected == true) {
                            print(DateTime.now());
                            DateTime timeLimit = DateTime(now.year, now.month, now.day, 17, 0);
                            if (intialdate.isAfter(timeLimit)) {
                              Fluttertoast.showToast(
                                  msg: "Early morning delivery is not available for today. Kindly change the date",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        }
                        if (picked != null) {
                          setState(() {
                            datePickerController.text = DateFormat.yMd().format(picked);
                          });
                        }
                      } else if (widget.shippingFee == 0) {
                        final freeTime = DateTime(now.year, now.month, now.day, 24, 00);
                        final currentDateTime = DateTime.now();
                        bool changeDate = true;

                        if (currentDateTime.isAfter(freeTime)) {
                          print(currentDateTime.isAfter(freeTime));
                          changeDate = false;
                        }

                        DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: intialdate,
                          initialDatePickerMode: DatePickerMode.day,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        // String datetime = DateFormat('H').format(DateTime.now());
                        print('objectPicked: ${picked}');

                        DateTime timeLimit13 = DateTime(now.year, now.month, now.day, 13, 0);
                        DateTime timeLimit08 = DateTime(now.year, now.month, now.day, 08, 0);
                        DateTime timeLimit18 = DateTime(now.year, now.month, now.day, 18, 0);

                        DateTime timeLimit21 = DateTime(now.year, now.month, now.day, 21, 0);
                        final today = DateTime(now.year, now.month, now.day);
                        final pickedDay = DateTime(picked.year, picked.month, picked.day);

                        timeDropDownValues = List.from(timeDropDownValuesT);
                        if (intialdate.isAfter(timeLimit08) && pickedDay == today) {
                          timeDropDownValues.remove('08:00 AM - 01:00 PM');
                        }
                        if (intialdate.isAfter(timeLimit13) && pickedDay == today) {
                          timeDropDownValues.remove('01:00 PM - 06:00 PM');
                        }
                        if (intialdate.isAfter(timeLimit18) && pickedDay == today) {
                          timeDropDownValues.remove('06:00 PM - 09:00 PM');
                        }
                        if (intialdate.isAfter(timeLimit21) && pickedDay == today) {
                          showTime = false;
                          setState(() {});
                          Fluttertoast.showToast(
                            msg: "Free delivery for the day is closed.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (pickedDay == today.add(Duration(days: 1))) {
                          showTime = true;
                        }
                        if (picked != null) {
                          setState(() {
                            datePickerController.text = DateFormat.yMd().format(picked);
                          });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
            widget.shippingFee == 0 && datePickerController.text.isNotEmpty
                ? (showTime
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Time'),
                          DropdownButton<String>(
                            value: dropDownValue,
                            items: timeDropDownValues.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (onChangedValue) {
                              setState(() {
                                dropDownValue = onChangedValue;
                              });
                            },
                          )
                        ],
                      )
                    : Container())
                : Container(),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("First Name"),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Last Name"),
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: firstName,
                    decoration: InputDecoration(
                      hintText: "First Name",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      firstName = value;
                      print(first);
                    },
                    validator: (value) {
                      bool valid = isAlpha(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid name";
                      }
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: TextFormField(
                    initialValue: lastName,
                    decoration: InputDecoration(
                      hintText: "Last Name",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    // onChanged: (String value) {
                    //   print(value);
                    //   last = value;
                    // },
                    validator: (value) {
                      bool valid = isAlpha(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid last name";
                      }
                    },
                  ),
                ),
              ],
            ),
            FormHelper.fieldLabel("Address"),
            TextFormField(
              initialValue: userData.billing.address1,
              decoration: InputDecoration(
                hintText: "Address",
              ),
              maxLines: 2,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                flat = value;
                print(address);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            FormHelper.fieldLabel("Apartmnt ,Flat"),
            TextFormField(
              initialValue: address2,
              decoration: InputDecoration(
                hintText: "Apartmnt ,Flat",
              ),
              maxLines: 1,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                apartmnt = value;
                return;
                print(apartmnt);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Country"),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("State"),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: 'India',
                    decoration: InputDecoration(
                      hintText: "Country",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      country = value;
                      print(country);
                    },
                    validator: (value) {
                      bool valid = isAlpha(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid  country";
                      }
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: "Odisha",
                    decoration: InputDecoration(
                      hintText: "State",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      state = value;
                      print(state);
                    },
                    validator: (value) {
                      bool valid = isAlpha(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid name";
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("City"),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("PostCode"),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: townCity,
                    decoration: const InputDecoration(
                      hintText: "City",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      city = value;
                    },
                    validator: (value) {
                      bool valid = isAlpha(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter the CityName';
                      } else {
                        return "Enter valid name";
                      }
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: pinsCode,
                    decoration: const InputDecoration(
                      hintText: "PostCode",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      postcode = value;
                      print(postcode);
                    },
                    validator: (value) {
                      bool valid = isNumeric(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid PostCode";
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Mobile No."),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Mail Id"),
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: phoneNumber,
                    decoration: InputDecoration(
                      hintText: "Mobile",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      mobile = value;
                      print(first);
                    },
                    validator: (value) {
                      bool valid = isLength(value, 10);
                      bool vali = isNumeric(value);
                      if (valid && vali) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (vali) {
                        return "Enter valid no.";
                      } else if (valid) {
                        return "Enter 10 digit No.";
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: emailId,
                    decoration: InputDecoration(
                      hintText: "Mail Id",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) {
                      print(value);
                      mail = value;
                    },
                    validator: (value) {
                      bool valid = isEmail(value);
                      if (valid) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return "Enter valid Mail Id";
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Gift Message"),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FormHelper.fieldLabel("Gift from"),
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: giftFrom,
                    decoration: const InputDecoration(
                      hintText: "Gift From",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      giftFrom = value;
                      print(giftMsg);
                    },
                    // validator: (value) {
                    //   bool valid = isEmail(value);
                    // if (valid) {
                    //   return null;
                    // } else if (value == null || value.isEmpty) {
                    //   return 'Please enter Gift receiver name';
                    // } else {
                    //   return "Please enter some text";
                    // }
                    // },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    initialValue: giftMsg,
                    decoration: const InputDecoration(
                      hintText: "Gift Message",
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      giftMsg = value;
                      print(first);
                    },
                    // validator: (value) {
                    //   bool valid = isEmail(value);
                    //   if (valid) {
                    //     return null;
                    //   } else if (value == null || value.isEmpty) {
                    //     return 'Please enter some Gift Message name';
                    //   } else {
                    //     return "Please enter some text";
                    //   }
                    // },
                  ),
                ),
              ],
            ),
            Center(
              child: FormHelper.saveButton("Next", () {
                if (_formKey.currentState.validate()) {
                  if (datePickerController.text == null) {
                    Fluttertoast.showToast(
                      msg: "Please Chosen the Delivery Date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyAddress(
                                  shippingMode: widget.shippingFee,
                                  product: widget.product,
                                  id: widget.id,
                                  first: firstName,
                                  last: lastName,
                                  address: flat,
                                  apartmnt: apartmnt,
                                  state: state,
                                  city: city,
                                  country: country,
                                  postcode: pinsCode,
                                  cartProducts: widget.cartProducts,
                                  mobile: phoneNumber,
                                  mail: emailId,
                                  deliveryDate: datePickerController.text,
                                  deliveryTime: dropDownValue,
                                  giftFrom: giftFrom,
                                  giftMsg: giftMsg,
                                  couponSelection: widget.couponSelection,
                                )));
                  }
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
