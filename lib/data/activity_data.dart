// GENERATED from the web prototype's src/lib/activityData.ts (RAW_QUESTIONS and
// ACTIVITY_INFOS) so the Flutter app uses the identical question bank.
// Sinhala wording should be checked by a Sinhala-speaking teacher before any
// real data collection.
import 'dart:math';
import 'dart:ui' show Color;

import '../models/models.dart';

const Map<ActivityType, ActivityInfo> activityInfos = {
  ActivityType.sinhalaLetters: ActivityInfo(
    type: ActivityType.sinhalaLetters,
    titleSinhala: 'සිංහල අකුරු',
    titleEnglish: 'Sinhala Letters',
    descriptionSinhala: 'අකුර බලලා නිවැරදි අකුර තෝරන්න',
    emoji: '🔤',
    color: Color(0xFFF97316),
  ),
  ActivityType.wordPicture: ActivityInfo(
    type: ActivityType.wordPicture,
    titleSinhala: 'වචන - රූප ගැළපීම',
    titleEnglish: 'Word–Picture Matching',
    descriptionSinhala: 'වචනයට ගැලපෙන රූපය තෝරන්න',
    emoji: '🖼️',
    color: Color(0xFF3B82F6),
  ),
  ActivityType.colorRec: ActivityInfo(
    type: ActivityType.colorRec,
    titleSinhala: 'පාට හඳුනාගැනීම',
    titleEnglish: 'Colour Recognition',
    descriptionSinhala: 'ලබාදී ඇති පාට තෝරන්න',
    emoji: '🎨',
    color: Color(0xFF22C55E),
  ),
  ActivityType.shapeRec: ActivityInfo(
    type: ActivityType.shapeRec,
    titleSinhala: 'හැඩතල හඳුනාගැනීම',
    titleEnglish: 'Shape Recognition',
    descriptionSinhala: 'නිවැරදි හැඩතලය තෝරන්න',
    emoji: '🔺',
    color: Color(0xFF8B5CF6),
  ),
  ActivityType.numberRec: ActivityInfo(
    type: ActivityType.numberRec,
    titleSinhala: 'ඉලක්කම් සහ ගණන් කිරීම',
    titleEnglish: 'Number Recognition',
    descriptionSinhala: 'වස්තු ගණන් කර නිවැරදි ඉලක්කම තෝරන්න',
    emoji: '🔢',
    color: Color(0xFFEC4899),
  ),
};

const List<QuestionItem> rawQuestions = [
  QuestionItem(
    id: 'let_01',
    activityType: ActivityType.sinhalaLetters,
    promptSinhala: 'මෙම අකුර කුමක්ද? \'අ\'',
    promptEnglish: 'Find the letter \'අ\' (A)',
    audioLabelSinhala: 'අකුර අ තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: 'අ', isCorrect: true),
      ChoiceOption(id: 'c2', text: 'ආ', isCorrect: false),
      ChoiceOption(id: 'c3', text: 'ඉ', isCorrect: false),
      ChoiceOption(id: 'c4', text: 'උ', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'let_02',
    activityType: ActivityType.sinhalaLetters,
    promptSinhala: 'මෙම අකුර කුමක්ද? \'ක\'',
    promptEnglish: 'Find the letter \'ක\' (Ka)',
    audioLabelSinhala: 'අකුර ක තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: 'ක', isCorrect: true),
      ChoiceOption(id: 'c2', text: 'ත', isCorrect: false),
      ChoiceOption(id: 'c3', text: 'ම', isCorrect: false),
      ChoiceOption(id: 'c4', text: 'ප', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'let_03',
    activityType: ActivityType.sinhalaLetters,
    promptSinhala: 'මෙම අකුර කුමක්ද? \'ම\'',
    promptEnglish: 'Find the letter \'ම\' (Ma)',
    audioLabelSinhala: 'අකුර ම තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: 'ම', isCorrect: true),
      ChoiceOption(id: 'c2', text: 'ර', isCorrect: false),
      ChoiceOption(id: 'c3', text: 'ග', isCorrect: false),
      ChoiceOption(id: 'c4', text: 'ස', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'let_04',
    activityType: ActivityType.sinhalaLetters,
    promptSinhala: 'මෙම අකුර කුමක්ද? \'ත\'',
    promptEnglish: 'Find the letter \'ත\' (Tha)',
    audioLabelSinhala: 'අකුර ත තෝරන්න',
    ageBands: [AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: 'ත', isCorrect: true),
      ChoiceOption(id: 'c2', text: 'න', isCorrect: false),
      ChoiceOption(id: 'c3', text: 'ද', isCorrect: false),
      ChoiceOption(id: 'c4', text: 'ල', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'let_05',
    activityType: ActivityType.sinhalaLetters,
    promptSinhala: 'මෙම අකුර කුමක්ද? \'ප\'',
    promptEnglish: 'Find the letter \'ප\' (Pa)',
    audioLabelSinhala: 'අකුර ප තෝරන්න',
    ageBands: [AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: 'ප', isCorrect: true),
      ChoiceOption(id: 'c2', text: 'ව', isCorrect: false),
      ChoiceOption(id: 'c3', text: 'ය', isCorrect: false),
      ChoiceOption(id: 'c4', text: 'ච', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'word_01',
    activityType: ActivityType.wordPicture,
    promptSinhala: 'ඇපල් (Apple)',
    promptEnglish: 'Match the word \'ඇපල්\' (Apple)',
    audioLabelSinhala: 'ඇපල් රූපය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', emoji: '🍎', isCorrect: true),
      ChoiceOption(id: 'c2', emoji: '🍌', isCorrect: false),
      ChoiceOption(id: 'c3', emoji: '🐱', isCorrect: false),
      ChoiceOption(id: 'c4', emoji: '🚗', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'word_02',
    activityType: ActivityType.wordPicture,
    promptSinhala: 'අලියා (Elephant)',
    promptEnglish: 'Match the word \'අලියා\' (Elephant)',
    audioLabelSinhala: 'අලියාගේ රූපය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', emoji: '🐘', isCorrect: true),
      ChoiceOption(id: 'c2', emoji: '🐶', isCorrect: false),
      ChoiceOption(id: 'c3', emoji: '🐟', isCorrect: false),
      ChoiceOption(id: 'c4', emoji: '🦆', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'word_03',
    activityType: ActivityType.wordPicture,
    promptSinhala: 'මල (Flower)',
    promptEnglish: 'Match the word \'මල\' (Flower)',
    audioLabelSinhala: 'මලෙහි රූපය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', emoji: '🌸', isCorrect: true),
      ChoiceOption(id: 'c2', emoji: '🌳', isCorrect: false),
      ChoiceOption(id: 'c3', emoji: '⭐', isCorrect: false),
      ChoiceOption(id: 'c4', emoji: '🎈', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'word_04',
    activityType: ActivityType.wordPicture,
    promptSinhala: 'මාළුවා (Fish)',
    promptEnglish: 'Match the word \'මාළුවා\' (Fish)',
    audioLabelSinhala: 'මාළුවාගේ රූපය තෝරන්න',
    ageBands: [AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', emoji: '🐟', isCorrect: true),
      ChoiceOption(id: 'c2', emoji: '🦋', isCorrect: false),
      ChoiceOption(id: 'c3', emoji: '🐸', isCorrect: false),
      ChoiceOption(id: 'c4', emoji: '🐝', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'word_05',
    activityType: ActivityType.wordPicture,
    promptSinhala: 'පොත (Book)',
    promptEnglish: 'Match the word \'පොත\' (Book)',
    audioLabelSinhala: 'පොතෙහි රූපය තෝරන්න',
    ageBands: [AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', emoji: '📚', isCorrect: true),
      ChoiceOption(id: 'c2', emoji: '✏️', isCorrect: false),
      ChoiceOption(id: 'c3', emoji: '🎨', isCorrect: false),
      ChoiceOption(id: 'c4', emoji: '✂️', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'col_01',
    activityType: ActivityType.colorRec,
    promptSinhala: 'රතු පාට (Red)',
    promptEnglish: 'Identify \'රතු\' (Red)',
    audioLabelSinhala: 'රතු පාට තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', colorHex: '#EF4444', isCorrect: true),
      ChoiceOption(id: 'c2', colorHex: '#3B82F6', isCorrect: false),
      ChoiceOption(id: 'c3', colorHex: '#22C55E', isCorrect: false),
      ChoiceOption(id: 'c4', colorHex: '#EAB308', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'col_02',
    activityType: ActivityType.colorRec,
    promptSinhala: 'නිල් පාට (Blue)',
    promptEnglish: 'Identify \'නිල්\' (Blue)',
    audioLabelSinhala: 'නිල් පාට තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', colorHex: '#3B82F6', isCorrect: true),
      ChoiceOption(id: 'c2', colorHex: '#EF4444', isCorrect: false),
      ChoiceOption(id: 'c3', colorHex: '#A855F7', isCorrect: false),
      ChoiceOption(id: 'c4', colorHex: '#F97316', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'col_03',
    activityType: ActivityType.colorRec,
    promptSinhala: 'කොළ පාට (Green)',
    promptEnglish: 'Identify \'කොළ\' (Green)',
    audioLabelSinhala: 'කොළ පාට තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', colorHex: '#22C55E', isCorrect: true),
      ChoiceOption(id: 'c2', colorHex: '#EAB308', isCorrect: false),
      ChoiceOption(id: 'c3', colorHex: '#3B82F6', isCorrect: false),
      ChoiceOption(id: 'c4', colorHex: '#EC4899', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'col_04',
    activityType: ActivityType.colorRec,
    promptSinhala: 'කහ පාට (Yellow)',
    promptEnglish: 'Identify \'කහ\' (Yellow)',
    audioLabelSinhala: 'කහ පාට තෝරන්න',
    ageBands: [AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', colorHex: '#EAB308', isCorrect: true),
      ChoiceOption(id: 'c2', colorHex: '#F97316', isCorrect: false),
      ChoiceOption(id: 'c3', colorHex: '#10B981', isCorrect: false),
      ChoiceOption(id: 'c4', colorHex: '#6366F1', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'col_05',
    activityType: ActivityType.colorRec,
    promptSinhala: 'දම් පාට (Purple)',
    promptEnglish: 'Identify \'දම්\' (Purple)',
    audioLabelSinhala: 'දම් පාට තෝරන්න',
    ageBands: [AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', colorHex: '#A855F7', isCorrect: true),
      ChoiceOption(id: 'c2', colorHex: '#EC4899', isCorrect: false),
      ChoiceOption(id: 'c3', colorHex: '#3B82F6', isCorrect: false),
      ChoiceOption(id: 'c4', colorHex: '#14B8A6', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'shp_01',
    activityType: ActivityType.shapeRec,
    promptSinhala: 'වෘත්තය (Circle)',
    promptEnglish: 'Identify \'වෘත්තය\' (Circle)',
    audioLabelSinhala: 'වෘත්තය හැඩය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', shapeType: ShapeType.circle, isCorrect: true),
      ChoiceOption(id: 'c2', shapeType: ShapeType.square, isCorrect: false),
      ChoiceOption(id: 'c3', shapeType: ShapeType.triangle, isCorrect: false),
      ChoiceOption(id: 'c4', shapeType: ShapeType.star, isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'shp_02',
    activityType: ActivityType.shapeRec,
    promptSinhala: 'සමචතුරස්‍රය (Square)',
    promptEnglish: 'Identify \'සමචතුරස්‍රය\' (Square)',
    audioLabelSinhala: 'සමචතුරස්‍රය හැඩය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', shapeType: ShapeType.square, isCorrect: true),
      ChoiceOption(id: 'c2', shapeType: ShapeType.circle, isCorrect: false),
      ChoiceOption(id: 'c3', shapeType: ShapeType.oval, isCorrect: false),
      ChoiceOption(id: 'c4', shapeType: ShapeType.rectangle, isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'shp_03',
    activityType: ActivityType.shapeRec,
    promptSinhala: 'ත්‍රිකෝණය (Triangle)',
    promptEnglish: 'Identify \'ත්‍රිකෝණය\' (Triangle)',
    audioLabelSinhala: 'ත්‍රිකෝණය හැඩය තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', shapeType: ShapeType.triangle, isCorrect: true),
      ChoiceOption(id: 'c2', shapeType: ShapeType.square, isCorrect: false),
      ChoiceOption(id: 'c3', shapeType: ShapeType.heart, isCorrect: false),
      ChoiceOption(id: 'c4', shapeType: ShapeType.circle, isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'shp_04',
    activityType: ActivityType.shapeRec,
    promptSinhala: 'තරුව (Star)',
    promptEnglish: 'Identify \'තරුව\' (Star)',
    audioLabelSinhala: 'තරුව හැඩය තෝරන්න',
    ageBands: [AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', shapeType: ShapeType.star, isCorrect: true),
      ChoiceOption(id: 'c2', shapeType: ShapeType.heart, isCorrect: false),
      ChoiceOption(id: 'c3', shapeType: ShapeType.rectangle, isCorrect: false),
      ChoiceOption(id: 'c4', shapeType: ShapeType.oval, isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'shp_05',
    activityType: ActivityType.shapeRec,
    promptSinhala: 'හදවත (Heart)',
    promptEnglish: 'Identify \'හදවත\' (Heart)',
    audioLabelSinhala: 'හදවත හැඩය තෝරන්න',
    ageBands: [AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', shapeType: ShapeType.heart, isCorrect: true),
      ChoiceOption(id: 'c2', shapeType: ShapeType.oval, isCorrect: false),
      ChoiceOption(id: 'c3', shapeType: ShapeType.triangle, isCorrect: false),
      ChoiceOption(id: 'c4', shapeType: ShapeType.square, isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'num_01',
    activityType: ActivityType.numberRec,
    promptSinhala: '🍎🍎 (ඇපල් 2ක්)',
    promptEnglish: 'Count objects: 🍎🍎 (How many?)',
    audioLabelSinhala: 'ඇපල් කීයක් තිබේද? ගණන් කර තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: '2 (දෙක)', isCorrect: true),
      ChoiceOption(id: 'c2', text: '1 (එක)', isCorrect: false),
      ChoiceOption(id: 'c3', text: '3 (තුන)', isCorrect: false),
      ChoiceOption(id: 'c4', text: '4 (හතර)', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'num_02',
    activityType: ActivityType.numberRec,
    promptSinhala: '🎈🎈🎈 (බැලූන් 3ක්)',
    promptEnglish: 'Count objects: 🎈🎈🎈 (How many?)',
    audioLabelSinhala: 'බැලූන් කීයක් තිබේද? ගණන් කර තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: '3 (තුන)', isCorrect: true),
      ChoiceOption(id: 'c2', text: '2 (දෙක)', isCorrect: false),
      ChoiceOption(id: 'c3', text: '4 (හතර)', isCorrect: false),
      ChoiceOption(id: 'c4', text: '5 (පහ)', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'num_03',
    activityType: ActivityType.numberRec,
    promptSinhala: '⭐ (තරුව 1යි)',
    promptEnglish: 'Count objects: ⭐ (How many?)',
    audioLabelSinhala: 'තරු කීයක් තිබේද? ගණන් කර තෝරන්න',
    ageBands: [AgeBand.a34, AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: '1 (එක)', isCorrect: true),
      ChoiceOption(id: 'c2', text: '3 (තුන)', isCorrect: false),
      ChoiceOption(id: 'c3', text: '2 (දෙක)', isCorrect: false),
      ChoiceOption(id: 'c4', text: '4 (හතර)', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'num_04',
    activityType: ActivityType.numberRec,
    promptSinhala: '🚗🚗🚗🚗 (කාර් 4ක්)',
    promptEnglish: 'Count objects: 🚗🚗🚗🚗 (How many?)',
    audioLabelSinhala: 'කාර් කීයක් තිබේද? ගණන් කර තෝරන්න',
    ageBands: [AgeBand.a45, AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: '4 (හතර)', isCorrect: true),
      ChoiceOption(id: 'c2', text: '3 (තුන)', isCorrect: false),
      ChoiceOption(id: 'c3', text: '5 (පහ)', isCorrect: false),
      ChoiceOption(id: 'c4', text: '6 (හය)', isCorrect: false),
    ],
  ),
  QuestionItem(
    id: 'num_05',
    activityType: ActivityType.numberRec,
    promptSinhala: '🦆🦆🦆🦆🦆 (තාරාවන් 5ක්)',
    promptEnglish: 'Count objects: 🦆🦆🦆🦆🦆 (How many?)',
    audioLabelSinhala: 'තාරාවන් කීයක් තිබේද? ගණන් කර තෝරන්න',
    ageBands: [AgeBand.a56],
    choices: [
      ChoiceOption(id: 'c1', text: '5 (පහ)', isCorrect: true),
      ChoiceOption(id: 'c2', text: '4 (හතර)', isCorrect: false),
      ChoiceOption(id: 'c3', text: '6 (හය)', isCorrect: false),
      ChoiceOption(id: 'c4', text: '3 (තුන)', isCorrect: false),
    ],
  ),
];

/// Same rule as the web app: 3-4 years = 2 choices, 4-5 = 3, 5-6 = 4.
/// The correct option plus the first (n - 1) distractors are kept, then shuffled.
List<QuestionItem> getQuestionsForActivityAndAge(
  ActivityType type,
  AgeBand band, {
  Random? random,
}) {
  final rnd = random ?? Random();
  final filtered = rawQuestions.where(
    (q) => q.activityType == type && q.ageBands.contains(band),
  );
  return filtered.map((q) {
    final correct = q.choices.firstWhere(
      (c) => c.isCorrect,
      orElse: () => q.choices.first,
    );
    final wrong = q.choices.where((c) => !c.isCorrect).take(band.choices - 1);
    final shuffled = [correct, ...wrong]..shuffle(rnd);
    return QuestionItem(
      id: q.id,
      activityType: q.activityType,
      promptSinhala: q.promptSinhala,
      promptEnglish: q.promptEnglish,
      audioLabelSinhala: q.audioLabelSinhala,
      ageBands: q.ageBands,
      choices: shuffled,
    );
  }).toList();
}
