import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_xicom/helper/db_helper.dart';
import 'package:machine_test_xicom/model/form_model.dart';
import 'package:machine_test_xicom/model/image_model.dart';

class DetailsScreen extends StatefulWidget {
  String imageUrl;

  DetailsScreen(this.imageUrl);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  DB database = DB();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print('image url = ${widget.imageUrl}');
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                      child: Image.file(
                          File(widget.imageUrl)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/23,
                  ),
                  buildTF('First Name', firstNameController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/23,
                  ),
                  buildTF('Last Name', lastNameController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/23,
                  ),
                  buildEmailTF('Email', emailController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/23,
                  ),
                  buildPhoneNumberTF('Phone Number', phoneNumberController),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/23,
                  ),
                  buildSubmitBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget TF(String text)
  // {
  //   return Text(
  //     '$text',
  //     style: TextStyle(
  //       fontSize: 10,
  //     ),
  //   );
  // }

  Widget buildTF(String name, TextEditingController cntrl) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: cntrl,
      validator: (value) {
        if (value.isEmpty) return "$name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter $name",
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget buildEmailTF(String name, TextEditingController cntrl) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: cntrl,
      validator: (value) {
        if (value.isEmpty) return "$name address can't be empty";
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter $name",
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget buildPhoneNumberTF(String name, TextEditingController cntrl) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: cntrl,
      validator: (value) {
        if (value.isEmpty)
          return "$name can't be empty";
        else if(value.length<10 || value.length>10)
          return "Enter valid phone number";

        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter $name",
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }


  Widget buildSubmitBtn() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {

              FormModel data = FormModel(first_name: firstNameController.text, last_name: lastNameController.text, email: emailController.text, phone: phoneNumberController.text, imagePath: widget.imageUrl);
             await sendDataToServer(data);
             saveDataInDatabase(data);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Your data is saved"),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
              padding:
              EdgeInsets.only(top: 12, left: 30, right: 30, bottom: 12),
              primary: Colors.black,
              elevation: 5.0),
          child: Text(
            'SUBMIT',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  void sendDataToServer(FormModel dataModel) async{
    
    var dio = Dio();
    var response;
    String fileName = dataModel.imagePath.split('/').last;
    FormData formData = FormData.fromMap({
      "user_image":
      await MultipartFile.fromFile(dataModel.imagePath, filename:fileName),
      "first_name" : dataModel.first_name,
      "last_name" : dataModel.last_name,
      "email" :  dataModel.email,
      "phone" : dataModel.phone,
    });

    response = await dio.post("http://dev3.xicom.us/xttest/savedata.php", data: formData);
    print(response);

  }

  void saveDataInDatabase(FormModel dataModel)
  {
    DB db = DB();
    db.insertDataInDB("FormDetails", dataModel.toJson());
    db.getRecordsFromDB("SELECT * FROM FormDetails");
  }
}
