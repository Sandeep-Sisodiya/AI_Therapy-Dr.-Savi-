import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_background.dart';
import 'summary_screen.dart';

class SavedSummariesScreen extends StatefulWidget {
  const SavedSummariesScreen({Key? key}) : super(key: key);

  @override
  State<SavedSummariesScreen> createState() => _SavedSummariesScreenState();
}

class _SavedSummariesScreenState extends State<SavedSummariesScreen> {
  final box = GetStorage();
  List<Map<String, dynamic>> savedSummaries = [];

  @override
  void initState() {
    super.initState();
    loadSummaries();
  }

  void loadSummaries() {
    List stored = box.read('savedSummaries') ?? [];
    savedSummaries = stored
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    setState(() {});
  }

  void markTargetAchieved(int index) {
    setState(() {
      savedSummaries[index]['achieved'] = true;
      box.write('savedSummaries', savedSummaries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        otherWidget: SafeArea(
          child: Column(
            children: [
              // Custom styled AppBar Row
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🍎 Saved Summaries",
                      style: GoogleFonts.chewy(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.black87),
                      tooltip: "Reload",
                      onPressed: loadSummaries,
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 2.2),

              // Saved Summaries List
              Expanded(
                child: savedSummaries.isEmpty
                    ? Center(
                  child: Text(
                    "No saved summaries yet",
                    style: GoogleFonts.patuaOne(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: savedSummaries.length,
                  itemBuilder: (context, index) {
                    final summary = savedSummaries[index];
                    final achieved = summary['achieved'] ?? false;

                    return GestureDetector(
                      onLongPress: () {
                        Get.defaultDialog(
                          title: "Options",
                          titleStyle: GoogleFonts.patuaOne(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          middleText: "Choose an action",
                          middleTextStyle: GoogleFonts.patuaOne(
                            fontSize: 16,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  savedSummaries.removeAt(index);
                                  box.write('savedSummaries', savedSummaries);
                                });
                                Get.back();
                              },
                              child: Text(
                                "Delete",
                                style: GoogleFonts.patuaOne(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.patuaOne(
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.white,
                          radius: 12,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: achieved
                              ? Colors.green.shade300.withOpacity(0.2)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: achieved
                                ? const Color(0xFFA9670F)
                                : Colors.black26,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            summary['summary'] ?? '',
                            style: GoogleFonts.patuaOne(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              (summary['daywise'] as List<dynamic>?)?.join(", ") ?? '',
                              style: GoogleFonts.patuaOne(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              achieved ? Colors.grey : const Color(0xFFA9670F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              achieved ? "Achieved" : "Mark Achieved",
                              style: GoogleFonts.patuaOne(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: achieved
                                ? null
                                : () => markTargetAchieved(index),
                          ),
                          onTap: () {
                            Get.to(() => SummaryScreen(summaryData: summary));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
