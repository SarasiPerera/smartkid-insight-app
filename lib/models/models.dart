import 'dart:ui' show Color;

/// Ported from the web prototype's src/types.ts.

enum UserRole { parent, teacher, researcher }

UserRole userRoleFromString(String? s) => UserRole.values.firstWhere(
  (r) => r.name == s,
  orElse: () => UserRole.parent,
);

class UserProfile {
  final String id;
  final String email;
  final UserRole role;
  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
  });
}

/// Age bands drive the number of answer choices (FR1.2).
enum AgeBand {
  a34('3-4', 2, '3–4 years'),
  a45('4-5', 3, '4–5 years'),
  a56('5-6', 4, '5–6 years');

  final String key;
  final int choices;
  final String label;
  const AgeBand(this.key, this.choices, this.label);

  static AgeBand fromKey(String k) =>
      AgeBand.values.firstWhere((b) => b.key == k, orElse: () => AgeBand.a34);
}

/// [key] is the exact string already stored in Firestore by the web prototype.
enum ActivityType {
  sinhalaLetters('sinhala_letters'),
  wordPicture('word_picture'),
  colorRec('color_rec'),
  shapeRec('shape_rec'),
  numberRec('number_rec');

  final String key;
  const ActivityType(this.key);

  static ActivityType fromKey(String k) => ActivityType.values.firstWhere(
    (a) => a.key == k,
    orElse: () => ActivityType.sinhalaLetters,
  );
}

class ActivityInfo {
  final ActivityType type;
  final String titleSinhala;
  final String titleEnglish;
  final String descriptionSinhala;
  final String emoji;
  final Color color;
  const ActivityInfo({
    required this.type,
    required this.titleSinhala,
    required this.titleEnglish,
    required this.descriptionSinhala,
    required this.emoji,
    required this.color,
  });
}

enum ShapeType { circle, square, triangle, rectangle, star, oval, heart }

class ChoiceOption {
  final String id;
  final String? text;
  final String? emoji;
  final String? colorHex;
  final ShapeType? shapeType;
  final bool isCorrect;
  const ChoiceOption({
    required this.id,
    this.text,
    this.emoji,
    this.colorHex,
    this.shapeType,
    required this.isCorrect,
  });
}

class QuestionItem {
  final String id;
  final ActivityType activityType;
  final String promptSinhala;
  final String promptEnglish;
  final String audioLabelSinhala;
  final List<AgeBand> ageBands;
  final List<ChoiceOption> choices;
  const QuestionItem({
    required this.id,
    required this.activityType,
    required this.promptSinhala,
    required this.promptEnglish,
    required this.audioLabelSinhala,
    required this.ageBands,
    required this.choices,
  });
}

/// The nickname lives ONLY on the device (SharedPreferences). It is never
/// written to Firestore (approved proposal, Section 4.2).
class ChildProfile {
  final String childId; // anonymised, e.g. KID-7A9B3E2F
  final String nickname;
  final AgeBand ageBand;
  final int avatarIndex;
  final String ownerId;
  final String createdAt;
  const ChildProfile({
    required this.childId,
    required this.nickname,
    required this.ageBand,
    required this.avatarIndex,
    required this.ownerId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'nickname': nickname,
    'ageBand': ageBand.key,
    'avatarIndex': avatarIndex,
    'ownerId': ownerId,
    'createdAt': createdAt,
  };

  factory ChildProfile.fromJson(Map<String, dynamic> j) => ChildProfile(
    childId: j['childId'] as String,
    nickname: (j['nickname'] ?? '') as String,
    ageBand: AgeBand.fromKey(j['ageBand'] as String),
    avatarIndex: (j['avatarIndex'] ?? 0) as int,
    ownerId: (j['ownerId'] ?? '') as String,
    createdAt: (j['createdAt'] ?? '') as String,
  );
}

class AssessmentSession {
  final String sessionId;
  final String childId;
  final String ownerId;
  final AgeBand ageBand;
  final List<ActivityType> completedActivities;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isComplete;

  const AssessmentSession({
    required this.sessionId,
    required this.childId,
    required this.ownerId,
    required this.ageBand,
    required this.completedActivities,
    required this.startTime,
    this.endTime,
    this.isComplete = false,
  });

  AssessmentSession copyWith({
    List<ActivityType>? completedActivities,
    DateTime? endTime,
    bool? isComplete,
  }) => AssessmentSession(
    sessionId: sessionId,
    childId: childId,
    ownerId: ownerId,
    ageBand: ageBand,
    completedActivities: completedActivities ?? this.completedActivities,
    startTime: startTime,
    endTime: endTime ?? this.endTime,
    isComplete: isComplete ?? this.isComplete,
  );
}

class AssessmentResponse {
  final String sessionId;
  final String childId;
  final String ownerId;
  final ActivityType activityType;
  final String itemId;
  final String selectedAnswer;
  final bool correct;
  final int responseTimeMs;
  final int attemptNumber;
  final DateTime timestamp;

  const AssessmentResponse({
    required this.sessionId,
    required this.childId,
    required this.ownerId,
    required this.activityType,
    required this.itemId,
    required this.selectedAnswer,
    required this.correct,
    required this.responseTimeMs,
    required this.attemptNumber,
    required this.timestamp,
  });

  /// FR1.3 fields, same camelCase schema the web prototype already writes.
  Map<String, dynamic> toFirestore() => {
    'childId': childId,
    'activityType': activityType.key,
    'itemId': itemId,
    'selectedAnswer': selectedAnswer,
    'correct': correct,
    'responseTimeMs': responseTimeMs,
    'attemptNumber': attemptNumber,
    'sessionId': sessionId,
    'timestamp': timestamp.toIso8601String(),
    'ownerId': ownerId,
  };

  factory AssessmentResponse.fromFirestore(Map<String, dynamic> d) =>
      AssessmentResponse(
        sessionId: (d['sessionId'] ?? '') as String,
        childId: (d['childId'] ?? '') as String,
        ownerId: (d['ownerId'] ?? '') as String,
        activityType: ActivityType.fromKey((d['activityType'] ?? '') as String),
        itemId: (d['itemId'] ?? '') as String,
        selectedAnswer: (d['selectedAnswer'] ?? '') as String,
        correct: (d['correct'] ?? false) as bool,
        responseTimeMs: ((d['responseTimeMs'] ?? 0) as num).toInt(),
        attemptNumber: ((d['attemptNumber'] ?? 1) as num).toInt(),
        timestamp:
            DateTime.tryParse((d['timestamp'] ?? '') as String) ??
            DateTime.now(),
      );
}

/// Strong >= 80, Developing 50-79, Weak < 50 (Bloom 1968; ASQ-3).
enum PerformanceLevel {
  strong('Strong', 'ශක්තිමත්'),
  developing('Developing', 'දියුණු වෙමින්'),
  weak('Weak', 'සහාය අවශ්‍යයි');

  final String label;
  final String labelSinhala;
  const PerformanceLevel(this.label, this.labelSinhala);
}

class DomainScore {
  final ActivityType activityType;
  final int totalQuestions;
  final int correctCount;
  final int accuracyPercent;
  final PerformanceLevel level;
  final int avgTimeMs;
  const DomainScore({
    required this.activityType,
    required this.totalQuestions,
    required this.correctCount,
    required this.accuracyPercent,
    required this.level,
    required this.avgTimeMs,
  });
}
