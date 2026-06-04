import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../app_theme.dart';
import '../Controllers/chat_controller.dart';
import '../Services/api_service.dart';

class ChatModeScreen extends StatefulWidget {
  const ChatModeScreen({Key? key}) : super(key: key);

  @override
  State<ChatModeScreen> createState() => _ChatModeScreenState();
}

class _ChatModeScreenState extends State<ChatModeScreen> {
  late final ChatController chatController;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();

    // Disable auto-speak in chat
    await chatController.sendUserMessage(text, speak: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.starWhite, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.auroraTeal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_rounded,
                  color: AppColors.auroraTeal, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              "Dr. Savi",
              style: AppTypography.headlineLarge,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Subtle divider
          Container(
            height: 0.5,
            color: AppColors.glassBorder,
          ),

          // Messages
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
                          color: AppColors.moonGray.withOpacity(0.3), size: 56),
                      const SizedBox(height: 16),
                      Text(
                        "Start the conversation",
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.moonGray.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
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
                              bottomLeft: Radius.circular(isUser ? 18 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 18),
                            ),
                            border: isUser
                                ? null
                                : Border.all(
                                    color: AppColors.glassBorder, width: 0.5),
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: AppTypography.bodyLarge.copyWith(
                              color: isUser
                                  ? Colors.white
                                  : AppColors.starWhite,
                              height: 1.4,
                            ),
                          ),
                        ),

                        // Listen button for AI messages
                        if (!isUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 4),
                            child: GestureDetector(
                              onTap: () async {
                                if (msg['content'] != null) {
                                  await ApiService.flutterTts
                                      .speak(msg['content']!);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.auroraTeal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: AppColors.auroraTeal,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.midnightBlue,
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppColors.glassBorder, width: 0.5),
                      ),
                      child: TextField(
                        controller: _inputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.moonGray.withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryButtonGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.auroraLavender.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
