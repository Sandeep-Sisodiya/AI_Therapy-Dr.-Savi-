import 'package:ai_therapy/onBoarding/audio_conversation_mode_screen.dart';
import 'package:ai_therapy/onBoarding/login_page.dart';
import 'package:ai_therapy/onBoarding/on_boarding.dart';
import 'package:ai_therapy/onBoarding/therapist_home_page.dart';
import 'package:ai_therapy/onBoarding/user_therapist_choice_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Models/therapist_model.dart';
import 'firebase_options.dart';
import 'app_theme.dart';

// ✅ Import your screens
import 'package:ai_therapy/onBoarding/audio_conversation_page.dart';
import 'package:ai_therapy/onBoarding/mode_selection_screen.dart';

// ✅ Import your controllers
import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/Controllers/chat_controller.dart';

// ✅ Import your services
import 'Services/api_service.dart';
import 'constants.dart';
import 'onBoarding/therapist_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Immersive dark status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.deepNavy,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TherapistModelAdapter());
  await Hive.openBox<TherapistModel>('therapists');

  // Controllers
  Get.put(UserController());
  Get.put(ChatController());
  Get.put(ApiService());

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

    // ✅ Read firstTime value safely
    final storedValue = box.read("firstTime");
    if (storedValue != null && storedValue is bool) {
      firstTime = storedValue;
    } else {
      box.write("firstTime", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Therapy',
      debugShowCheckedModeBanner: false,
      theme: celestialTheme(),
      home: UserTherapistChoicePage(),
    );
  }
}
