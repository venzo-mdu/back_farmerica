import 'package:flutter/material.dart';
import 'package:farmerica/form_helper.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/payment.dart';

// ignore: must_be_immutable
class VerifyAddress extends BasePage {
  List product = [];
  final int id;
  final String first,
      last,
      city,
      state,
      postcode,
      apartmnt,
      flat,
      address,
      country,
      mobile,
      mail,
      giftFrom,
      giftMsg;
  var shippingMode;
  final String deliveryDate;
  final String deliveryTime;
  String couponSelection;

  List<CartProducts> cartProducts;

  VerifyAddress(
      {this.id,
      this.mobile,
      this.mail,
      this.address,
      this.product,
      this.apartmnt,
      this.city,
      this.country,
      this.first,
      this.flat,
      this.last,
      this.postcode,
      this.state,
      this.cartProducts,
      this.deliveryDate,
      this.deliveryTime,
      this.giftMsg,
      this.giftFrom,
      this.shippingMode,
      this.couponSelection,
      });
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends BasePageState<VerifyAddress> {
  int selected = 2;
  String title = "";
  // BasePage basePage = BasePage();
  @override
  void initState() {
    print('verifyPage: ${widget.product}');
    super.initState();
    // basePage.title = "Checkout Page";
    // basePage.selected = 2;
  }
  bool showDropDownValue = true;

  @override
  Widget body(BuildContext context) {
    if(widget.deliveryTime == null) {
      showDropDownValue = false;
    }

    // print(widget.product);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Delivery Date"),
                    ),
                    Visibility(
                      visible: showDropDownValue,
                      child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: FormHelper.fieldLabel("Delivery Time"),
                      ),
                    )
                  ],
                ),



                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValu(context, widget.deliveryDate),
                      ),
                    ),
                    Visibility(
                      visible: showDropDownValue,
                      child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormHelper.fieldLabelValu(context, widget.deliveryTime),
                        ),
                      ),
                    ),
                  ],
                ),




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
                      child: FormHelper.fieldLabel("First Name"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValu(context, widget.first),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormHelper.fieldLabelValu(context, widget.last),
                      ),
                    ),
                  ],
                ),
                FormHelper.fieldLabel("Address"),
                FormHelper.fieldLabelValu(context, widget.address),
                FormHelper.fieldLabel("Apartmnt ,Flat"),
                FormHelper.fieldLabelValu(context, widget.apartmnt),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabel("Country"),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormHelper.fieldLabel("State"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                            FormHelper.fieldLabelValu(context, widget.country),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormHelper.fieldLabelValu(context, widget.state),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabel("City"),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormHelper.fieldLabel("PostCode"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValu(context, widget.city),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            FormHelper.fieldLabelValu(context, widget.postcode),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabel("Gift From"),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormHelper.fieldLabel("Gift Msg"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValu(context, widget.giftFrom),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        FormHelper.fieldLabelValu(context, widget.giftMsg),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: FormHelper.saveButton("Confirm", () {
                    final route = MaterialPageRoute(
                        builder: (context) => PaymentGateway(
                          shippingMode: widget.shippingMode,
                          first: widget.first,
                          last: widget.last,
                          cartProducts: widget.cartProducts,
                          id: widget.id,
                          city: widget.city,
                          country: widget.country,
                          postcode: widget.postcode,
                          address: widget.address,
                          apartmnt: widget.apartmnt,
                          state: widget.state,
                          flat: widget.flat,
                          mail: widget.mail,
                          deliveryDate: widget.deliveryDate,
                          deliveryTime: widget.deliveryTime,
                          giftFrom: widget.giftFrom,
                          giftMsg: widget.giftMsg,
                          mobile: widget.mobile,
                          product: widget.product,
                          couponSelection: widget.couponSelection,
                        ));
                    Navigator.push(
                        context,
                        route);
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
