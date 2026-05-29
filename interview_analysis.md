# AI Therapy Project: Senior Technical Interview & System Design Analysis

This document provides a comprehensive technical analysis of the **AI Therapy** codebase. It contains project-specific interview questions, expected answers based on your actual implementation, potential cross-examination follow-ups, system design extensions, and tricky interview scenarios.

---

## Part 1: Top 20 Most Important Project-Based Questions

### 1. Hybrid Storage Strategy (Firebase vs. Hive)
* **Question:** In your therapist registration module, I noticed that authentication and basic details (name, email) are stored in Firebase Auth & Cloud Firestore ([signup_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/signup_page.dart#L203-L209)), while detailed profile information and document paths are stored in a local Hive box ([therapist_home_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/therapist_home_page.dart#L321-L322)). What is the architectural rationale behind this split?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - Firebase handles secure cloud-based authentication and basic credentials globally.
  - Hive is used for low-latency local storage on the therapist's device, bypassing network overhead.
  - *Critique:* This split has a severe drawback—if a therapist logs in on a new device, their profile details and documents (which are stored locally in Hive) will not sync. The patient list ([therapist_list_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/therapist_list_page.dart#L15)) also reads from Hive, meaning patients can only see therapists registered on their *own* device. In a production app, all profile details and file uploads must be pushed to Cloud Firestore and Firebase Storage.
* **Follow-up Questions:**
  - "If a patient downloads the app, how will they view the profiles of registered therapists if they are only stored in the local Hive box of the therapist's device?"
  - "How would you migrate the current local Hive structure to a synchronized cloud database?"
* **Related Module:** Therapist Onboarding / Database

### 2. Manual Conversation String Concatenation vs. Native Multi-Turn APIs
* **Question:** In `ApiService.getChatCompletion` ([api_service.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Services/api_service.dart#L88-L91)), you construct the API payload by flattening the entire message history into a single string (`fullPrompt` joined by newlines with `User:` and `Assistant:` prefixes). Why did you choose this over Gemini's native structured multi-turn chat format?
* **Difficulty:** Medium-Advanced
* **Expected Answer Points:**
  - Manual joining allows custom formatting and makes it easy to append system instructions directly before sending.
  - *Critique:* Formatting multi-turn history as a single string treats the entire conversation as a single "user prompt" turn. This increases token overhead, prevents Gemini from utilizing its native multi-turn optimization, and might cause the model to output formatting tokens like `Assistant:` in its response instead of acting naturally.
* **Follow-up Questions:**
  - "How would you rewrite this payload structure to use the native `contents` array structure of the Gemini API (specifying `role: 'user'` and `role: 'model'`)?"
  - "Does flattening the prompt affect context window limits differently compared to native multi-turn payloads?"
* **Related Module:** Gemini API Integration (`api_service.dart`)

### 3. Hardcoded Targets in Weekly Planner
* **Question:** In `ChatHistoryPage` ([chat_history_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/chat_history_page.dart#L82-L90)), when generating a therapist summary, the `daywise` target list is hardcoded with placeholder values (`"Day 1: ..."` to `"Day 7: ..."`). Why is this hardcoded, and how would you implement a dynamic parser to extract actual AI-generated goals?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - It was likely set up as a UI placeholder during initial implementation.
  - To make it dynamic, we would instruct Gemini to return a structured JSON response (e.g., using Gemini's structured output mode with a JSON schema) containing the summary and a 7-day list, then parse it using Dart's `jsonDecode`.
* **Follow-up Questions:**
  - "How would you configure the Gemini API call to guarantee that it returns a valid JSON matching your schema instead of raw conversational text?"
  - "What error-handling strategy would you use if the LLM output is malformed or missing some days?"
* **Related Module:** Chat History / Summary Screen

### 4. Model Object Definition vs. Manual JSON Parsing Disconnect
* **Question:** You defined a robust `GeminiChatResponse` model mapping class in [chat_completion_model.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Models/chat_completion_model.dart), yet in `ApiService` ([api_service.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Services/api_service.dart#L104-L109)), you parse the raw HTTP response map manually using dictionary lookups (`candidates[0]["content"]["parts"][0]["text"]`). Why did you choose manual parsing over using your typed model, and what are the trade-offs?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - Manual parsing is faster to implement and avoids boilerplate when only a single field (the reply text) is needed.
  - *Trade-off:* Typed models provide compile-time safety and prevent runtime `NullPointer` exceptions (like if `candidates` is empty or structured differently). Using manual maps makes the app highly vulnerable to crash if Google modifies the API response structure.
* **Follow-up Questions:**
  - "If the API returns a safety filter block instead of text, how does your manual parsing handle it compared to a model-based parser?"
  - "Rewrite the manual parsing lines using your defined model class."
* **Related Module:** API Service / Data Models

### 5. Local State Management Architecture (GetX)
* **Question:** Why did you choose GetX for state management in this project over other solutions like Bloc, Riverpod, or Provider?
* **Difficulty:** Beginner-Medium
* **Expected Answer Points:**
  - GetX combines state management (reactive variables using `.obs` and `Obx`), dependency injection (`Get.put`/`Get.find`), and route management (`Get.to`/`Get.off`) in a single package.
  - It reduces boilerplate code (no need for `StatefulWidget` states or `BuildContext` for routing).
* **Follow-up Questions:**
  - "What are the drawbacks of using GetX in terms of testing and global context-free state lifecycle?"
  - "How do you ensure that `UserController` values are preserved when navigating between user and therapist choices?"
* **Related Module:** State Management Architecture

### 6. Visual Mode Implementation and Limitations
* **Question:** In `VideoConversationPage` ([video_conversation_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/video_conversation_page.dart)), the app opens a camera preview overlay. How does the visual model affect the conversation compared to `AudioConversationPage`? Does the API process the video frames?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - In the current implementation, Visual Mode is functionally identical to Audio Mode (STT/TTS chat loop via `ChatController`). The camera feed is purely a local mirror preview.
  - The API does not receive or process the video frames.
* **Follow-up Questions:**
  - "How would you extend this to send live video frames to Gemini 2.5 Flash's multimodal input for real-time facial expression analysis?"
  - "What performance bottlenecks (bandwidth, processing power) would you face if you sent images to the model every 2 seconds?"
* **Related Module:** Video Conversation Mode

### 7. Session Resiliency & Cache Store (GetStorage vs. Hive)
* **Question:** The app uses both `GetStorage` ([main.dart:L36](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/main.dart#L36)) and `Hive` ([main.dart:L40](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/main.dart#L40)). Why use two different local storage libraries, and what are the specific use cases for each in your app?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - `GetStorage` is a simple key-value store suitable for minor variables like onboarding flags (`firstTime`) and serializable lists (`savedSummaries`).
  - `Hive` is a fast NoSQL database suitable for storing structured type-adapted objects (like `TherapistModel` containing lists of document paths).
* **Follow-up Questions:**
  - "What makes Hive faster than SQLite or SharedPreferences in Flutter?"
  - "How do you generate and register Hive adapters, and why are they necessary?"
* **Related Module:** Storage Services

### 8. Speech-to-Text Conversation Flow (The 3-Second Timeout)
* **Question:** In `ChatController.startNoSpeechTimer` ([chat_controller.dart:L63-L70](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Controllers/chat_controller.dart#L63-L70)), you implement a 3-second timer. What problem does this solve, and how does it integrate with the speech recognition listener callback `onSpeechResult`?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - The timer stops listening if the user remains silent for 3 seconds, preventing the mic from staying active indefinitely.
  - Every time `onSpeechResult` is triggered by a recognized word, the timer is reset, ensuring the timer only fires after the user *stops* speaking.
* **Follow-up Questions:**
  - "What happens if a user pauses for 3.5 seconds to gather their thoughts? How would you handle pauses without prematurely cutting off the speech session?"
  - "How do you handle background noise triggers in speech-to-text libraries?"
* **Related Module:** Voice / Speech Service

### 9. Haptic Feedback and Accessibility Design
* **Question:** You have integrated haptic feedback in multiple user actions (e.g., clicking chips and starting audio session) using the `vibration` package ([select_user_issues.dart:L123](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/select_user_issues.dart#L123)). Why is haptic feedback important in a therapy application, and how does it affect battery or OS constraints?
* **Difficulty:** Beginner
* **Expected Answer Points:**
  - Haptic vibrations provide sensory validation and grounding, which can help calm users dealing with anxiety.
  - The implementation checks if the device has a vibrator (`Vibration.hasVibrator()`) to avoid throwing exceptions on devices without vibration motors (like tablets or emulators).
* **Follow-up Questions:**
  - "Why is it important to wrap native device calls in checks like `hasVibrator()` or platform checks?"
  - "How does haptic feedback impact the user experience for visually impaired individuals?"
* **Related Module:** UI / Accessibility

### 10. Local Image File Paths in Local Database
* **Question:** When a therapist uploads document proofs or their Doctor ID, you save the local file path string (e.g., `doctorIdFile.path`) into Hive ([therapist_home_page.dart:L318](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/therapist_home_page.dart#L318)). Why is storing absolute file system paths locally risky in mobile apps, and what is the correct approach?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - Absolute file paths can change when the app gets updated, or when the OS modifies directory UUIDs (especially on iOS). Storing absolute paths will lead to broken links and blank images.
  - The correct approach is to save the files to the app's document directory (using `path_provider`) and store only the *relative* filename in the database, reconstructing the full path dynamically at runtime.
* **Follow-up Questions:**
  - "How does directory sandboxing on iOS restrict access to absolute file paths stored in database keys?"
  - "How would you handle uploading these files to Firebase Storage instead of keeping them on the local device?"
* **Related Module:** Therapist Profile / File Storage

### 11. Security of API Keys in Environment Variables
* **Question:** You load the Gemini API Key using `flutter_dotenv` from a `.env` file ([api_service.dart:L85](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Services/api_service.dart#L85)). How secure is this approach when publishing the app to the Google Play Store or Apple App Store?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - *Critique:* It is not secure at all. The `.env` file gets packaged into the app assets as plain text. Decompiling the APK or IPA file will instantly reveal the Gemini API key, allowing attackers to steal it.
  - The correct approach is to run API calls through a secure backend proxy server that holds the API key, or use a tool like Firebase Vertex AI which handles key security on the server side.
* **Follow-up Questions:**
  - "If someone steals your API key, what are the potential financial and security consequences?"
  - "Explain how a backend proxy pattern would work to keep the API key safe."
* **Related Module:** Security / API Configurations

### 12. Dynamic System Prompts based on User Parameters
* **Question:** In `ChatController`, your `basePrompt` adapts depending on user controller values like `lisSol` (listening/solutioning) and `hoTa` (holistic/targeted) ([chat_controller.dart:L107-L125](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Controllers/chat_controller.dart#L107-L125)). How does this dynamic customization affect the model's behavior, and how did you structure the instructions to ensure Gemini follows them?
* **Difficulty:** Medium-Advanced
* **Expected Answer Points:**
  - You inject the runtime controller values directly into the system prompt string.
  - The prompt contains detailed rules instructions mapping numerical values to specific CBT/DBT tones.
* **Follow-up Questions:**
  - "If the sliders change *during* an active chat session, how is the prompt updated? Does the ongoing history get regenerated?"
  - "How do you test that Gemini actually switches between CBT and DBT mode based on these values?"
* **Related Module:** State Integration / System Prompts

### 13. Double Controller Initialization Bug
* **Question:** In `CustomizeAttributesScreen` ([customize_attributes_screen.dart:L18-L19](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/customize_attributes_screen.dart#L18-L19)), you use `Get.find<UserController>() ?? Get.put(UserController())`. In Dart, if `Get.find` throws an exception because the controller isn't registered, the `??` operator won't catch it since `Get.find` throws an error rather than returning null. How does GetX handle missing dependency searches, and how should this be written safely?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - `Get.find()` throws a runtime exception if the dependency is missing; it does not return `null`. Therefore, the `??` fallback is dead code.
  - To prevent crashes, the controller should either be initialized globally using a Binding or checked safely using `Get.isRegistered<UserController>()`.
* **Follow-up Questions:**
  - "What is the difference between `Get.put()`, `Get.lazyPut()`, and `Get.singleton()`?"
  - "How does GetX handle memory management when views using controllers are popped from the stack?"
* **Related Module:** GetX Dependency Injection

### 14. Error Handling and Internet Disconnections during API Calls
* **Question:** In `ApiService.getChatCompletion` ([api_service.dart:L93](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Services/api_service.dart#L93)), you make an HTTP POST request. If the user loses internet connection, what happens to the app? How can this be handled gracefully?
* **Difficulty:** Beginner-Medium
* **Expected Answer Points:**
  - The request will throw a `SocketException` or a timeout error, which is currently unhandled and will cause the app to throw an unhandled exception or freeze.
  - The call should be wrapped in a `try-catch` block, catching network exceptions, and displaying a message to the user while stopping the loading indicator.
* **Follow-up Questions:**
  - "How can you implement a retry mechanism for failed API requests?"
  - "How would you use a connectivity listener package to block user inputs when the device goes offline?"
* **Related Module:** API Integration / Error Handling

### 15. The "firstTime" Flag Storage Lifecycle
* **Question:** In `_MyAppState.initState` ([main.dart:L67-L74](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/main.dart#L67-L74)), you check the `firstTime` flag in `GetStorage` to show onboarding. If a user logs out and logs in with a different account on the same device, does this flag reset? What is the impact?
* **Difficulty:** Beginner
* **Expected Answer Points:**
  - The flag is stored locally on the device and does not depend on the authenticated user.
  - A new user logging in on the same device will bypass the onboarding flow. If the goal is a personalized user experience, this state should be linked to the user's Firestore document.
* **Follow-up Questions:**
  - "How would you clear this flag during logout to force a fresh experience?"
  - "What is the differences between device-level flags and user-profile flags?"
* **Related Module:** Onboarding Flow / App Configuration

### 16. Firebase Firestore Structure for Users vs. Therapists
* **Question:** In your signup pages ([signup_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/signup_page.dart) and [therapist_signup_page.dart](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/therapist_signup_page.dart)), you create Firestore documents in two collections: `users` and `therapists`. Why did you separate them into different collections rather than using a single `users` collection with a `role` field?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - Separating them makes collection rules easier to enforce (e.g., only therapists need verification documents).
  - *Alternative:* Using a single `users` collection with a `role` attribute simplifies authentication queries and makes it easier to manage globally.
* **Follow-up Questions:**
  - "How would your Firestore security rules look to prevent a normal user from accessing the therapist collection?"
  - "What is the advantage of using subcollections over separate collections in this context?"
* **Related Module:** Firebase DB Design

### 17. Speech-to-Text Initialization Timing
* **Question:** In `ChatController.onInit` ([chat_controller.dart:L29-L34](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/Controllers/chat_controller.dart#L29-L34)), you call `_initSpeech()` which initializes the hardware microphone. What are the performance and permission implications of initializing device recording services immediately on app startup?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - Initializing hardware immediately can cause startup lag if the device resources are constrained.
  - If permissions are not yet granted, initializing immediately might trigger a native permission popup right at startup, which is bad UX. It is better to initialize speech services only when the user transitions to voice mode.
* **Follow-up Questions:**
  - "How would you lazy-load the speech service only when voice mode is opened?"
  - "How do you handle the scenario where a user denies mic permission but tries to enter Voice Mode?"
* **Related Module:** Controller Initialization / Permissions

### 18. Custom Slider Thumb Layout Constraints
* **Question:** You implemented a custom rectangular slider thumb shape `_RectSliderThumbShape` in [main.dart:L159-L195](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/main.dart#L159-L195). Why was a custom slider shape needed, and how did you override the default drawing canvas in Flutter?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - Default sliders use circular thumbs. A custom design is used to achieve the desired modern aesthetic.
  - By subclassing `SliderComponentShape` and overriding the `paint` method, you get access to the canvas and can draw a custom rectangle using `context.canvas.drawRRect`.
* **Follow-up Questions:**
  - "How does the `paint` method calculate the slider thumb position relative to the user's touch offset?"
  - "How does the custom thumb handle disabled states?"
* **Related Module:** UI Components / Custom Painters

### 19. TTS Stop and Release Controls
* **Question:** When leaving `AudioConversationPage` or `VideoConversationPage`, if the AI is actively speaking, does the TTS stop? What lifecycle methods in Flutter did you use to release the speaker hardware?
* **Difficulty:** Medium
* **Expected Answer Points:**
  - *Critique:* Currently, there is no explicit `flutterTts.stop()` called inside the page's `dispose()` methods. The audio might continue playing in the background even after navigating back to the mode screen.
  - To fix this, you should override `dispose` in the views (or close hooks in GetX) and call `flutterTts.stop()`.
* **Follow-up Questions:**
  - "How does an active audio session running after page disposal affect battery consumption and app ratings?"
  - "How would you handle audio interruptions (e.g., receiving a phone call while using the app)?"
* **Related Module:** View Lifecycles / TTS Hardware

### 20. State Serialization for Chat History Summaries
* **Question:** In `ChatHistoryPage` ([chat_history_page.dart:L60-L65](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/chat_history_page.dart#L60-L65)), when generating a summary, you serialize the conversation history. What happens if a user session contains 100+ messages? How does this affect API limits and request pricing?
* **Difficulty:** Advanced
* **Expected Answer Points:**
  - String concatenation grows linearly. A very long conversation history will eventually exceed the API input token limit.
  - It also increases latency and billing costs.
  - *Solution:* Implement a sliding window history, summarize previous context periodically, or send only the last N messages to the API.
* **Follow-up Questions:**
  - "What is the token limit of the `gemini-2.5-flash-lite` model?"
  - "How would you implement an automated rolling summarization system?"
* **Related Module:** Memory Management / Scalability

---

## Part 2: Tricky Interviewer Questions (Edge Cases & Corner Situations)

These questions test your ability to spot vulnerabilities, handle unusual states, and critique your own code.

### 1. The "State Sync & Duplicate Keys" Bug in Saved Summaries
* **Interviewer Prompt:** "Look at `SummaryScreen.saveSummary` ([summary_screen.dart:L74-L93](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/summary_screen.dart#L74-L93)). To check if a summary is already saved, you convert the target list to a string: `s['daywise'].toString() == widget.summaryData['daywise'].toString()`. Why stringify the list, and what happens if two summaries have the same contents but their keys are ordered differently?
* **Analysis:** Comparing stringified representations of lists/maps is highly fragile. In Dart, if two lists have the same items but differ in metadata or order, their string representations will mismatch. Furthermore, if you edit a target day to 'Done', the string changes, and `saveSummary` will treat it as a *new* summary rather than updating the old one!
* **Expected Fix/Discussion:** Use unique UUIDs for each session summary. Compare IDs instead of stringifying data objects.

### 2. Audio Latency and STT/TTS Clash
* **Interviewer Prompt:** "If a user is speaking in Voice Mode, and the AI response starts playing via Text-to-Speech, what prevents the microphone from hearing the AI speaker, translating it as user input, and creating a feedback loop?"
* **Analysis:** Mobile apps must handle audio ducking and echo cancellation. In Flutter, `speech_to_text` and `flutter_tts` can clash. If TTS is active, STT should be paused programmatically, or hardware-based echo cancellation should be configured.
* **Expected Fix/Discussion:** In `ChatController`, implement an audio lock state: while assistant TTS is playing, disable STT input.

### 3. API Key Exposure Mitigation
* **Interviewer Prompt:** "I notice your `.env` contains a raw API Key. If I run `strings` command on your compiled Android APK, I can see the key. How will you prevent this without setting up a backend server?"
* **Analysis:** If no server is allowed, we can use obfuscation or specialized SDKs.
* **Expected Fix/Discussion:** Use Dart environment declarations (`--dart-define`) to compile keys as encrypted binaries, or configure native Android Proguard obfuscation rules to mask asset strings.

### 4. Firestore Security Rules Bypass
* **Interviewer Prompt:** "In your `signup_page.dart` ([signup_page.dart:L203](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/signup_page.dart#L203)), you perform signup on the client side and then insert user details into the Firestore collection using the user's UID. What security issues can arise here?"
* **Analysis:** If the client is compromised, anyone can write to any path in the database unless database security rules are configured.
* **Expected Fix/Discussion:** Configure Firestore security rules to match client UIDs: `allow write: if request.auth.uid == userId`.

---

## Part 3: Company / Placement-Style Questions

### Category 1: Flutter Framework & UI Performance
* **Company Profile:** Core Flutter Engineer (e.g., ByteDance, Uber)
* **Question:** How does `ValueListenableBuilder` inside `TherapistListPage` ([therapist_list_page.dart:L23](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/therapist_list_page.dart#L23)) optimize rendering compared to rebuilding the entire widget tree using `setState`?
* **Answer Points:**
  - `ValueListenableBuilder` rebuilds *only* the subtree inside its builder method when the Hive box updates, rather than rebuilding the parent scaffold.
  - It prevents unnecessary repaint loops of the gradient background and other static layout assets.

### Category 2: Backend & Security Integration
* **Company Profile:** Full-Stack Security Engineer (e.g., Stripe, Okta)
* **Question:** If a therapist uploads doctor identity credentials to get verified, how would you design a secure document upload pipeline that complies with HIPAA regulations?
* **Answer Points:**
  - Encrypt files during transit using TLS, and at rest using AES-256 in a private cloud storage bucket.
  - Do not keep local document references in Hive on the device.
  - Limit access to the verification documents to authorized admin roles using Firebase Security Rules.

### Category 3: Mobile Hardware Interfaces
* **Company Profile:** Android/iOS Developer (e.g., Spotify, Airbnb)
* **Question:** In `VideoConversationPage`, you check permissions using the `permission_handler` package. What is the difference between *denied*, *permanently denied*, and *restricted* permission states on iOS vs. Android? How does your code handle a "permanently denied" camera permission?
* **Answer Points:**
  - If permanently denied, subsequent request calls won't show a prompt; they will instantly return denied.
  - The app must detect this state and direct the user to open their system settings manually using `openAppSettings()`.

---

## Part 4: System Design & Production Scalability Extensions

### 1. Scaling LLM Conversations to Millions of Concurrent Users
* **Design Goal:** Scale the AI therapist conversation API beyond standard rate limits.
* **Architecture Design:**
  - Use an API Gateway with rate limiting.
  - Route messages to a message queue (e.g., Kafka) and process prompts with background worker instances.
  - Cache common grounding replies in Redis.
  - Deliver responses back using WebSockets or Server-Sent Events (SSE).

### 2. Synchronization Database Architecture
* **Design Goal:** Solve the Hive database sync disconnect across multiple devices.
* **Proposed Architecture:**
  - Use a cloud database (like Firestore or MongoDB Atlas) as the source of truth.
  - Implement a sync manager using Hive as an offline-first cache database.
  - Use a sync protocol (e.g., custom timestamp vector sync) to resolve conflicts when updating therapist details offline.

---

## Part 5: Mock Viva & Project Discussion Simulator

Use this section to practice explaining your project in front of an examiner.

### Interviewer Persona: The "Pragmatic CTO"
* *"So, you built an AI Therapy app. It looks cool, but why is there a settings gear icon inside the voice screen ([audio_conversation_page.dart:L70](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/audio_conversation_page.dart#L70)) that lets the patient change the AI's empathy and listening levels? In a real clinical therapy setting, does the patient get to tweak their doctor's personality on a slider?"*
* **How to answer:** 
  > "While changing a therapist's personality on the fly is not possible in real-life clinical therapy, this design decision is meant to empower the user. AI therapy serves as a self-help tool rather than a replacement for clinical therapy. By providing these sliders, the user can adjust the session to match their current emotional state: they can set it to high-listening/reassuring mode when they just want to vent, or action-oriented mode when they are looking for practical CBT strategies to solve a problem. It makes the model's behavioral settings visible and controllable."

### Interviewer Persona: The "Performance Inspector"
* *"Your app runs Lottie animations continuously in `HomeView` ([audio_conversation_page.dart:L85](file:///c:/Users/sande/AndroidStudioProjects/ai_therapy/lib/onBoarding/audio_conversation_page.dart#L85)). How do you ensure these vector-heavy animations don't drain the device battery or drop frames on older mobile phones?"*
* **How to answer:** 
  > "Lottie animations are vector-based and run on the native canvas layer, which is more efficient than playing raw GIFs or video loops. However, they can still consume CPU cycles. To optimize performance, we configure the `AnimationController` to loop the animations only during active states (e.g. speaking/listening) and stop/dispose the controller when the user leaves the screen. Additionally, we use `Animate` fadeIn tags to prevent layout shifts when the animations load."
