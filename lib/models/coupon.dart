class Coupon {
  int id;
  String code;
  String amount;
  String status;
  DateTime dateCreated;
  String discountType;
  String description;
  DateTime dateExpires;

  Coupon({
    this.id,
    this.code,
    this.amount,
    this.status,
    this.dateCreated,
    this.discountType,
    this.description,
    this.dateExpires,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    status = json['status'];
    dateCreated = json['dateCreated'];
    discountType = json['discountType'];
    description = json['description'];
    dateExpires = json['dateExpires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['dateCreated'] = this.dateCreated;
    data['discountType'] = this.discountType;
    data['description'] = this.description;
    data['dateExpires'] = this.dateExpires;

    return data;
  }
}
