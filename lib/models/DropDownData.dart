class DropDownData {
  String? values;
  String? description;

  DropDownData({this.values, this.description});

  DropDownData.fromJson(Map<String, dynamic> json) {
    values = json['values'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['values'] = this.values;
    data['description'] = this.description;
    return data;
  }
}
