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

  // Only 3-4 feel-good movies/shows (Bollywood + Hollywood)
  final List<Map<String, String>> movieSuggestions = [
    {
      "title": "Zindagi Na Milegi Dobara",
      "year": "2011",
      "genre": "Bollywood, Drama, Adventure",
      "description":
      "A soulful journey of three friends discovering life, love, and themselves while traveling across Spain. Packed with humor, emotions, and breathtaking visuals, it's a modern Bollywood classic about friendship and living in the moment."
    },
    {
      "title": "The Pursuit of Happyness",
      "year": "2006",
      "genre": "Drama, Biography",
      "description":
      "A deeply moving film starring Will Smith about a struggling salesman who never gives up on his dreams. A powerful reminder of hope, resilience, and the importance of family."
    },
    {
      "title": "Yeh Jawaani Hai Deewani",
      "year": "2013",
      "genre": "Bollywood, Romance, Drama",
      "description":
      "A vibrant Bollywood film exploring friendship, love, and chasing dreams. With foot-tapping music, heartwarming moments, and relatable characters, it leaves you with a smile and a sense of nostalgia."
    },
    {
      "title": "The Intern",
      "year": "2015",
      "genre": "Comedy, Drama",
      "description":
      "A delightful movie about a 70-year-old widower who becomes an intern at a fashion startup. Heartwarming, funny, and inspiring — it shows that life has no age limits for new beginnings."
    },
  ];


  @override
  void initState() {
    super.initState();
    final daywise = List<String>.from(widget.summaryData['daywise'] ?? []);
    dayDoneStatus = List.generate(daywise.length, (_) => false);

    List stored = box.read('savedSummaries') ?? [];
    final existingIndex = stored.indexWhere((s) =>
    s['summary'] == widget.summaryData['summary'] &&
        s['daywise'].toString() ==
            widget.summaryData['daywise'].toString());

    if (existingIndex != -1) {
      isAlreadySaved = true;
      final savedSummary = stored[existingIndex];
      if (savedSummary['dayDoneStatus'] != null) {
        dayDoneStatus = List<bool>.from(savedSummary['dayDoneStatus']);
      }
    }
  }

  void saveSummary() {
    List stored = box.read('savedSummaries') ?? [];
    widget.summaryData['dayDoneStatus'] = dayDoneStatus;

    if (isAlreadySaved) {
      final existingIndex = stored.indexWhere((s) =>
      s['summary'] == widget.summaryData['summary'] &&
          s['daywise'].toString() ==
              widget.summaryData['daywise'].toString());
      if (existingIndex != -1) {
        stored[existingIndex] = widget.summaryData;
      }
    } else {
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
              /// Summary Card
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

              /// Day Cards
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
                              icon: const Icon(Icons.check,
                                  color: Color(0xFF8D2914)),
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

              const SizedBox(height: 20),
              Text(
                "Movie & Show Suggestions",
                style: GoogleFonts.kaushanScript(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D2914),
                ),
              ),
              const SizedBox(height: 10),

              /// Movie Suggestion Slider (only 3 cards)
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: movieSuggestions.length,
                  itemBuilder: (context, index) {
                    final movie = movieSuggestions[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Color(0xFFEFEDED),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${movie['title']} (${movie['year']})",
                              style: GoogleFonts.patuaOne(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8D2914),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              movie['genre'] ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                movie['description'] ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
