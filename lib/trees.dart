import 'package:flutter/material.dart';
import 'data.dart';
import 'ui.dart';
import 'explore.dart' show go, fmt;
import 'more.dart' show RecommendScreen;

// ---------- My trees ----------
class MyTreesScreen extends StatelessWidget {
  const MyTreesScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Body([
          Text('Your growing\nforest.', style: h1()),
          gapS,
          Text('${app.trees.length} trees planted by you, still growing.', style: body),
          gap,
          for (final t in app.trees)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => go(context, TreeProfileScreen(t)),
                child: Box(
                  pad: const EdgeInsets.all(14),
                  child: Row(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/oak.png', width: 64, height: 64, fit: BoxFit.cover)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text('Tree ${t.id} · ${t.height.toStringAsFixed(1)} m', style: const TextStyle(fontSize: 11, color: C.muted)),
                        const SizedBox(height: 6),
                        Dot(t.status, color: t.status == 'Needs water' ? C.orange : C.green2),
                      ]),
                    ),
                    const Icon(Icons.chevron_right, color: C.muted),
                  ]),
                ),
              ),
            ),
          gapS,
          Box(
            color: C.green,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI TREE RECOMMENDATIONS', style: eyebrow.copyWith(color: const Color(0xFFB9D3B4))),
              gapS,
              Text('Planting at home?', style: h2(Colors.white)),
              const SizedBox(height: 6),
              Text('Find a native tree that suits your spot.', style: body.copyWith(color: const Color(0xFFD5E0D2))),
              gap,
              Btn('Find a tree', icon: Icons.arrow_forward, onTap: () => go(context, const RecommendScreen())),
            ]),
          ),
        ]),
      );
}

// ---------- Tree profile ----------
class TreeProfileScreen extends StatelessWidget {
  final Tree t;
  const TreeProfileScreen(this.t, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListenableBuilder(
          listenable: app,
          builder: (context, _) => Body([
            Crumb('My trees / ${t.id}'),
            Text(t.name == 'Persian oak' ? 'A Kurdish oak. A growing legacy.' : 'A ${t.name.toLowerCase()}. A growing legacy.',
                style: h1()),
            gapS,
            Text('${t.name} · ${t.latin} · Tree ${t.id}', style: body),
            gap,
            Btn('Add growth update', onTap: () => _update(context)),
            gap,
            const Photo('assets/oak.png', h: 260),
            gap,
            Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Dot(t.status, color: t.status == 'Needs water' ? C.orange : C.green2),
              gapS,
              Text('${t.height.toStringAsFixed(1)} m', style: const TextStyle(fontSize: 34, color: C.green)),
              Text('Planted ${t.planted} · ${t.campaign}', style: body),
            ])),
            gap,
            Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Growth timeline', style: h2()),
              gapS,
              for (final u in t.updates)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Padding(padding: EdgeInsets.only(top: 4), child: Icon(Icons.circle, size: 8, color: C.green2)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(u, style: const TextStyle(fontSize: 12))),
                  ]),
                ),
            ])),
          ]),
        ),
      );

  void _update(BuildContext context) {
    final h = TextEditingController(text: (t.height + .1).toStringAsFixed(1));
    String status = 'Healthy & growing';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.bg,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Growth update', style: h2()),
            gap,
            Field('Height (m)', '1.3', ctrl: h),
            const Text('How does it look?', style: label),
            gapS,
            Wrap(spacing: 6, children: [
              for (final s in ['Healthy & growing', 'Needs water', 'Damaged'])
                Pill(s, selected: status == s, onTap: () => set(() => status = s)),
            ]),
            gap,
            OutlinedButton.icon(
                onPressed: () => toast(ctx, 'Photo attached'),
                icon: const Icon(Icons.photo_camera_outlined, size: 16),
                label: const Text('Add photo')),
            gap,
            SizedBox(
                width: double.infinity,
                child: Btn('Save update', onTap: () {
                  t.height = double.tryParse(h.text) ?? t.height;
                  t.status = status;
                  t.updates.insert(0, 'Nov 23: $status, ${t.height.toStringAsFixed(1)} m');
                  app.touch();
                  Navigator.pop(ctx);
                })),
          ]),
        ),
      ),
    );
  }
}

// ---------- Watering & care ----------
class CareScreen extends StatefulWidget {
  const CareScreen({super.key});
  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  int day = 23;
  bool calendar = false;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final shown = calendar ? app.tasks.where((t) => t.day == day).toList() : app.tasks;
          return Body([
            Text('Keep good things growing.', style: h1()),
            gapS,
            const Text('A little attention today. A stronger canopy tomorrow.', style: body),
            gap,
            SwitchListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              activeColor: C.green2,
              value: app.reminders,
              onChanged: (v) {
                app.reminders = v;
                app.touch();
              },
              title: const Text('Care reminders', style: label),
              subtitle: Text(app.reminders ? 'On · Email, 1 day before each task' : 'Off',
                  style: const TextStyle(fontSize: 11, color: C.muted)),
            ),
            const SizedBox(height: 20),
            Text('November 2026', style: h2().copyWith(fontSize: 20)),
            gap,
            Row(children: [
              Expanded(child: Pill('List view', selected: !calendar, onTap: () => setState(() => calendar = false))),
              const SizedBox(width: 6),
              Expanded(child: Pill('Calendar', selected: calendar, onTap: () => setState(() => calendar = true))),
            ]),
            gap,
            Row(children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      day = 23 + i;
                      calendar = true;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: day == 23 + i ? C.green2 : null, borderRadius: BorderRadius.circular(6)),
                      child: Column(children: [
                        Text('MTWTFSS'[i],
                            style: TextStyle(fontSize: 10, color: day == 23 + i ? Colors.white : C.muted)),
                        const SizedBox(height: 4),
                        Text('${23 + i}', style: TextStyle(fontSize: 15, color: day == 23 + i ? Colors.white : C.ink)),
                        const SizedBox(height: 2),
                        Icon(Icons.circle,
                            size: 5,
                            color: app.tasks.any((t) => t.day == 23 + i && !t.done) ? C.orange : Colors.transparent),
                      ]),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 20),
            Text('Coming up · ${shown.where((t) => !t.done).length} tasks', style: h2()),
            gap,
            for (final t in shown)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Box(
                  pad: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.when.toUpperCase(), style: eyebrow.copyWith(color: t.day == 23 ? C.orange : C.green2)),
                        const SizedBox(height: 4),
                        Text(t.title,
                            style: TextStyle(
                                fontSize: 15, decoration: t.done ? TextDecoration.lineThrough : null)),
                        Text('Tree ${t.tree}', style: const TextStyle(fontSize: 11, color: C.muted)),
                      ]),
                    ),
                    Checkbox(
                        value: t.done,
                        activeColor: C.green2,
                        onChanged: (v) {
                          t.done = v!;
                          app.touch();
                          if (v) toast(context, 'Nice work. Logged for tree ${t.tree}');
                        }),
                  ]),
                ),
              ),
            if (shown.isEmpty) const Text('Nothing to do this day. 🌱', style: body),
          ]);
        },
      );
}

// ---------- Community impact ----------
class ImpactScreen extends StatefulWidget {
  const ImpactScreen({super.key});
  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  String city = 'Erbil';
  String range = 'All time';
  @override
  Widget build(BuildContext context) {
    final k = city == 'Erbil' ? 1.0 : (city == 'Duhok' ? .38 : .52);
    final r = range == 'All time' ? 1.0 : (range == 'This year' ? .46 : .08);
    int v(int n) => (n * k * r).round();
    const months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    const bars = [.35, .2, .15, .45, .8, 1.0];
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) => Body([
        Text("Look what we're growing.", style: h1()),
        gapS,
        const Text('Every tree is a small act of hope. Together, they add up.', style: body),
        gap,
        Btn('Download report', outline: true, icon: Icons.arrow_downward,
            onTap: () => toast(context, 'PlantIt_Impact_${city}_${range.replaceAll(' ', '')}.pdf saved')),
        gapS,
        Row(children: [
          Expanded(child: _drop(city, ['Erbil', 'Duhok', 'Sulaymaniyah'], (x) => setState(() => city = x))),
          const SizedBox(width: 8),
          Expanded(child: _drop(range, ['All time', 'This year', 'This month'], (x) => setState(() => range = x))),
        ]),
        gap,
        _stat(fmt(v(12480)), 'Trees planted', 'Across $city'),
        _stat(fmt(v(38) < 1 ? 1 : v(38)), 'Active campaigns', 'Growing together'),
        _stat(fmt(v(3260)), 'Volunteers', 'Giving their time'),
        _stat(fmt(v(19840) + app.seedlingsDonated), 'Seedlings donated', 'Generosity in action'),
        Box(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Trees planted per month', style: label),
          gap,
          SizedBox(
            height: 120,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              for (var i = 0; i < 6; i++)
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                        height: 90 * bars[i],
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: i == 5 ? C.orange : C.green2, borderRadius: BorderRadius.circular(3))),
                    const SizedBox(height: 6),
                    Text(months[i], style: const TextStyle(fontSize: 10, color: C.muted)),
                  ]),
                ),
            ]),
          ),
        ])),
        gap,
        Box(
            color: C.tint,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Your impact', style: label),
              gapS,
              Text(
                  '${app.trees.length} trees planted · ${app.registrations.length} upcoming plantings · ${app.seedlingsDonated} seedlings donated',
                  style: body),
            ])),
      ]),
    );
  }

  Widget _drop(String val, List<String> opts, ValueChanged<String> on) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(6)),
        child: DropdownButton<String>(
          value: val,
          isExpanded: true,
          underline: const SizedBox(),
          style: const TextStyle(fontSize: 12, color: C.green),
          items: [for (final o in opts) DropdownMenuItem(value: o, child: Text(o))],
          onChanged: (x) => on(x!),
        ),
      );

  Widget _stat(String n, String t, String s) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Box(
          child: Row(children: [
            SizedBox(width: 120, child: Text(n, style: const TextStyle(fontSize: 24, color: C.green))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(s, style: const TextStyle(fontSize: 10, color: C.muted)),
            ]),
          ]),
        ),
      );
}
