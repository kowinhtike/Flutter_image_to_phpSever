import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late File _image;
  String message = '';

  bool loading = false;

  TextEditingController td = TextEditingController();
  TextEditingController td2 = TextEditingController();


  pickImage() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
          loading = true;
          print("Success");
        });
      } else {
        print('User didnt pick any image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadImage(uploadimage) async {
    var uploadurl = Uri.parse(td.text);
    try{
      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //print(baseimage);
      var response = await http.post(
          uploadurl,
          body: {
            'file': baseimage,
          }
      );
      print(response);
      if(response.statusCode == 200){
       // print(response.body);
        var jsondata = json.decode(response.body);
        if(jsondata["error"]){
          print(jsondata["msg"]);
        }else{
          print("Upload successful");
        }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print("Error during converting to Base64");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          TextField(controller:td ,),
          //TextField(controller:td2 ,),
          Text(message),
          Visibility(child: CircularProgressIndicator(),visible: loading,),
          loading ? Image(image:FileImage(_image) ,width: 300,height: 400,) : Container() ,
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                   pickImage();
                  },
                  child: Text('Pick Image'),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                  uploadImage(_image);
                  },
                  child: Text('upload image'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
