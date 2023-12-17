import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:utas/screens/history.dart';
import 'package:utas/screens/preview.dart';
import 'package:utas/settings/sizes.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController controller;
  ScrollController scrollController=ScrollController();
  bool clicked = false;
  bool frontCamera = false;
  bool flash = false;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) async{
    _currentScale = (_baseScale * details.scale).clamp(1.0, await controller.getMaxZoomLevel());

    setState(()  {
      controller.setZoomLevel(_currentScale);
    });
  }
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.low,enableAudio: false,);
    controller.initialize().then((_) {
      // controller.setZoomLevel(1.5);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xff1d1b20),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40,),
        height: Sizes.height(context),
        width: Sizes.width(context),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(
                          0xff47444c),
                    ),
                    child: IconButton(onPressed: (){}, icon:  Icon(Icons.person,color: Colors.white.withOpacity(0.5),)),
                  ),

                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(
                          0xff47444c),
                    ),
                    child: Text("Add Friends",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 17),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(
                          0xff47444c),
                    ),
                    child: IconButton(onPressed: (){}, icon:  Icon(Icons.chat_bubble_outline,color: Colors.white.withOpacity(0.5),)),
                  ),

                ],
              ),
            ),

            SingleChildScrollView(
              controller: scrollController,
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details){

                      if(details.delta.dy<0){
                        print("swipe up");
                        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),

                      width: Sizes.width(context),
                      height: Sizes.height(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onDoubleTap: (){
                              changeCamera();
                            },

                            onScaleUpdate: _onScaleUpdate,
                            onScaleStart: _onScaleStart,
                            child: Container(

                              margin: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),

                              ),
                              width:Sizes.width(context),
                              height: Sizes.width(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),

                                child: CameraPreview(controller,child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      bottom: 10,

                                      child:  Container(
                                        alignment: Alignment.center,
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          // color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(100),

                                        ),
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text(
                                                  _currentScale.toStringAsFixed(1),
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(onPressed: () async {
                                  await  controller.setFlashMode(flash==false?FlashMode.always:FlashMode.off);

                                  setState(() {
                                    flash=!flash;
                                  });
                                }, icon: Icon(flash?Icons.flash_on_outlined:Icons.flash_off_outlined,color: Colors.white,size: 40,)),

                                Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: Color(0xffFCB600),width: 5),

                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          clicked=!clicked;
                                        });
                                        controller.takePicture().then((value) {
                                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePreview(imagePath: value.path,)));
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context, builder: (context)=>ImagePreview(imagePath: value.path, onSend: () {
                                                setState(() {

                                                });
                                          },));
                                        });
                                      },
                                      onLongPress: (){
                                        setState(() {
                                          clicked=!clicked;
                                        });
                                      },

                                      child: AnimatedContainer(
                                        onEnd: (){
                                          setState(() {
                                            clicked=false;
                                          });
                                        },
                                        duration: Duration(milliseconds: 100),
                                        width: clicked?50:80,
                                        height:clicked?50:80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: clicked?Color(0xff47444c):Colors.white,

                                        ),

                                      ),
                                    )



                                ),
                                IconButton(onPressed: (){
                                  changeCamera();
                                }, icon: const Icon(Icons.flip_camera_ios_outlined,color: Colors.white,size: 40,)),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            width: 125,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(

                                      alignment: Alignment.center,
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(
                                            0xff47444c),
                                      ),
                                      child: Icon(Icons.photo,color: Colors.white.withOpacity(0.5),size: 30,),
                                    ),
                                    Text("History",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 20,fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white.withOpacity(0.5),size: 40,weight: 10,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onVerticalDragUpdate: (details){

                      if(details.delta.dy>0){
                        print("swipe down");
                        scrollController.animateTo(scrollController.position.minScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                      width: Sizes.width(context),
                      height: Sizes.height(context),
                      child: HistoryScreen(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  changeCamera(){
    controller=CameraController(cameras[frontCamera?0:1], ResolutionPreset.ultraHigh,enableAudio: false,);

     controller.initialize().then((_) {



      if (!mounted) {
        return;
      }
      setState(() {
        frontCamera=!frontCamera;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':

            break;
          default:
            break;
        }
      }
    });
  }
}
