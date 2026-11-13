
import 'dart:async';

import 'package:flutter/material.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../services/tts_service.dart';
import '../services/sound_effect_service.dart';
import '../theme.dart';
import '../widgets/choice_tile.dart';
import '../widgets/mascot_owl.dart';

/// One question per screen (single-action-per-screen principle).
class ActivityPlayScreen extends StatefulWidget {
  final ActivityType activityType;
  final ChildProfile child;
  final AssessmentSession session;
  final TtsService tts;
  final SoundEffectService sounds;
  final ValueChanged<AssessmentResponse> onResponse;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const ActivityPlayScreen({
    super.key,
    required this.activityType,
    required this.child,
    required this.session,
    required this.tts,
    required this.sounds,
    required this.onResponse,
    required this.onComplete,
    required this.onBack,
  });

  @override
  State<ActivityPlayScreen> createState() => _ActivityPlayScreenState();
}

class _ActivityPlayScreenState extends State<ActivityPlayScreen> {
  late final List<QuestionItem> _questions;

  int _index = 0;
  String? _selectedId;

  TileFeedback _feedback = TileFeedback.none;
  OwlEmotion _mascot = OwlEmotion.cheerful;

  late DateTime _shownAt;

  QuestionItem get _q => _questions[_index];

  @override
  void initState() {
    super.initState();

    _questions = getQuestionsForActivityAndAge(
      widget.activityType,
      widget.child.ageBand,
    );

    _shownAt = DateTime.now();

    if (_questions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _speakPrompt();
      });
    }
  }

  @override
  void dispose() {
    widget.tts.stop();
    super.dispose();
  }

  void _speakPrompt() {
    if (!mounted || _questions.isEmpty) return;

    setState(() {
      _mascot = OwlEmotion.speaking;
    });

    widget.tts.speak(_q.audioLabelSinhala);
  }

  /// Number questions embed the answer in words.
  /// Show only the objects to count so the prompt does not give the answer away.
  String _promptDisplay(QuestionItem q) {
    if (q.activityType == ActivityType.numberRec) {
      final cut = q.promptSinhala.indexOf(' (');

      if (cut > 0) {
        return q.promptSinhala.substring(0, cut);
      }
    }

    return q.promptSinhala;
  }

  void _tap(ChoiceOption choice) {
    if (_feedback != TileFeedback.none) return;

    final rt = DateTime.now().difference(_shownAt).inMilliseconds;

    widget.onResponse(
      AssessmentResponse(
        sessionId: widget.session.sessionId,
        childId: widget.child.childId,
        ownerId: widget.session.ownerId,
        activityType: widget.activityType,
        itemId: _q.id,
        selectedAnswer: choice.id,
        correct: choice.isCorrect,
        responseTimeMs: rt,
        attemptNumber: 1,
        timestamp: DateTime.now(),
      ),
    );

    setState(() {
      _selectedId = choice.id;

      _feedback = choice.isCorrect
          ? TileFeedback.correct
          : TileFeedback.incorrect;

      _mascot = choice.isCorrect
          ? OwlEmotion.bounce
          : OwlEmotion.encouraging;
    });

    // Play the matching sound without delaying answer feedback.
    if (choice.isCorrect) {
      unawaited(widget.sounds.playCorrect());
    } else {
      unawaited(widget.sounds.playIncorrect());
    }

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      if (_index + 1 < _questions.length) {
        setState(() {
          _index += 1;
          _selectedId = null;
          _feedback = TileFeedback.none;
          _mascot = OwlEmotion.cheerful;
          _shownAt = DateTime.now();
        });

        _speakPrompt();
      } else {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(
        child: Text('No questions available for this age group.'),
      );
    }

    final info = activityInfos[widget.activityType]!;
    final n = _q.choices.length;
    final cols = n == 3 ? 3 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Responsive header: prevents horizontal overflow on mobile.
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;

              final exitButton = TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Exit'),
              );

              final title = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    info.titleSinhala,
                    textAlign: TextAlign.center,
                    style: sinhalaText(
                      15,
                      weight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Question ${_index + 1} of ${_questions.length}',
                    style: sinhalaText(
                      11.5,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              );

              final speakerButton =
                  ValueListenableBuilder<bool>(
                valueListenable: widget.tts.speaking,
                builder: (context, speaking, _) {
                  return IconButton.filled(
                    onPressed: _speakPrompt,
                    tooltip: 'Read aloud',
                    style: IconButton.styleFrom(
                      backgroundColor: speaking
                          ? AppColors.primary
                          : AppColors.primarySoft,
                      foregroundColor: speaking
                          ? Colors.white
                          : AppColors.primary,
                      minimumSize: const Size(48, 48),
                    ),
                    icon: const Icon(
                      Icons.volume_up,
                      size: 26,
                    ),
                  );
                },
              );

              if (isCompact) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        exitButton,
                        speakerButton,
                      ],
                    ),
                    const SizedBox(height: 6),
                    title,
                  ],
                );
              }

              return Row(
                children: [
                  exitButton,
                  Expanded(
                    child: Center(
                      child: title,
                    ),
                  ),
                  speakerButton,
                ],
              );
            },
          ),

          const SizedBox(height: 4),

          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (_index + 1) / _questions.length,
              minHeight: 10,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: AppColors.primarySoft,
                width: 3,
              ),
            ),
            child: Column(
              children: [
                MascotOwl(
                  emotion: _mascot,
                  size: 72,
                ),

                const SizedBox(height: 6),

                Text(
                  _q.promptEnglish,
                  textAlign: TextAlign.center,
                  style: sinhalaText(
                    12,
                    color: AppColors.inkSoft,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _promptDisplay(_q),
                  textAlign: TextAlign.center,
                  style: sinhalaText(
                    30,
                    weight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, box) {
              const gap = 14.0;

              final side = (
                (box.maxWidth - gap * (cols - 1)) / cols
              ).clamp(kMinTap, 170.0).toDouble();

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                alignment: WrapAlignment.center,
                children: _q.choices.map((c) {
                  var f = TileFeedback.none;

                  if (_feedback != TileFeedback.none) {
                    if (c.id == _selectedId) {
                      f = _feedback;
                    } else if (c.isCorrect &&
                        _feedback == TileFeedback.incorrect) {
                      f = TileFeedback.correct;
                    }
                  }

                  return ChoiceTile(
                    option: c,
                    size: side,
                    feedback: f,
                    onTap: () => _tap(c),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 34,
            child: Text(
              _feedback == TileFeedback.correct
                  ? 'නියමයි! හරි! 🎉'
                  : _feedback == TileFeedback.incorrect
                      ? 'කමක් නෑ! නැවත උත්සාහ කරමු! 💛'
                      : 'අහන්න, උත්තරය තෝරන්න 🦉',
              style: sinhalaText(
                17,
                weight: FontWeight.w900,
                color: _feedback == TileFeedback.correct
                    ? AppColors.strong
                    : _feedback == TileFeedback.incorrect
                        ? AppColors.developing
                        : AppColors.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
