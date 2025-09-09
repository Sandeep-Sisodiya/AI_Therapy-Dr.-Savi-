class GeminiChatResponse {
  final List<Candidate> candidates;

  GeminiChatResponse({required this.candidates});

  factory GeminiChatResponse.fromJson(Map<String, dynamic> json) {
    return GeminiChatResponse(
      candidates: (json['candidates'] as List)
          .map((x) => Candidate.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidates': candidates.map((x) => x.toJson()).toList(),
    };
  }
}

class Candidate {
  final Content content;
  final String? finishReason;

  Candidate({
    required this.content,
    this.finishReason,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json['content']),
      finishReason: json['finishReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.toJson(),
      'finishReason': finishReason,
    };
  }
}

class Content {
  final List<Part> parts;
  final String? role;

  Content({
    required this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts: (json['parts'] as List).map((x) => Part.fromJson(x)).toList(),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parts': parts.map((x) => x.toJson()).toList(),
      'role': role,
    };
  }
}

class Part {
  final String text;

  Part({required this.text});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
