import 'package:flutter/material.dart';
import 'data.dart';
import 'ui.dart';
import 'main.dart' show WelcomeScreen;
import 'explore.dart' show go, CampaignEditorScreen, CampaignDetailScreen;

// ---------- AI tree recommendations ----------
class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});
  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  String soil = 'Clay', water = 'Low', space = 'Garden';
  List<Species>? results;

  void run() {
    final scored = speciesDb.map((s) {
      var score = 0;
      if (s.soils.contains(soil)) score += 2;
      if (s.water.contains(water)) score += 2;
      if (space == 'Street' && s.name == 'Sissoo') score++;
      if (space == 'Garden' && s.name == 'Pomegranate') score++;
      if (space == 'Hillside' && s.latin.startsWith('Q')) score++;
      return (s, score);
    }).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));
    setState(() => results = scored.take(3).map((e) => e.$1).toList());
  }

  Widget _choice(String title, List<String> opts, String val, ValueChanged<String> on) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: label),
          gapS,
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final o in opts) Pill(o, selected: val == o, onTap: () => setState(() => on(o))),
          ]),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Body([
          const Crumb('My trees'),
          Box(
            color: C.green,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI TREE RECOMMENDATIONS', style: eyebrow.copyWith(color: const Color(0xFFB9D3B4))),
              gapS,
              Text('Find a tree that feels right at home.', style: h1(Colors.white)),
              const SizedBox(height: 10),
              Text('Local conditions. Native possibilities. A greener future rooted in the right choices.',
                  style: body.copyWith(color: const Color(0xFFD5E0D2))),
              gap,
              Box(
                color: C.green2,
                pad: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('✓  Verified species database',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('Matches for Kurdistan, grounded in regional species references.',
                      style: body.copyWith(color: const Color(0xFFD5E0D2), fontSize: 11)),
                ]),
              ),
            ]),
          ),
          gap,
          Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tell us about your planting spot', style: h2()),
            gap,
            const Field('Location', 'Erbil, Kurdistan Region'),
            _choice('Soil type', ['Clay', 'Loam', 'Sandy', 'Rocky'], soil, (v) => soil = v),
            _choice('Water available', ['Low', 'Medium', 'High'], water, (v) => water = v),
            _choice('Space', ['Garden', 'Street', 'Hillside'], space, (v) => space = v),
            SizedBox(width: double.infinity, child: Btn('Find my trees', onTap: run)),
          ])),
          if (results != null) ...[
            gap,
            Text('Best matches', style: h2()),
            gapS,
            for (final (i, s) in results!.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Box(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i == 0 ? 'TOP MATCH' : 'GOOD MATCH', style: eyebrow),
                    const SizedBox(height: 6),
                    Text(s.name, style: h2()),
                    Text(s.latin, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: C.muted)),
                    gapS,
                    Text(s.why, style: body),
                  ]),
                ),
              ),
          ],
        ]),
      );
}

// ---------- Notifications ----------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListenableBuilder(
          listenable: app,
          builder: (context, _) => Body([
            const Crumb('Back'),
            Row(children: [
              Expanded(child: Text('Notifications', style: h1())),
              TextButton(
                  onPressed: () {
                    for (final n in app.notes) {
                      n.read = true;
                    }
                    app.touch();
                  },
                  child: const Text('Mark all read', style: TextStyle(color: C.green2, fontSize: 12))),
            ]),
            gap,
            for (final n in app.notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    n.read = true;
                    app.touch();
                    if (n.title.startsWith('Planting day')) go(context, CampaignDetailScreen(campaigns.firstWhere((c) => c.id == 'GC')));
                  },
                  child: Box(
                    color: n.read ? Colors.white : C.tint,
                    pad: const EdgeInsets.all(16),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(n.read ? Icons.notifications_none : Icons.notifications_active, size: 18, color: C.green2),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(n.body, style: body.copyWith(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(n.time, style: const TextStyle(fontSize: 10, color: C.muted)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      );
}

// ---------- Profile & settings ----------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListenableBuilder(
          listenable: app,
          builder: (context, _) => Body([
            const Crumb('Back'),
            Box(
              child: Column(children: [
                CircleAvatar(
                    radius: 34,
                    backgroundColor: C.tint,
                    child: Text(app.name.split(' ').map((w) => w[0]).take(2).join(),
                        style: const TextStyle(fontSize: 22, color: C.green))),
                const SizedBox(height: 10),
                Text(app.name, style: h2()),
                Text('${app.role} · Erbil, Kurdistan Region', style: body),
                gap,
                Row(children: [
                  _n('${app.trees.length}', 'Trees'),
                  _n('${app.registrations.length + 4}', 'Plantings'),
                  _n('${app.seedlingsDonated}', 'Donated'),
                ]),
              ]),
            ),
            gap,
            Text('Badges', style: h2()),
            gapS,
            Wrap(spacing: 8, runSpacing: 8, children: [
              _badge(Icons.eco, 'First roots', true),
              _badge(Icons.water_drop, 'Week of care', true),
              _badge(Icons.forest, '10 trees', false),
              _badge(Icons.volunteer_activism, 'Donor', app.seedlingsDonated > 0),
            ]),
            gap,
            Text('Settings', style: h2()),
            gapS,
            Box(
              pad: EdgeInsets.zero,
              child: Column(children: [
                SwitchListTile(
                    activeColor: C.green2,
                    title: const Text('Care reminders', style: label),
                    value: app.reminders,
                    onChanged: (v) {
                      app.reminders = v;
                      app.touch();
                    }),
                ListTile(
                  title: const Text('Account type', style: label),
                  trailing: DropdownButton<String>(
                    value: app.role,
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 12, color: C.green),
                    items: [
                      for (final r in ['Volunteer', 'Donor', 'Organization']) DropdownMenuItem(value: r, child: Text(r))
                    ],
                    onChanged: (v) {
                      app.role = v!;
                      app.touch();
                    },
                  ),
                ),
                if (app.role == 'Organization')
                  ListTile(
                      title: const Text('Create a campaign', style: label),
                      trailing: const Icon(Icons.add),
                      onTap: () => go(context, const CampaignEditorScreen())),
                const ListTile(title: Text('Language', style: label), trailing: Text('English · کوردی · عربي', style: body)),
                ListTile(
                    title: const Text('About PlantIt', style: label),
                    trailing: const Icon(Icons.info_outline, size: 18),
                    onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'PlantIt',
                        applicationVersion: 'Demo 1.0',
                        children: const [
                          Text(
                              'Class demo. Places and organizations are real (Rwanga Foundation and Hasar Organization run tree-planting work in Erbil), but campaigns, dates, numbers and people shown are illustrative.')
                        ])),
                ListTile(
                  title: const Text('Log out', style: TextStyle(color: C.orange, fontSize: 12, fontWeight: FontWeight.w500)),
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false),
                ),
              ]),
            ),
          ]),
        ),
      );

  Widget _n(String n, String l) => Expanded(
          child: Column(children: [
        Text(n, style: const TextStyle(fontSize: 20, color: C.green)),
        Text(l, style: const TextStyle(fontSize: 10, color: C.muted)),
      ]));

  Widget _badge(IconData i, String t, bool on) => Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: on ? C.tint : Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Icon(i, color: on ? C.green2 : C.line),
          const SizedBox(height: 4),
          Text(t, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: on ? C.ink : C.muted)),
        ]),
      );
}
