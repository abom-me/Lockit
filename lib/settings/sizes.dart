

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
 List<CameraDescription> cameras=[];

class Sizes{

 static double height(context){
    return MediaQuery.of(context).size.height;
  }
 static double width(context){
    return MediaQuery.of(context).size.width;
  }

}