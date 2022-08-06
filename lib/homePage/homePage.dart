import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
  List<imageModel> modelList=[];
  List<Widget> modelwid=[];
  List<File> imageList=[];
  List<imageModel> imagemodelList=[];
  int countuuid=0;

  List<imageModel> vmp=[];
  late SharedPreferences prefs ;
class _HomePageState extends State<HomePage> {
  File? _img;
  @override
  void initState() {
    super.initState();
    initData();



    // for(int i=0;i <imageUrl.length; i++){
    //   countuuid++; //print(modelList.length);
    //   modelList.add(imageModel(id: "uuid=${countuuid.toString()}",title: imageUrl[i],image: imageUrl[i],order: modelList.length));
    //   print(modelList.length);
    // }
   //  vmp==[]?modelList.forEach((e) {modelwid.add(Card(key: ValueKey(e.image),child: Column(
   //    children: [
   //      Expanded(child: Text(e.id.toString())),
   //      Expanded(child: Text(e.order.toString())),
   //      Expanded(flex:4,child: Image.asset(e.image!)),
   //    ],
   //  ),));}):modelList=vmp;
   // // modelList.sort((a,b){return a.id!.compareTo(b.id!);});

  }
  void initData()async{
    prefs= await SharedPreferences.getInstance();
    setState(() {});
    String? imp=prefs.getString("data");
    var decodedData =jsonDecode(imp!) as List;
    for(var item in decodedData){
      vmp.add(imageModel.fromJson(item));
    }

    countuuid=int.parse(prefs.getString('uuid')??'0');
    modelList=vmp;
    setState(() {

    });
  }
  Future pickImage(ImageSource source) async{
    try{
      final image=await ImagePicker().pickImage(source:source);
      if(image==null) return;
      countuuid++;
      prefs.setString('uuid', countuuid.toString());
      //final imageTemp=File(image.path);
      setState(() {


      });
      print(modelList);
      modelList.insert(0,imageModel(id: "uuid=${countuuid.toString()}",title: image.path.toString().substring(50,68),image:image.path.toString() ,order: modelList!=[]?0:modelList.indexOf(modelList.first)-1
      ));
    }on PlatformException catch(e){print('failed to pick imagefile $e');}

  }
  @override
  Widget build(BuildContext context) {
    modelList.sort((a,b){return a.order!.compareTo(b.order!);});
    return Scaffold(
      appBar: AppBar(
        title: const Text("DragGallery"),
      ),

      body: ReorderableGridView.count(crossAxisCount: 2,
        childAspectRatio: 1.0,
        children:
            modelList.map((imageModel e) =>Card(key: ValueKey(e.image!+e.id.toString()),
              margin:EdgeInsets.all(5),color:Colors.grey.shade800,child: Column(
              children: [
                Expanded(child: Text(e.id.toString(),style: TextStyle(color: Colors.grey.shade50),)),
                Expanded(child: Text(e.title.toString(),style: TextStyle(color: Colors.grey.shade200),)),
                Expanded(flex: 6,
                  child: Row(
                    children: [
                      Expanded(
                          child:  Image.file(File(e.image!),fit: BoxFit.cover,)
                      ),
                    ],
                  ),
                ),
              ],
            ),)).toList(),

        onReorder: (int oldIndex, int newIndex) {
       // imageModel path= modelList.removeAt(oldIndex);
       // modelList.insert(newIndex, path);
       int firstItemIndex= modelList.indexOf(modelList[oldIndex]);
       int nextItemIndex= modelList.indexOf(modelList[newIndex]);
       if(firstItemIndex>nextItemIndex){
         for(int i = modelList.indexOf(modelList[oldIndex]); i>modelList.indexOf(modelList[newIndex]);i--){
           var temp=modelList[i-1];
           modelList[i-1]=modelList[i];
           modelList[i]=temp;
          setState(() {
            var tmp=modelList[i-1].order;
            modelList[i-1].order=modelList[i].order;
            modelList[i].order=tmp;
          });
         }


       }else{
         for(int i =modelList.indexOf(modelList[oldIndex]); i< modelList.indexOf(modelList[newIndex]);i++) {
           var temp = modelList[i + 1];
           //if(modelList[i+1].order==modelList[i].order){modelList[i+1].order=modelList[i-1].order;}
           modelList[i + 1] = modelList[i];
           modelList[i]=temp;
           setState(() {
             var tmp = modelList[i + 1].order;
             modelList[i + 1].order = modelList[i].order;
             modelList[i].order=tmp;
           });
         }
       }
        setState(() { // modelList[oldIndex].order=newIndex;
        });
       modelList.sort((a,b){return a.order!.compareTo(b.order!);});
       String imp=jsonEncode(modelList);
       prefs.setString("data", imp);

        },


      ),
    bottomNavigationBar: Container( height: 80, decoration: BoxDecoration(color: Colors.blue),
      child: Row(children: [
        Expanded(child: Column(
          children: [
            IconButton(icon:const
            Icon( Icons.picture_in_picture_alt,color: Colors.white,),
              onPressed:()async{
             await pickImage(ImageSource.gallery);
              //modelList=[];
              String imp=jsonEncode(modelList);
              prefs.setString("data", imp);
            }),
            const Text('Add from Gallery',style: TextStyle(color: Colors.white, ),),
          ],
        )),
        Expanded(child: Column(
          children: [
            IconButton(icon:const Icon( Icons.camera,color: Colors.white,), tooltip: "icon",
                onPressed:(){
              pickImage(ImageSource.camera);
              String imp=jsonEncode(modelList);
              prefs.setString("data", imp);

            }),
            const Text('Add from Camera',style: TextStyle(color: Colors.white,)),
          ],
        ))
    ],),
    ),
    );
  }
}
