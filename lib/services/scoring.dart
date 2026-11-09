import '../models/models.dart';

/// Ported from the web prototype's src/lib/scoring.ts.
PerformanceLevel performanceLevel(int accuracyPercent) {
  if (accuracyPercent >= 80) return PerformanceLevel.strong;
  if (accuracyPercent >= 50) return PerformanceLevel.developing;
  return PerformanceLevel.weak;
}

List<DomainScore> computeDomainScores(List<AssessmentResponse> responses) {
  return ActivityType.values.map((type) {
    final rows = responses.where((r) => r.activityType == type).toList();
    final total = rows.length;
    final correct = rows.where((r) => r.correct).length;
    final accuracy = total > 0 ? ((correct / total) * 100).round() : 0;
    final totalTime = rows.fold<int>(0, (sum, r) => sum + r.responseTimeMs);
    final avg = total > 0 ? (totalTime / total).round() : 0;
    return DomainScore(
      activityType: type,
      totalQuestions: total,
      correctCount: correct,
      accuracyPercent: accuracy,
      level: performanceLevel(accuracy),
      avgTimeMs: avg,
    );
  }).toList();
}

String formatSeconds(int ms) =>
    ms <= 0 ? '0s' : '${(ms / 1000).toStringAsFixed(1)}s';
