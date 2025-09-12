import 'package:ai_therapy/Controllers/chat_controller.dart';
import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/constants.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import 'customize_attributes_screen.dart';

class VideoConversationPage extends StatefulWidget {
  const VideoConversationPage({super.key});

  @override
  State<VideoConversationPage> createState() => _VideoConversationPageState();
}

class _VideoConversationPageState extends State<VideoConversationPage>
    with TickerProviderStateMixin {
  late ChatController chatController;
  late UserController userController;
  late AnimationController _animController;

  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraOn = false;
  bool isCameraInitialized = false;
  CameraLensDirection currentLens = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();

    // Controllers
    userController = Get.put(UserController());
    chatController = Get.put(ChatController());
    _animController = AnimationController(vsync: this);

    // Permissions and camera
    _requestPermissionsAndInitCamera();
  }

  Future<void> _requestPermissionsAndInitCamera() async {
    var cameraStatus = await Permission.camera.request();
    var micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        CameraDescription frontCamera = cameras!.firstWhere(
                (cam) => cam.lensDirection == CameraLensDirection.front,
            orElse: () => cameras!.first);
        _cameraController =
            CameraController(frontCamera, ResolutionPreset.high);
        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          isCameraInitialized = true;
          isCameraOn = true;
          currentLens = CameraLensDirection.front;
        });
      }
    } else {
      Get.snackbar(
        "Permissions Denied",
        "Camera and microphone permissions are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _toggleCamera() async {
    if (isCameraOn) {
      await _cameraController?.dispose();
      setState(() {
        isCameraOn = false;
        isCameraInitialized = false;
      });
    } else {
      _switchCamera(currentLens);
    }
  }

  void _switchCamera(CameraLensDirection lensDirection) async {
    if (cameras != null && cameras!.isNotEmpty) {
      CameraDescription selectedCamera = cameras!.firstWhere(
              (cam) => cam.lensDirection == lensDirection,
          orElse: () => cameras!.first);

      _cameraController = CameraController(selectedCamera, ResolutionPreset.high);
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        isCameraOn = true;
        isCameraInitialized = true;
        currentLens = lensDirection;
      });
    }
  }

  void _switchFrontBack() {
    if (currentLens == CameraLensDirection.front) {
      _switchCamera(CameraLensDirection.back);
    } else {
      _switchCamera(CameraLensDirection.front);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: Obx(
              () => chatController.loading.value
              ? const Center(child: Text("Getting ready.."))
              : SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row (robot image + settings)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/robot.png",
                        height: 120,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                                () => const CustomizeAttributesScreen(
                              saveDetails: true,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        icon: const Icon(Icons.settings),
                        color: sliderGreen,
                        iconSize: 35,
                      ),
                    ],
                  ),

                  // Camera container
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black54,
                      ),
                      child: isCameraOn &&
                          isCameraInitialized &&
                          _cameraController != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(_cameraController!),
                      )
                          : const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ).animate().fadeIn(),
                  ),

                  const SizedBox(height: 20),

                  // Start Speaking / Lottie container
                  Obx(() => chatController.isListening.value
                      ? chatController.isListeningDone.value
                      ? Animate(
                    child: Lottie.asset(
                      'assets/speaking.json',
                      height: 200,
                      controller: _animController,
                      onLoaded: (composition) {
                        _animController.duration =
                            composition.duration;
                        _animController.repeat();
                      },
                    ),
                  ).fadeIn()
                      : Animate(
                    child: Lottie.asset(
                      'assets/listening.json',
                      height: 100,
                      controller: _animController,
                      onLoaded: (composition) {
                        _animController.duration =
                            composition.duration;
                        _animController.forward();
                      },
                    ),
                  ).fadeIn()
                      : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        chatController.startListening();
                      },
                      icon: const Icon(
                        Icons.mic,
                        size: 40,
                        color: sliderGreen,
                      ),
                    ),
                  ).animate().fadeIn()),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Toggle camera on/off
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isCameraOn ? sliderGreen : Colors.red,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: _toggleCamera,
                icon: Icon(
                  isCameraOn
                      ? CupertinoIcons.video_camera
                      : CupertinoIcons.video_camera,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),

            // Start Speaking / Text
            chatController.isListeningDone.value
                ? const SizedBox()
                : Text(
              chatController.isListening.value
                  ? "Listening.."
                  : "Start Speaking by pressing\nthe above button",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.black26),
            ),

            // Cancel / Pause
            if (chatController.isListeningDone.value)
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    chatController.stopListening();
                  },
                  icon: const Icon(CupertinoIcons.pause),
                  color: Colors.white,
                  iconSize: 35,
                ),
              ),
            if (chatController.isListeningDone.value)
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    chatController.stopListening();
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                  color: Colors.white,
                  iconSize: 35,
                ),
              ),

            // Switch front/back camera
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: _switchFrontBack,
                icon: const Icon(
                  CupertinoIcons.switch_camera,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
