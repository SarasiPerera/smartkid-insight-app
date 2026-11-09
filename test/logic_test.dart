import 'package:flutter_test/flutter_test.dart';
import 'package:smartkid_insight/data/activity_data.dart';
import 'package:smartkid_insight/models/models.dart';
import 'package:smartkid_insight/services/scoring.dart';

void main() {
  test(
    'question bank: 25 questions, 5 per activity, one correct choice each',
    () {
      expect(rawQuestions.length, 25);
      for (final t in ActivityType.values) {
        expect(rawQuestions.where((q) => q.activityType == t).length, 5);
      }
      for (final q in rawQuestions) {
        expect(q.choices.where((c) => c.isCorrect).length, 1, reason: q.id);
      }
    },
  );

  test(
    'choice count follows age band (2/3/4) and the correct answer is kept',
    () {
      for (final t in ActivityType.values) {
        for (final b in AgeBand.values) {
          for (final q in getQuestionsForActivityAndAge(t, b)) {
            expect(q.choices.length, b.choices, reason: '${q.id} ${b.key}');
            expect(q.choices.where((c) => c.isCorrect).length, 1, reason: q.id);
          }
        }
      }
    },
  );

  test('performance bands: >=80 strong, 50-79 developing, <50 weak', () {
    expect(performanceLevel(80), PerformanceLevel.strong);
    expect(performanceLevel(79), PerformanceLevel.developing);
    expect(performanceLevel(50), PerformanceLevel.developing);
    expect(performanceLevel(49), PerformanceLevel.weak);
  });

  test('Firestore record keeps the shared camelCase schema', () {
    final m = AssessmentResponse(
      sessionId: 's',
      childId: 'KID-1',
      ownerId: 'u',
      activityType: ActivityType.sinhalaLetters,
      itemId: 'let_01',
      selectedAnswer: 'c1',
      correct: true,
      responseTimeMs: 1200,
      attemptNumber: 1,
      timestamp: DateTime.utc(2026, 1, 1),
    ).toFirestore();
    expect(m['activityType'], 'sinhala_letters');
    expect(m.containsKey('childId'), true);
    expect(m.containsKey('responseTimeMs'), true);
  });
}
