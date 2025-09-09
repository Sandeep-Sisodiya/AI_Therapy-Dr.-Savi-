import 'package:ai_therapy/onBoarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ✅ Import your screens
import 'package:ai_therapy/View/home_view.dart';
import 'package:ai_therapy/onBoarding/mode_selection_screen.dart';

// ✅ Import your controllers
import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/Controllers/chat_controller.dart';

// ✅ Import your services
import 'Services/api_service.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize GetStorage
  await GetStorage.init();

  // ✅ Load .env file
  await dotenv.load(fileName: ".env");

  // ✅ Register controllers first (order matters!)
  Get.put(UserController());      // Required by ChatController.basePrompt
  Get.put(ChatController());      // Required by ApiService

  // ✅ Register services after controllers
  Get.put(ApiService());          // ApiService uses ChatController.basePrompt

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  var firstTime = true;

  @override
  void initState() {
    super.initState();

    if (box.read("firstTime") != null) {
      firstTime = box.read("firstTime");
    } else {
      box.write("firstTime", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Therapy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nexa",
        canvasColor: Colors.transparent,
        sliderTheme: const SliderThemeData(
          trackHeight: 15,
          thumbShape: _RectSliderThumbShape(width: 8),
        ),
        chipTheme: ChipThemeData(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          disabledColor: Colors.grey,
          selectedColor: buttonColor,
          secondarySelectedColor: buttonColor,
          padding: const EdgeInsets.all(10),
          side: const BorderSide(
            color: textColor,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          labelStyle: const TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          secondaryLabelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          displayMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        useMaterial3: true,
      ),
      // ✅ Set initial screen here
      // home: const ModeSelectionScreen(),
      home: OnBoarding(),
      // home : firstTime ? const ModeSelectionScreen() : const HomeView(),
      // home: ChatModeScreen(),
      // home: ModeSelectionScreen(),
    );
  }
}

// ✅ Custom Slider Thumb Shape
class _RectSliderThumbShape extends SliderComponentShape {
  final double width;
  const _RectSliderThumbShape({required this.width});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, 0);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    assert(sliderTheme.thumbColor != null);

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: 45,
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(width / 2)),
      Paint()..color = sliderTheme.thumbColor!,
    );
  }
}
