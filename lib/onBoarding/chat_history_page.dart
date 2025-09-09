import 'package:ai_therapy/onBoarding/saved_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/chat_controller.dart';
import '../Services/api_service.dart';
import '../custom_background.dart';
import '../constants.dart';
import 'summary_screen.dart';

class ChatHistoryPage extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();
  final ScrollController _scrollController = ScrollController();

  ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Column(
            children: [
              // Custom Styled AppBar
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🍉 Chat History",
                      style: GoogleFonts.chewy(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        _iconButton(Icons.delete, "Clear Chat", () {
                          chatController.clearConversation();
                        }),
                        const SizedBox(width: 12),
                        _iconButton(Icons.summarize, "Generate Summary",
                                () async {
                              if (chatController.conversation.length <= 1) {
                                Get.snackbar(
                                    "Error", "No conversation to summarize.");
                                return;
                              }

                              final userPrompt = """
Generate a very concise summary of the conversation.
Create a day-wise target plan for the next 7 days.
Do not ask any questions or request clarifications.
Only output summary and weekly plan in a structured, readable format.
""";

                              final fullPrompt = chatController.conversation
                                  .skip(1) // ignore system prompt
                                  .map((m) =>
                              "${m['role'] == 'user' ? 'User' : 'Assistant'}: ${m['content']}")
                                  .join("\n") +
                                  "\n$userPrompt";

                              // Show loading
                              Get.dialog(
                                const Center(child: CircularProgressIndicator()),
                                barrierDismissible: false,
                              );

                              final response = await Get.find<ApiService>()
                                  .getChatCompletion(
                                  userPrompt: fullPrompt, speak: false);

                              Get.back(); // close loading

                              if (response != null) {
                                final summaryMap = {
                                  'summary': response,
                                  'daywise': [
                                    "Day 1: ...",
                                    "Day 2: ...",
                                    "Day 3: ...",
                                    "Day 4: ...",
                                    "Day 5: ...",
                                    "Day 6: ...",
                                    "Day 7: ..."
                                  ]
                                };

                                Get.to(
                                        () => SummaryScreen(summaryData: summaryMap));
                              }
                            }),
                        const SizedBox(width: 12),
                        _iconButton(Icons.bookmark, "Saved Summaries", () {
                          Get.to(() => SavedSummariesScreen());
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 2.2),

              // Chat History List
              Expanded(
                child: Obx(() {
                  final messages = chatController.conversation
                      .where((m) => m['role'] != 'system')
                      .toList();

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "No chat history yet",
                        style: GoogleFonts.patuaOne(
                          color: Colors.black45,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFFB67928)
                                : Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color:
                              isUser ? const Color(0xFF523003) : Colors.black12,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: GoogleFonts.patuaOne(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom icon button for AppBar actions
  Widget _iconButton(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFA9670F),
          border: Border.all(color: Colors.black87, width: 2),
          boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 3)],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
