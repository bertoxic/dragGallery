import 'dart:convert';
import 'dart:io';
import 'package:drag_gallery/models/parentModel.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/model.dart';

 class HomePage extends StatefulWidget {
 const HomePage({Key? key,this.parentModel,this.dats, this.index}) : super(key: key);
 final ParentModel? parentModel;
 final String? dats;
 final int? index;
  @override

  State<HomePage> createState() => _HomePageState();
}
  List<ImageModel> modelList=[];
  //List<Widget> modelwid=[];
  List<ParentModel> parentList=[];
  int countuuid=0;
  bool isLoaded=false;
  List<ParentModel> vmp=[];
  late SharedPreferences prefs;

  enum TtsState{playing,stopped}
  late FlutterTts _flutterTts;
  TtsState _ttsState= TtsState.stopped;
  String? _tts;

  class _HomePageState extends State<HomePage> {
  //File? _img;
  @override
  void initState() {
    super.initState();
    initData();
    initTts();



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
  @override
  void dispose(){
    super.dispose();
    _flutterTts.stop();
  }
  Future<void> initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setErrorHandler((message) {
      setState(() {
        print("Error: $message");
        _ttsState = TtsState.stopped;
      });
    });
  }
  void initData()async{
    prefs= await SharedPreferences.getInstance();
    List decodedData;
    setState(() {});
    String? imp=prefs.getString("${widget.dats}");
    if(imp==null){
      isLoaded=false;
      print("empty list gotten $imp");
    var fn= await DefaultAssetBundle.of(context).loadString("assets/imageData.json");

    decodedData =jsonDecode(fn) as List;
      } else{
      isLoaded=true;
      decodedData =jsonDecode(imp) as List;
    }

    for(var item in decodedData){
     // vmp.add(ImageModel.fromJson(item));
      vmp.add(ParentModel.fromJson(item));
    }

    countuuid=int.parse(prefs.getString('uuid')??'0');
   // modelList=vmp;
    parentList=vmp;
    modelList=parentList[widget.index!].listz!;
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
      modelList.insert(0,ImageModel(id: "uuid=${countuuid.toString()}",title: image.path.toString().substring(50,68),image:image.path.toString() ,isAssets:false,order: modelList!=[]?0:modelList.indexOf(modelList.first)-1
      ));
    }on PlatformException catch(e){print('failed to pick imagefile $e');}

  }
  @override
  Widget build(BuildContext context) {
    modelList.sort((a,b){return a.order!.compareTo(b.order!);});
    List<ImageModel> mint = widget.parentModel!.listz!;

      return Scaffold(
      appBar: AppBar(
        title: const Text("DragGallery"),
      ),

      body: ReorderableGridView.count(crossAxisCount: 3,
        childAspectRatio: 1.0,
        children:
            modelList.map((ImageModel e) =>Card(key: ValueKey(e.image!+e.id.toString()),
              margin:const EdgeInsets.all(5),color:Colors.grey.shade800,
              child: GestureDetector( onTap: ()async{
                //   print("what is null here ${e.title}");
                _tts=e.title??"kioooooooo is good";
                await _flutterTts.setVolume(1);
                await _flutterTts.setSpeechRate(0.5);
                await _flutterTts.setPitch(1);
                await _flutterTts.speak(_tts!);
                print("what is null here ${e.title}");

              },
                child: Column(
                children: [
                  Expanded(child: Text(e.id.toString(),style: TextStyle(color: Colors.grey.shade50),)),
                  Expanded(child: Text(e.title.toString(),style: TextStyle(color: Colors.grey.shade200),)),
                  Expanded(flex: 6,
                    child: Row(
                      children: [
                        Expanded(
                            child: !e.isAssets!? Image.file(File(e.image!),fit: BoxFit.cover,):Image.asset(e.image!,fit: BoxFit.cover,)
                           // child:  Image.file(File(e.image!),fit: BoxFit.cover,)
                        ),
                      ],
                    ),
                  ),
                ],
            ),
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
         parentList.removeAt(widget.index!);
         parentList.insert(widget.index!,ParentModel(classId: "${widget.dats}",listz:modelList));
         String imp=jsonEncode(parentList);
         prefs.setString("${widget.dats}", imp);



        },


      ),
    bottomNavigationBar: Container( height: 80, decoration: BoxDecoration(color: Colors.blue),
      child: Row(children: [
        Expanded(child: Column(
          children: [
            IconButton(icon:const
            Icon( Icons.picture_in_picture_alt,color: Colors.white,),
              onPressed:()async{
                setState(() {
                  if (!isLoaded){
                    //modelList=[];
                  }
                  //  modelList=[];
                  isLoaded=true;
                });
                await pickImage(ImageSource.gallery);
                parentList[widget.index!]=ParentModel(classId: "${widget.dats}",listz:modelList);
                String imp=jsonEncode(parentList);
                prefs.setString("${widget.dats}", imp);
            }),
            const Text('Add from Gallery',style: TextStyle(color: Colors.white, ),),
          ],
        )),
        Expanded(child: Column(
          children: [
            IconButton(icon:const Icon( Icons.camera,color: Colors.white,), tooltip: "icon",
              onPressed:(){
              isLoaded=true;
              pickImage(ImageSource.camera);
              parentList[widget.index!]=ParentModel(classId: "${widget.dats}",listz:modelList);
              String imp=jsonEncode(parentList);
               prefs.setString("${widget.dats}", imp);
            }),
            const Text('Add from Camera',style: TextStyle(color: Colors.white,)),
          ],
        ))
    ],),
    ),
    );
  }
}

Future<String>getStorage()async{
    if (Platform.isAndroid){
      return (await getExternalStorageDirectory())!.path;
    }else{
      return (await getApplicationDocumentsDirectory()).path;
    }
}