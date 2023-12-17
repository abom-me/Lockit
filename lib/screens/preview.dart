import 'dart:io';

import 'package:flutter/material.dart';
import 'package:utas/settings/global.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key, required this.imagePath, required this.onSend});
final String imagePath;
final void Function() onSend;
  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,

      child: Scaffold(
        backgroundColor: const Color(0xff1d1b20),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: FileImage(File(widget.imagePath)),
                      fit: BoxFit.cover
                    )
                  ),

                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      IconButton(onPressed: (){
                        images.add(widget.imagePath);
                        widget.onSend();
                        Navigator.pop(context);
                        setState(() {

                        });
                      }, icon: const Icon(Icons.send,size: 50,),),

                    ],
                  ),
                )
            ],
          ),
        )
      ),
    );
  }
}
