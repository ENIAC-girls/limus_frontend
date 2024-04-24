import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'infoFoodScreen .dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void sendImageToAPI(String imagePath) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://limus-api-nutrion.onrender.com/foodNutrition?haveImage=true'),
  );

  Map<String, String> headers = { "Content-type": "multipart/form-data"};

  request.headers.addAll(headers);

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    imagePath,
    filename: path.basename(imagePath),
  ));

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('API Response: $responseBody');
    } else {
      print('Error sending image to API: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending image to API: $e');
  }
} 

class PhotosScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PhotosScreen(this.cameras, {super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  late CameraController controller;
  bool isCapturing = false;
  int _selectedCameraIndex = 0;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[_selectedCameraIndex], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleFlashLight(bool turnOn) {
  if (turnOn) {
    controller.setFlashMode(FlashMode.torch);
    setState(() {
      _isFlashOn = true;
    });
  } else {
    controller.setFlashMode(FlashMode.off);
    setState(() {
      _isFlashOn = false;

    });
  }
}


  void _toggleCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _selectedCameraIndex = _isFrontCamera ? 1 : 0;
      controller = CameraController(widget.cameras[_selectedCameraIndex], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  IconData _getCameraIcon() {
    return _isFrontCamera ? Icons.cameraswitch_rounded : Icons.cameraswitch_sharp;
  }
void capturePhoto() async {
  if (!controller.value.isInitialized) {
    return;
  }

  final Directory appDir = await pathProvider.getApplicationSupportDirectory();
  path.join(appDir.path, '${DateTime.now()}.jpg');

  if (controller.value.isTakingPicture) {
    return;
  }

  try {
    setState(() {
      isCapturing = true;
    });

    XFile captureImage = await controller.takePicture();

    await GallerySaver.saveImage(captureImage.path);

    print("Photo captured and saved to gallery.");

    sendImageToAPI(captureImage.path);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoFoodScreen(captureImage.path)),
    );

  } catch (e) {
    print("Error capturing photo: $e");
  } finally {
    if (_isFlashOn) {
      _toggleFlashLight(false);
    }
    setState(() {
      isCapturing = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller),
                        )
                      : Container(),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              _toggleFlashLight(true);
                            },
                            child: _isFlashOn ? const Icon(Icons.flash_on, color: Colors.white) : const Icon(Icons.flash_off, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleCamera,
                          icon: Icon(
                            _getCameraIcon(),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    capturePhoto();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 4,
                                            color: const Color(0xFFB2DE97),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFB2DE97),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),  
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
