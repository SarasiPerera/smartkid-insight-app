import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../services/firestore_service.dart';
import '../services/json_export.dart';
import '../services/scoring.dart';
import '../theme.dart';

/// Firebase-backed researcher/teacher dashboard. Parent queries remain scoped
/// to the signed-in owner by FirestoreService and firestore.rules.
class DashboardScreen extends StatefulWidget {
  final UserProfile user;
  final FirestoreService firestore;
  const DashboardScreen({super.key, required this.user, required this.firestore});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<_DashData> _future;
  String _tab = 'Overview';
  String _childFilter = 'all';
  String _activityFilter = 'all';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashData> _load() async {
    final sessions = await widget.firestore.fetchSessions(widget.user);
    final responses = <AssessmentResponse>[];
    for (final session in sessions) {
      final id = session['sessionId'] as String?;
      if (id != null) responses.addAll(await widget.firestore.fetchResponses(id));
    }
    sessions.sort((a, b) => _dateOf(b).compareTo(_dateOf(a)));
    responses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return _DashData(sessions, responses);
  }

  DateTime _dateOf(Map<String, dynamic> s) =>
      DateTime.tryParse('${s['endTime'] ?? s['startTime'] ?? ''}') ?? DateTime(2000);

  List<AssessmentResponse> _filter(_DashData data) => data.responses.where((r) {
    final childOk = _childFilter == 'all' || r.childId == _childFilter;
    final activityOk = _activityFilter == 'all' || r.activityType.key == _activityFilter;
    return childOk && activityOk;
  }).toList();

  Object? _jsonSafe(Object? value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), _jsonSafe(v)));
    if (value is Iterable) return value.map(_jsonSafe).toList();
    return value;
  }

  Future<void> _export(_DashData data) async {
    final export = {
      'exportedAt': DateTime.now().toIso8601String(),
      'project': 'SmartKid Insight',
      'sessions': _jsonSafe(data.sessions),
      'responses': data.responses.map((r) => r.toFirestore()).toList(),
    };
    final json = JsonEncoder.withIndent('  ').convert(export);
    final filename = 'smartkid_research_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final downloaded = await downloadJson(filename, json);
    if (!downloaded) {
      await Clipboard.setData(ClipboardData(text: json));
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(downloaded ? 'Research JSON downloaded: $filename' : 'Research JSON copied to clipboard. Paste it into a .json file to save.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null) {
          return _errorState(snap.error);
        }
        final data = snap.data!;
        final responses = _filter(data);
        final children = data.responses.map((r) => r.childId).toSet().toList()..sort();
        final scores = computeDomainScores(responses);
        final correct = responses.where((r) => r.correct).length;
        final accuracy = responses.isEmpty ? 0 : (correct * 100 / responses.length).round();
        final filteredSessions = data.sessions.where((s) => _childFilter == 'all' || s['childId'] == _childFilter).toList();
        final childCount = data.sessions.map((s) => s['childId']).whereType<String>().toSet().length;

        return RefreshIndicator(
          onRefresh: () async => setState(() => _future = _load()),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              _header(data),
              const SizedBox(height: 14),
              _tabs(),
              const SizedBox(height: 12),
              _filters(children),
              const SizedBox(height: 16),
              if (_tab == 'Overview') ...[
                _metricGrid(filteredSessions.length, responses.length, accuracy, childCount),
                const SizedBox(height: 18),
                _sectionTitle('Domain performance overview', Icons.bar_chart_rounded),
                const SizedBox(height: 10),
                ...scores.map(_scoreCard),
                const SizedBox(height: 8),
                _sectionTitle('Recent sessions', Icons.history),
                const SizedBox(height: 8),
                _sessionsTable(filteredSessions.take(8).toList()),
              ] else if (_tab == 'Progress') ...[
                _sectionTitle('Accuracy by assessment domain', Icons.trending_up),
                const SizedBox(height: 8),
                _chartCard(scores),
                const SizedBox(height: 14),
                ...scores.map(_scoreCard),
              ] else if (_tab == 'Responses') ...[
                _sectionTitle('Raw assessment responses', Icons.table_chart_outlined),
                const SizedBox(height: 6),
                Text('${responses.length} filtered records', style: sinhalaText(11, color: AppColors.inkSoft)),
                const SizedBox(height: 8),
                _responsesTable(responses),
              ] else ...[
                _sectionTitle('Assessment sessions', Icons.list_alt),
                const SizedBox(height: 8),
                _sessionsTable(filteredSessions),
              ],
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'Research data uses anonymised child IDs. Screening scores support progress monitoring and are not a clinical diagnosis.',
                  style: sinhalaText(11.5, color: AppColors.ink),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(_DashData data) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFF1F5F9)),
      boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 12, offset: Offset(0, 3))],
    ),
    child: LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 520;
      final heading = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(30)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.auto_awesome, color: Color(0xFF9333EA), size: 15), const SizedBox(width: 6), Text('Researcher & Teacher Dashboard', style: sinhalaText(10.5, color: const Color(0xFF7E22CE), weight: FontWeight.w900))])),
        const SizedBox(height: 10),
        Text('SmartKid Insight Data Analytics', style: sinhalaText(21, weight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('Real-time screening metrics, domain progress charts, raw response tables & research JSON export.', style: sinhalaText(11.5, color: AppColors.inkSoft)),
      ]);
      final actions = Wrap(spacing: 8, children: [
        IconButton.filledTonal(onPressed: () => setState(() => _future = _load()), icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
        FilledButton.icon(onPressed: () => _export(data), icon: const Icon(Icons.download, size: 17), label: const Text('Export Raw JSON'), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF9810FA), foregroundColor: Colors.white, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13))),
      ]);
      return compact ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [heading, const SizedBox(height: 14), actions]) : Row(children: [Expanded(child: heading), const SizedBox(width: 12), actions]);
    }),
  );

  Widget _tabs() {
    const tabs = ['Overview', 'Progress', 'Responses', 'Sessions'];
    const icons = [Icons.bar_chart, Icons.trending_up, Icons.table_chart, Icons.list_alt];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFEFF2F7), borderRadius: BorderRadius.circular(16)),
      child: Row(children: List.generate(tabs.length, (i) => Expanded(child: InkWell(
        borderRadius: BorderRadius.circular(12), onTap: () => setState(() => _tab = tabs[i]),
        child: AnimatedContainer(duration: const Duration(milliseconds: 160), padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2), decoration: BoxDecoration(color: _tab == tabs[i] ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: _tab == tabs[i] ? const [BoxShadow(color: Color(0x12000000), blurRadius: 5)] : null),
          child: Column(children: [Icon(icons[i], size: 17, color: _tab == tabs[i] ? AppColors.ink : AppColors.inkSoft), const SizedBox(height: 3), Text(tabs[i], maxLines: 1, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _tab == tabs[i] ? AppColors.ink : AppColors.inkSoft))]),
        ),
      )))),
    );
  }

  Widget _filters(List<String> children) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Icon(Icons.filter_alt_outlined, color: AppColors.primary, size: 18), const SizedBox(width: 7), Text('Filter research dataset', style: sinhalaText(12, weight: FontWeight.w900))]),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: _childFilter, isExpanded: true, decoration: const InputDecoration(labelText: 'Child ID', isDense: true), items: [const DropdownMenuItem(value: 'all', child: Text('All anonymised children')), ...children.map((id) => DropdownMenuItem(value: id, child: Text(id)))], onChanged: (v) => setState(() => _childFilter = v ?? 'all')),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: _activityFilter, isExpanded: true, decoration: const InputDecoration(labelText: 'Activity', isDense: true), items: [const DropdownMenuItem(value: 'all', child: Text('All activities')), ...ActivityType.values.map((a) => DropdownMenuItem(value: a.key, child: Text(activityInfos[a]!.titleEnglish)))], onChanged: (v) => setState(() => _activityFilter = v ?? 'all')),
    ]),
  );

  Widget _metricGrid(int sessions, int responses, int accuracy, int children) {
    final metrics = [
      ('Total Sessions', '$sessions', Icons.event_note, const Color(0xFFFFEDD5)),
      ('Item Responses', '$responses', Icons.fact_check_outlined, const Color(0xFFDBEAFE)),
      ('Overall Accuracy', '$accuracy%', Icons.track_changes, const Color(0xFFD1FAE5)),
      ('Unique Children', '$children', Icons.child_care, const Color(0xFFEDE9FE)),
    ];
    return LayoutBuilder(builder: (context, box) {
      final cols = box.maxWidth > 600 ? 4 : 2;
      final width = (box.maxWidth - (cols - 1) * 9) / cols;
      return Wrap(spacing: 9, runSpacing: 9, children: metrics.map((m) => SizedBox(width: width, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: m.$4, borderRadius: BorderRadius.circular(11)), child: Icon(m.$3, color: AppColors.ink, size: 19)), const SizedBox(height: 10), Text(m.$2, style: sinhalaText(23, weight: FontWeight.w900)), Text(m.$1, style: sinhalaText(10.5, color: AppColors.inkSoft))])))).toList());
    });
  }

  Widget _sectionTitle(String title, IconData icon) => Row(children: [Icon(icon, color: AppColors.primary, size: 19), const SizedBox(width: 7), Expanded(child: Text(title, style: sinhalaText(15, weight: FontWeight.w900)))]);

  Widget _scoreCard(DomainScore s) {
    final info = activityInfos[s.activityType]!;
    final color = levelColor(s.accuracyPercent);
    final has = s.totalQuestions > 0;
    return Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(info.emoji, style: const TextStyle(fontSize: 22)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(info.titleSinhala, style: sinhalaText(13, weight: FontWeight.w900)), Text(info.titleEnglish, style: sinhalaText(10.5, color: AppColors.inkSoft))])), Text(has ? '${s.accuracyPercent}% · ${s.level.label}' : 'No data', style: TextStyle(color: has ? color : AppColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w900))]),
      const SizedBox(height: 9), ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: has ? s.accuracyPercent / 100 : 0, minHeight: 9, backgroundColor: AppColors.line, valueColor: AlwaysStoppedAnimation(color))),
      const SizedBox(height: 5), Text('${s.correctCount}/${s.totalQuestions} correct · avg ${formatSeconds(s.avgTimeMs)}', style: sinhalaText(10.5, color: AppColors.inkSoft)),
    ]));
  }

  Widget _chartCard(List<DomainScore> scores) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)), child: Column(children: scores.map((s) {
    final info = activityInfos[s.activityType]!;
    final color = levelColor(s.accuracyPercent);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [SizedBox(width: 90, child: Text(info.titleEnglish, style: sinhalaText(10, color: AppColors.inkSoft), maxLines: 2)), Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: s.totalQuestions == 0 ? 0 : s.accuracyPercent / 100, minHeight: 15, backgroundColor: AppColors.line, valueColor: AlwaysStoppedAnimation(color)))), const SizedBox(width: 9), SizedBox(width: 38, child: Text('${s.accuracyPercent}%', textAlign: TextAlign.end, style: sinhalaText(11, weight: FontWeight.w900))) ]));
  }).toList()));

  Widget _responsesTable(List<AssessmentResponse> rows) {
    if (rows.isEmpty) return _empty('No response records match these filters.');
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(columnSpacing: 14, headingRowColor: WidgetStateProperty.all(const Color(0xFFFFEDD5)), columns: const [DataColumn(label: Text('Child ID')), DataColumn(label: Text('Activity')), DataColumn(label: Text('Item')), DataColumn(label: Text('Answer')), DataColumn(label: Text('Result')), DataColumn(label: Text('Time (ms)')), DataColumn(label: Text('Date'))], rows: rows.take(300).map((r) => DataRow(cells: [DataCell(Text(r.childId)), DataCell(Text(activityInfos[r.activityType]!.titleEnglish)), DataCell(Text(r.itemId)), DataCell(Text(r.selectedAnswer)), DataCell(Icon(r.correct ? Icons.check_circle : Icons.cancel, color: r.correct ? AppColors.strong : AppColors.weak, size: 18)), DataCell(Text('${r.responseTimeMs}')), DataCell(Text(_dateLabel(r.timestamp)))] )).toList()));
  }

  Widget _sessionsTable(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return _empty('No sessions are available yet.');
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(columnSpacing: 18, headingRowColor: WidgetStateProperty.all(const Color(0xFFEDE9FE)), columns: const [DataColumn(label: Text('Child ID')), DataColumn(label: Text('Age band')), DataColumn(label: Text('Activities')), DataColumn(label: Text('Status')), DataColumn(label: Text('Started'))], rows: rows.map((s) { final activities = (s['completedActivities'] as List?)?.length ?? 0; return DataRow(cells: [DataCell(Text('${s['childId'] ?? '-'}')), DataCell(Text('${s['ageBand'] ?? '-'}')), DataCell(Text('$activities / 5')), DataCell(Text(s['isComplete'] == true ? 'Completed' : 'In progress')), DataCell(Text(_dateLabel(_dateOf(s))))]); }).toList()));
  }

  String _dateLabel(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  Widget _empty(String text) => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)), child: Center(child: Text(text, style: sinhalaText(12, color: AppColors.inkSoft), textAlign: TextAlign.center)));
  Widget _errorState(Object? error) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off, size: 42, color: AppColors.weak), const SizedBox(height: 12), Text('Could not load research data. Check your connection and Firestore permissions.', textAlign: TextAlign.center, style: sinhalaText(13)), const SizedBox(height: 12), ElevatedButton(onPressed: () => setState(() => _future = _load()), child: const Text('Retry')), if (error != null) Text('$error', style: sinhalaText(10, color: AppColors.inkSoft))])));
}

class _DashData {
  final List<Map<String, dynamic>> sessions;
  final List<AssessmentResponse> responses;
  const _DashData(this.sessions, this.responses);
}
