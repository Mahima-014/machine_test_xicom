import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test_xicom/helper/db_helper.dart';
import 'package:machine_test_xicom/model/image_model.dart';
import 'package:machine_test_xicom/views/details_screen.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Images> images = [];
  int offset = 0;
  String imagePath="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DB.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Images>>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async{
                            await downloadImageFromUrl(snapshot.data[index].xtImage, snapshot.data[index].id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailsScreen(imagePath)),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title:CachedNetworkImage(
                                imageUrl: snapshot.data[index].xtImage,
                                placeholder: (context, url) => Container(width:50, height: 50,child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
              future: getDataFromAPI(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/23,
            ),
            InkWell(
                onTap: (){
                  setState(() {
                    offset++;
                  });
                  getDataFromAPI();
                },
                child: Text("Load more...", style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold
                ),)),
          ],
        ),
      ),
    );}
  

  Future<List<Images>> getDataFromAPI() async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "user_id": "108",
      "offset": "$offset",
      "type": "popular",
    });
    var response = await dio.post("http://dev3.xicom.us/xttest/getdata.php",
        data: formData);
    print("response == ${response.data}");
    var data = json.decode(response.data);

    data["images"].forEach((element) {
      images.add(Images.fromJson(element));
    });

    return images;
  }

  downloadImageFromUrl(String url, String id) async
  {
    var response = await http.get(Uri.parse(url)); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/${id}.jpg';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    setState(() {
      imagePath = filePathAndName;
    });
  }
}
