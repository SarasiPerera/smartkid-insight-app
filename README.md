# SmartKid Insight – Flutter Application

Flutter implementation of the **AI-Assisted Early Literacy and Cognitive Skill Assessment System for Sinhala-Speaking Preschool Children in Sri Lanka**.

## Current architecture

- **Mobile/web UI:** Flutter and Dart
- **Authentication:** Firebase Authentication
- **Operational data:** Cloud Firestore
- **Child nicknames:** local device storage only (`shared_preferences`)
- **Sinhala prompts:** on-device text-to-speech (`flutter_tts`)
- **Planned AI service:** Python + Flask
- **Planned recommendation model:** ANN with six inputs and three output classes, trained using knowledge distillation from the approved Evidence Matrix

The Python/Flask service and ANN are separate planned implementation stages; they are not represented as completed in this UI project.

## Screens included

1. Welcome and research ethics / audio check
2. Firebase sign-in and parent sign-up
3. Home dashboard with child profiles and shortcuts
4. Child profile creation with age band and avatar selection
5. Five-activity assessment menu and session progress
6. Activity play screen with Sinhala TTS, age-based answer choices and feedback
7. 30-second guided breathing break
8. Results summary with overall accuracy and domain-level scoring
9. Research dashboard with overview, progress, response and session views, filters, and JSON export (browser download on Web; clipboard fallback on native platforms)

## Assessment rules

- Five activities: Sinhala letters, word-picture matching, colour recognition, shape recognition, and number recognition.
- Age bands: 3–4, 4–5, and 5–6 years.
- Answer choice counts: 2, 3, and 4 respectively.
- Performance bands: Strong (80% or above), Developing (50–79%), and Weak (below 50%).
- Results are for screening and progress monitoring, not clinical diagnosis.

## Firebase data and privacy

The Flutter application keeps the existing Firebase architecture and Firestore field names. Child nicknames remain in local device storage. Firestore assessment records use anonymised child IDs and owner IDs. Parent dashboard queries are scoped to the signed-in owner; teacher/researcher access is controlled by Firestore security rules and provisioned user roles.

Do not replace the Firebase services with the React prototype's local/demo authentication or in-memory Express API. Do not change the approved Firestore schema without checking the project requirements and security rules first.

## Run locally

From the folder containing `pubspec.yaml`:

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

For Android, install Android Studio and the Android SDK, then configure the SDK and accept Android licences:

```powershell
flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"
flutter doctor --android-licenses
flutter doctor
flutter run
```

If Firebase platform configuration needs to be regenerated for a new Firebase project, run `flutterfire configure` and review the generated `lib/firebase_options.dart` before committing.

## Validation note

This project archive was assembled from the supplied Flutter project and the screen updates. The current execution environment did not have the Flutter SDK available, so a final `flutter analyze` and device build could not be run here. Run the commands above on your Windows development machine and resolve any analyzer/build messages before merging or collecting research data. Sinhala question wording and all assessment content should also be reviewed by a Sinhala-speaking educator before real-world use.


## UI styling update (13 November 2026)

The Flutter screens use the supplied SmartKid Insight reference designs: warm cream backgrounds, white rounded panels, orange/yellow gradients, navy typography, coloured status accents, owl branding, and a purple researcher dashboard accent. The authentication screen retains Firebase authentication; role shortcuts provide access guidance and do not create mock/demo sessions.

The app must be tested locally with `flutter pub get`, `flutter analyze`, and `flutter run -d chrome` (or an Android device after configuring the Android SDK). The Flask/ANN recommendation backend remains a separate planned integration stage.

## UI and audio parity update

- Ollie is rendered as an animated Flutter vector mascot. The React reference uses an animated SVG component (`OllieOwl.tsx`), not a GIF asset; the Flutter mascot reproduces its orange body, yellow belly, blue glasses, eyes, wings, and floating/bouncing motion.
- The Welcome sound test now reports the result of an actual Sinhala speech attempt instead of treating a locale capability check alone as definitive. Sinhala speech still depends on a Sinhala voice being installed/enabled by the operating system or browser.
- Firebase configuration and Firestore rules are preserved. No Firebase project, users, collections, or cloud records are deleted or recreated by these source changes.
