import 'package:flutter/material.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../services/scoring.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

class ResultsScreen extends StatelessWidget {
  final ChildProfile child;
  final List<AssessmentResponse> responses;
  final VoidCallback onHome;
  final VoidCallback onDashboard;

  const ResultsScreen({
    super.key,
    required this.child,
    required this.responses,
    required this.onHome,
    required this.onDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final scores = computeDomainScores(responses).where((s) => s.totalQuestions > 0).toList();
    final correct = responses.where((r) => r.correct).length;
    final accuracy = responses.isEmpty ? 0 : (correct * 100 / responses.length).round();
    final avgMs = responses.isEmpty
        ? 0
        : (responses.fold<int>(0, (sum, r) => sum + r.responseTimeMs) / responses.length).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _summaryBanner(accuracy, correct, avgMs),
              const SizedBox(height: 18),
              Row(children: [const Icon(Icons.bar_chart_rounded, color: AppColors.primary), const SizedBox(width: 7), Text('Domain Performance Breakdown', style: sinhalaText(16, weight: FontWeight.w900))]),
              const SizedBox(height: 10),
              if (scores.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
                  child: Text('No activities were completed in this session.', style: sinhalaText(12, color: AppColors.inkSoft), textAlign: TextAlign.center),
                ),
              ...scores.map(_domainCard),
              _scoringGuide(),
              const SizedBox(height: 17),
              FilledButton.icon(onPressed: onHome, icon: const Icon(Icons.home_outlined), label: const Text('Return to Home'), style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14))),
              const SizedBox(height: 9),
              OutlinedButton.icon(onPressed: onDashboard, icon: const Icon(Icons.bar_chart), label: const Text('View Researcher Dashboard'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryBanner(int accuracy, int correct, int avgMs) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFF59E0B)]), borderRadius: BorderRadius.circular(26)),
        child: Column(
          children: [
            const MascotOwl(emotion: OwlEmotion.bounce, size: 116, speech: 'සුබ පැතුම්! නියමයි! 🎉'),
            const SizedBox(height: 8),
            Text('Screening Summary for ${child.nickname}', textAlign: TextAlign.center, style: sinhalaText(20, color: Colors.white, weight: FontWeight.w900)),
            Text('Child ID: ${child.childId}  •  Age Band: ${child.ageBand.key} years', style: sinhalaText(10.5, color: const Color(0xFFFFF7ED))),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(color: Colors.white.withOpacity(.18), border: Border.all(color: Colors.white30), borderRadius: BorderRadius.circular(18)),
              child: Row(children: [
                _metric('$accuracy%', 'Overall Accuracy'),
                _metric('$correct / ${responses.length}', 'Items Correct'),
                _metric(formatSeconds(avgMs), 'Avg Response Time'),
              ]),
            ),
          ],
        ),
      );

  Widget _metric(String value, String label) => Expanded(
        child: Column(
          children: [
            Text(value, style: sinhalaText(21, color: Colors.white, weight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label, textAlign: TextAlign.center, style: sinhalaText(9, color: const Color(0xFFFFF7ED), weight: FontWeight.w800)),
          ],
        ),
      );

  Widget _domainCard(DomainScore s) {
    final info = activityInfos[s.activityType]!;
    final color = levelColor(s.accuracyPercent);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: AppColors.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(info.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 9),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${info.titleSinhala} (${info.titleEnglish})', style: sinhalaText(12.5, weight: FontWeight.w900)),
                  Text('Correct: ${s.correctCount} / ${s.totalQuestions}  •  Avg Time: ${formatSeconds(s.avgTimeMs)}', style: sinhalaText(10.5, color: AppColors.inkSoft)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(30), border: Border.all(color: color.withOpacity(.3))),
                child: Text('${s.level.label} (${s.accuracyPercent}%)', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: s.accuracyPercent / 100, minHeight: 10, backgroundColor: AppColors.line, valueColor: AlwaysStoppedAnimation(color))),
        ],
      ),
    );
  }

  Widget _scoringGuide() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.line)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scoring Guidelines', style: sinhalaText(12, weight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Wrap(spacing: 12, runSpacing: 8, children: [
              _Legend(color: AppColors.strong, text: 'Strong (≥ 80%)'),
              _Legend(color: AppColors.developing, text: 'Developing (50–79%)'),
              _Legend(color: AppColors.weak, text: 'Weak (< 50%)'),
            ]),
            const SizedBox(height: 9),
            Text('This is an early screening and progress-tracking tool, not a clinical diagnosis. Results should be interpreted by a responsible adult or qualified professional.', style: sinhalaText(10.5, color: AppColors.inkSoft)),
          ],
        ),
      );
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 5), Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10))],
      );
}
