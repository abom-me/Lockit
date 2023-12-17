import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:utas/settings/global.dart';
import 'package:utas/settings/sizes.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    print(images.length);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        height: Sizes.height(context),
        width: Sizes.width(context),
        child:images.isEmpty?Container(
          child: const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported,size: 100,color: Colors.white,),
              Text("No Images Yet,\n Try To Take Photo",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
            ],
          )),
        ):ListView.builder(

          padding: const EdgeInsets.only(top: 150,left: 15,right: 15 ),
            itemCount: images.length,
            itemBuilder: (context,i){

          return Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 200,
            width: Sizes.width(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: FileImage(File(images[i])),
                fit: BoxFit.cover
              )
            ),
            child: Container(
width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          images.removeAt(i);
                        });
                      },

                      child: Icon(Icons.delete,size: 30,color: Colors.white.withOpacity(0.5),)),


                  ),
                ),
              ),
            ),
          );

        }) );
  }
}
