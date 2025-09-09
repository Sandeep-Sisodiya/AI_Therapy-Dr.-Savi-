import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, dynamic> summaryData;

  const SummaryScreen({Key? key, required this.summaryData}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final box = GetStorage();
  List<bool> dayDoneStatus = [];
  bool isAlreadySaved = false;

  @override
  void initState() {
    super.initState();
    final daywise = List<String>.from(widget.summaryData['daywise'] ?? []);
    dayDoneStatus = List.generate(daywise.length, (_) => false);

    // Check if summary already saved
    List stored = box.read('savedSummaries') ?? [];
    final existingIndex = stored.indexWhere((s) =>
    s['summary'] == widget.summaryData['summary'] &&
        s['daywise'].toString() == widget.summaryData['daywise'].toString());

    if (existingIndex != -1) {
      isAlreadySaved = true;
      final savedSummary = stored[existingIndex];
      // Load previously marked done days if any
      if (savedSummary['dayDoneStatus'] != null) {
        dayDoneStatus =
        List<bool>.from(savedSummary['dayDoneStatus']);
      }
    }
  }

  void saveSummary() {
    List stored = box.read('savedSummaries') ?? [];
    widget.summaryData['dayDoneStatus'] = dayDoneStatus;

    if (isAlreadySaved) {
      // Update existing summary
      final existingIndex = stored.indexWhere((s) =>
      s['summary'] == widget.summaryData['summary'] &&
          s['daywise'].toString() == widget.summaryData['daywise'].toString());
      if (existingIndex != -1) {
        stored[existingIndex] = widget.summaryData;
      }
    } else {
      // Save as new
      stored.add(widget.summaryData);
      isAlreadySaved = true;
    }

    box.write('savedSummaries', stored);
    Get.snackbar("Saved", "Summary saved successfully!");
  }

  void markDayDone(int index) {
    setState(() {
      dayDoneStatus[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summaryData['summary'] ?? "";
    final daywise = List<String>.from(widget.summaryData['daywise'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversation Summary & Targets",
          style: GoogleFonts.chewy(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8D2914),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: saveSummary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Card(
                elevation: 4,
                shadowColor: Colors.teal.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Summary",
                        style: GoogleFonts.kaushanScript(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8D2914),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        summary,
                        style: GoogleFonts.patuaOne(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Day-wise Plan",
                style: GoogleFonts.kaushanScript(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D2914),
                ),
              ),
              const SizedBox(height: 8),
              // 7-Day Cards
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: daywise.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: dayDoneStatus[index] ? 0.6 : 1.0,
                    child: Card(
                      color: dayDoneStatus[index]
                          ? Colors.green.shade100
                          : Color(0xFFEFEDED),
                      elevation: 3,
                      shadowColor: Color(0xFFA9670F),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                daywise[index],
                                style: GoogleFonts.patuaOne(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: dayDoneStatus[index]
                                  ? null
                                  : () => markDayDone(index),
                              icon: const Icon(Icons.check, color: Color(0xFF8D2914)),
                              label: Text(
                                "Done",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF8D2914),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
