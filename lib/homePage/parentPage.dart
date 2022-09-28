import 'dart:convert';

import 'package:drag_gallery/models/model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/parentModel.dart';
import 'homePage.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({Key? key,}) : super(key: key);

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  List<ParentModel> parentList = [];
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initData();
  }
  @override

  void initData()async{
    var decodedData;
   prefs= await SharedPreferences.getInstance();
   var data = prefs.getString("data");
   if (data !=null){
     decodedData = jsonDecode(data) as List;
   }else{
     var fn= await DefaultAssetBundle.of(context).loadString("assets/imageData.json");
     decodedData=jsonDecode(fn) as List;
     print("${decodedData[1]}");
     print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
     print("${decodedData[1]}");
   }
   for (var item in decodedData){
     parentList.add(ParentModel.fromJson(item));
     print(parentList.length);
   }
    setState(() {

    });

  }
  Widget build(BuildContext context) {
   // parentList.add(ParentModel(name: "", listz: [imageModel.fromJson(json)]));
    return parentList==[] ?
    const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,)) :
    Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ParentPage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parentList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector( onTap: (){
                  print(parentList[index].classId);
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>HomePage(parentModel: parentList[index],dats:parentList[index].classId,index:index))).then((value){setState(() {

                  });});},
                  child: Container( margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                    color: Colors.blueAccent,
                    child: Center(child: Text("hellosaloma $index ${parentList[index].listz![0].title},")),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
