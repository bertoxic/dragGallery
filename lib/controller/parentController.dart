

import 'package:get/get_state_manager/get_state_manager.dart';
import '../models/parentModel.dart';

class ParentController extends GetxController {

  //ParentModel parentModel =ParentModel();

  List <ParentModel> parentList=[];


  ParentModel addToParent( String classID,List<ImageModel> k ){
   ParentModel vee= ParentModel(classId: classID,listz: k);
   return vee;

  }


}