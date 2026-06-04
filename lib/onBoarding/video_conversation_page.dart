import 'package:ai_therapy/Controllers/chat_controller.dart';
import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/custom_background.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_theme.dart';
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
        backgroundColor: AppColors.errorRed.withOpacity(0.2),
        colorText: AppColors.starWhite,
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

      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.high);
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
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: AppColors.auroraLavender,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Getting ready..",
                          style: AppTypography.bodyMedium),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top row (robot image + settings)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/robot.png", height: 100),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => const CustomizeAttributesScreen(
                                    saveDetails: true,
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.glassWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: AppColors.glassBorder, width: 1),
                                ),
                                child: const Icon(
                                  Icons.settings_rounded,
                                  color: AppColors.auroraLavender,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Camera container
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppColors.cosmicIndigo,
                              border: Border.all(
                                color: AppColors.glassBorder,
                                width: 1,
                              ),
                            ),
                            child: isCameraOn &&
                                    isCameraInitialized &&
                                    _cameraController != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    child:
                                        CameraPreview(_cameraController!),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.videocam_off_rounded,
                                      color: AppColors.moonGray.withOpacity(0.4),
                                      size: 64,
                                    ),
                                  ),
                          ).animate().fadeIn(),
                        ),

                        // Lottie / Mic area
                        Obx(() => chatController.isListening.value
                            ? chatController.isListeningDone.value
                                ? Animate(
                                    child: Lottie.asset(
                                      'assets/speaking.json',
                                      height: 140,
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
                                      height: 80,
                                      controller: _animController,
                                      onLoaded: (composition) {
                                        _animController.duration =
                                            composition.duration;
                                        _animController.forward();
                                      },
                                    ),
                                  ).fadeIn()
                            : GestureDetector(
                                onTap: () =>
                                    chatController.startListening(),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.glassWhite,
                                    border: Border.all(
                                      color: AppColors.auroraLavender
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.auroraLavender
                                            .withOpacity(0.15),
                                        blurRadius: 20,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.mic_rounded,
                                    size: 36,
                                    color: AppColors.auroraLavender,
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
            // Toggle camera
            _buildControlButton(
              icon: CupertinoIcons.video_camera,
              color: isCameraOn ? AppColors.auroraTeal : AppColors.errorRed,
              onPressed: _toggleCamera,
            ),

            // Status text or controls
            chatController.isListeningDone.value
                ? const SizedBox()
                : Text(
                    chatController.isListening.value
                        ? "Listening.."
                        : "Start Speaking by pressing\nthe above button",
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.moonGray.withOpacity(0.5),
                    ),
                  ),

            if (chatController.isListeningDone.value)
              _buildControlButton(
                icon: CupertinoIcons.pause,
                color: AppColors.cosmicIndigo,
                onPressed: () => chatController.stopListening(),
              ),
            if (chatController.isListeningDone.value)
              _buildControlButton(
                icon: CupertinoIcons.xmark,
                color: AppColors.errorRed,
                onPressed: () => chatController.stopListening(),
              ),

            // Switch camera
            _buildControlButton(
              icon: CupertinoIcons.switch_camera,
              color: AppColors.moonGray,
              onPressed: _switchFrontBack,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
