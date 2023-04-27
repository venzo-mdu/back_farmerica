class BundledProduct {
  int id;
  String name;
  String catalog_visibility;
  String description;
  List<Images> images;
  List<MetaData> metaData;

  BundledProduct({this.id, this.name, this.catalog_visibility, this.description, this.images, this.metaData});

  BundledProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    catalog_visibility = json['catalog_visibility'];
    description = json['description'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData.add(MetaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['catalog_visibility'] = catalog_visibility;
    data['description'] = description;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (metaData != null) {
      data['meta_data'] = metaData.map((v) => v.toJson()).toList();
    }
  }
}

class Images {
  int id;
  String dateCreated;
  String dateCreatedGmt;
  String dateModified;
  String dateModifiedGmt;
  String src;
  String name;
  String alt;

  Images({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.src,
    this.name,
    this.alt,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModified = json['date_modified'];
    dateModifiedGmt = json['date_modified_gmt'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date_created'] = dateCreated;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified'] = dateModified;
    data['date_modified_gmt'] = dateModifiedGmt;
    data['src'] = src;
    data['name'] = name;
    data['alt'] = alt;
    return data;
  }
}

class MetaData {
  List<MetaData> metaData;
  MetaData({this.metaData});

  MetaData.fromJson(Map<String, dynamic> json) {
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData.add(MetaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metaData != null) {
      data['meta_data'] = metaData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MetaDataId {
  int id;
  String key;
  dynamic value;

  MetaDataId({
    this.id,
    this.key,
    this.value,
  });

  MetaDataId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'] != null ? value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    if (value != null) {
      data['value'] = value.toJson();
    }
    return data;
  }



}

class ValueValue {
  ValueValue({
    this.id,
    this.sku,
    this.qty,
  });

  String id;
  String sku;
  String qty;

  factory ValueValue.fromJson(Map<String, dynamic> json) => ValueValue(
        id: json["id"],
        sku: json["sku"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "qty": qty,
      };
}
