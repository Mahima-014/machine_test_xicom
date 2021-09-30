class FormModel {
  String first_name;
  String last_name;
  String email;
  String phone;
  String imagePath;

  FormModel(
      {this.first_name, this.last_name, this.email, this.phone, this.imagePath});

  FormModel.fromJson(Map<String, dynamic> json) {
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['imagePath'] = this.imagePath;
    return data;
  }
}