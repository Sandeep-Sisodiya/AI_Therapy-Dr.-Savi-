import 'package:ai_therapy/onBoarding/saved_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import '../Controllers/chat_controller.dart';
import '../Services/api_service.dart';
import '../custom_background.dart';
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
              // Custom AppBar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chat History",
                      style: AppTypography.displaySmall,
                    ),
                    Row(
                      children: [
                        _iconButton(Icons.delete_outline_rounded,
                            "Clear Chat", () {
                          chatController.clearConversation();
                        }),
                        const SizedBox(width: 10),
                        _iconButton(
                            Icons.summarize_rounded, "Generate Summary",
                            () async {
                          if (chatController.conversation.length <= 1) {
                            Get.snackbar(
                                "Error", "No conversation to summarize.",
                                backgroundColor:
                                    AppColors.errorRed.withOpacity(0.2),
                                colorText: AppColors.starWhite);
                            return;
                          }

                          final userPrompt = """
Generate a very concise summary of the conversation.
Create a day-wise target plan for the next 7 days.
Do not ask any questions or request clarifications.
Only output summary and weekly plan in a structured, readable format.
""";

                          final fullPrompt = chatController.conversation
                                  .skip(1)
                                  .map((m) =>
                                      "${m['role'] == 'user' ? 'User' : 'Assistant'}: ${m['content']}")
                                  .join("\n") +
                              "\n$userPrompt";

                          Get.dialog(
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.auroraLavender,
                              ),
                            ),
                            barrierDismissible: false,
                            barrierColor: Colors.black54,
                          );

                          final response = await Get.find<ApiService>()
                              .getChatCompletion(
                                  userPrompt: fullPrompt, speak: false);

                          Get.back();

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
                            Get.to(() =>
                                SummaryScreen(summaryData: summaryMap));
                          }
                        }),
                        const SizedBox(width: 10),
                        _iconButton(Icons.bookmark_rounded, "Saved Summaries",
                            () {
                          Get.to(() => SavedSummariesScreen());
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              Container(height: 0.5, color: AppColors.glassBorder),

              // Chat History List
              Expanded(
                child: Obx(() {
                  final messages = chatController.conversation
                      .where((m) => m['role'] != 'system')
                      .toList();

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded,
                              color: AppColors.moonGray.withOpacity(0.3),
                              size: 48),
                          const SizedBox(height: 12),
                          Text(
                            "No chat history yet",
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.moonGray.withOpacity(0.5),
                            ),
                          ),
                        ],
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
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.78,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isUser
                                ? AppGradients.primaryButtonGradient
                                : null,
                            color: isUser ? null : AppColors.glassWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft:
                                  Radius.circular(isUser ? 18 : 4),
                              bottomRight:
                                  Radius.circular(isUser ? 4 : 18),
                            ),
                            border: isUser
                                ? null
                                : Border.all(
                                    color: AppColors.glassBorder,
                                    width: 0.5),
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.starWhite,
                              height: 1.4,
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

  Widget _iconButton(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.auroraLavender.withOpacity(0.15),
          border:
              Border.all(color: AppColors.auroraLavender.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: AppColors.auroraLavender, size: 20),
      ),
    );
  }
}
