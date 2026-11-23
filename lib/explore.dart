import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'data.dart';
import 'ui.dart';

void go(BuildContext context, Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));

String fmt(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

// ---------- Explore ----------
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final list = campaigns
              .where((c) => '${c.title} ${c.place} ${c.area} ${c.org.name}'.toLowerCase().contains(q.toLowerCase()))
              .toList();
          return Body([
            Box(
              color: C.green,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('TOGETHER, WE GROW', style: eyebrow.copyWith(color: const Color(0xFFB9D3B4))),
                const SizedBox(height: 10),
                Text('Put down roots.\nLift up a community.', style: h1(Colors.white)),
                const SizedBox(height: 10),
                Text(
                    'Support tree-planting initiatives across Erbil and the Kurdistan Region. Volunteer, donate, and help build a greener future.',
                    style: body.copyWith(color: const Color(0xFFD5E0D2))),
                gap,
                Btn('Find your next planting',
                    icon: Icons.arrow_forward, onTap: () => go(context, const CampaignMapScreen())),
                gap,
                const Photo('assets/community.png', h: 120),
              ]),
            ),
            const SizedBox(height: 20),
            Row(children: [
              _stat('12,480', 'trees planted'),
              _stat('${campaigns.length + 32}', 'active campaigns'),
              _stat('94%', 'survival rate'),
            ]),
            const SizedBox(height: 24),
            Text('Find your patch of green', style: h1().copyWith(fontSize: 22)),
            const SizedBox(height: 4),
            const Text('Real people. Local roots. Lasting change.', style: body),
            gap,
            const Text('Search campaigns', style: label),
            gapS,
            Row(children: [
              Expanded(
                child: TextField(
                    onChanged: (v) => setState(() => q = v),
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                        hintText: 'Search by campaign or neighborhood', prefixIcon: Icon(Icons.search, size: 18))),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: C.line),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                    onPressed: () => go(context, const CampaignMapScreen()),
                    icon: const Icon(Icons.map_outlined, size: 16, color: C.green),
                    label: const Text('Map', style: TextStyle(color: C.green))),
              ),
            ]),
            gap,
            for (final c in list) CampaignCard(c),
            if (list.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Text('No campaigns match.', style: body)),
            if (app.role == 'Organization') ...[
              gapS,
              Btn('Create a campaign', outline: true, icon: Icons.add, onTap: () => go(context, const CampaignEditorScreen())),
            ],
          ]);
        },
      );

  Widget _stat(String n, String l) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(n, style: const TextStyle(fontSize: 22, color: C.green, fontWeight: FontWeight.w500)),
        Text(l, style: const TextStyle(fontSize: 10, color: C.muted)),
      ]));
}

class CampaignCard extends StatelessWidget {
  final Campaign c;
  const CampaignCard(this.c, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => go(context, CampaignDetailScreen(c)),
          borderRadius: BorderRadius.circular(12),
          child: Box(
            pad: const EdgeInsets.all(14),
            child: Row(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(c.image, width: 72, height: 72, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${c.place} · ${c.date.split(',').last.trim()}', style: const TextStyle(fontSize: 11, color: C.muted)),
                  Text(c.org.name, style: const TextStyle(fontSize: 11, color: C.green2)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                        value: c.progress, minHeight: 5, backgroundColor: C.tint, color: C.green2),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      );
}

// ---------- Campaign map (new) ----------
class CampaignMapScreen extends StatefulWidget {
  const CampaignMapScreen({super.key});
  @override
  State<CampaignMapScreen> createState() => _CampaignMapScreenState();
}

class _CampaignMapScreenState extends State<CampaignMapScreen> {
  Campaign sel = campaigns.first;
  final map = MapController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          FlutterMap(
            mapController: map,
            options: const MapOptions(initialCenter: LatLng(36.25, 44.05), initialZoom: 10.3),
            children: [
              TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'app.plantit.demo'),
              MarkerLayer(markers: [
                for (final c in campaigns)
                  Marker(
                    point: c.pos,
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => sel = c);
                        map.move(c.pos, 12);
                      },
                      child: Icon(Icons.location_on, size: c == sel ? 44 : 34, color: c == sel ? C.orange : C.green),
                    ),
                  ),
              ]),
              const RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap contributors')]),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(children: [
              FloatingActionButton.small(
                  heroTag: 'back',
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: C.green)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text('${campaigns.length} campaigns near Erbil', style: label),
                ),
              ),
            ]),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Box(
              pad: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                const Dot('Registration open'),
                gapS,
                Text(sel.title, style: h2()),
                const SizedBox(height: 4),
                Text('${sel.place}, ${sel.area}', style: body),
                Text('${sel.date} · ${sel.time}', style: body),
                Text('Hosted by ${sel.org.name}', style: const TextStyle(fontSize: 12, color: C.green2)),
                const SizedBox(height: 12),
                SizedBox(
                    width: double.infinity,
                    child: Btn('View campaign', onTap: () => go(context, CampaignDetailScreen(sel)))),
              ]),
            ),
          ),
        ]),
      );
}

// ---------- Campaign details ----------
class CampaignDetailScreen extends StatelessWidget {
  final Campaign c;
  const CampaignDetailScreen(this.c, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListenableBuilder(
          listenable: app,
          builder: (context, _) {
            final joined = app.registrations.contains(c.id);
            return Body([
              Crumb('All campaigns / ${c.area}, Kurdistan Region'),
              Photo(c.image, h: 200),
              gap,
              const Dot('Registration open'),
              const SizedBox(height: 10),
              Text(c.title, style: h1()),
              const SizedBox(height: 12),
              Text(c.blurb, style: body),
              const SizedBox(height: 10),
              Text('Hosted by ${c.org.name}', style: const TextStyle(fontSize: 12, color: C.green2, fontWeight: FontWeight.w500)),
              gap,
              Box(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.date, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${c.time} · Erbil local time', style: const TextStyle(fontSize: 11, color: C.muted)),
                const Divider(height: 24, color: C.line),
                _row(Icons.place_outlined, '${c.place}, ${c.area}'),
                _row(Icons.park_outlined, c.species),
                _row(Icons.groups_outlined, '${c.volunteers} neighbors going'),
                gapS,
                Text('${fmt(c.planted)} of ${fmt(c.goal)} trees planted', style: const TextStyle(fontSize: 11, color: C.muted)),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: c.progress, minHeight: 6, backgroundColor: C.tint, color: C.green2),
              ])),
              gap,
              Box(
                  color: C.tint,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('About ${c.org.name}', style: label),
                    gapS,
                    Text(c.org.about, style: body),
                  ])),
              gap,
              Btn(joined ? "You're registered ✓" : 'Volunteer for this planting',
                  onTap: joined ? null : () => go(context, VolunteerFormScreen(c))),
              gapS,
              Btn('Donate seedlings', outline: true, onTap: () => go(context, DonateScreen(c))),
            ]);
          },
        ),
      );

  Widget _row(IconData i, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Icon(i, size: 16, color: C.green2),
          const SizedBox(width: 8),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 12))),
        ]),
      );
}

// ---------- Volunteer registration ----------
class VolunteerFormScreen extends StatefulWidget {
  final Campaign c;
  const VolunteerFormScreen(this.c, {super.key});
  @override
  State<VolunteerFormScreen> createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  String session = 'Full session';
  final skills = <String>{'Planting'};
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Body([
          Crumb(widget.c.title),
          Text('A few details.\nA big difference.', style: h1()),
          gapS,
          Text('Join ${widget.c.volunteers} neighbors for a morning of planting and connection.', style: body),
          gap,
          Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your details', style: h2()),
            gap,
            Field('Full name *', '', ctrl: TextEditingController(text: app.name)),
            Field('Email address *', '', ctrl: TextEditingController(text: app.email)),
            const Field('Phone number *', '+964 7XX XXX XXXX'),
            const Text('Availability *', style: label),
            gapS,
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final s in ['Full session', 'First half', 'Second half'])
                Pill(s, selected: session == s, onTap: () => setState(() => session = s)),
            ]),
            gap,
            const Text('Skills & interests', style: label),
            gapS,
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final s in ['Planting', 'Happy to learn', 'Photography', 'First aid', 'Can bring tools'])
                Pill(s,
                    selected: skills.contains(s),
                    onTap: () => setState(() => skills.contains(s) ? skills.remove(s) : skills.add(s))),
            ]),
          ])),
          gap,
          Btn('Confirm my spot', onTap: () {
            app.register(widget.c.id);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => VolunteerConfirmedScreen(widget.c, '$session · ${skills.join(' & ')}')));
          }),
        ]),
      );
}

class _Confirm extends StatelessWidget {
  final String title, intro, code, heading, primary;
  final List<String> lines;
  final VoidCallback onPrimary;
  const _Confirm(
      {required this.title,
      required this.intro,
      required this.code,
      required this.heading,
      required this.lines,
      required this.primary,
      required this.onPrimary});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Body([
          Box(
            child: Column(children: [
              const Icon(Icons.check, size: 30, color: C.green2),
              gap,
              Text(title, textAlign: TextAlign.center, style: h2().copyWith(fontSize: 20)),
              const SizedBox(height: 10),
              Text(intro, textAlign: TextAlign.center, style: body),
              gap,
              Box(
                  color: C.tint,
                  pad: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(code, style: eyebrow),
                    gapS,
                    Text(heading, style: const TextStyle(fontWeight: FontWeight.w600, color: C.green)),
                    gapS,
                    for (final l in lines) Text(l, style: const TextStyle(fontSize: 11, color: C.muted)),
                  ])),
              gap,
              Text('A confirmation and all the details are on their way to ${app.email}.', style: body),
              gap,
              SizedBox(width: double.infinity, child: Btn(primary, onTap: onPrimary)),
              gapS,
              SizedBox(
                  width: double.infinity,
                  child: Btn('Explore more campaigns',
                      outline: true, onTap: () => Navigator.popUntil(context, (r) => r.isFirst))),
            ]),
          ),
        ]),
      );
}

class VolunteerConfirmedScreen extends StatelessWidget {
  final Campaign c;
  final String detail;
  const VolunteerConfirmedScreen(this.c, this.detail, {super.key});
  @override
  Widget build(BuildContext context) => _Confirm(
        title: "You're on the team!",
        intro: 'Thanks, ${app.name.split(' ').first}. Your spot is saved for ${c.title}.',
        code: 'REGISTRATION ${c.id}-V${2086 + c.volunteers}',
        heading: c.title,
        lines: [c.date, '${c.time} · ${c.place}', detail],
        primary: 'Add to calendar',
        onPrimary: () => toast(context, 'Added to your calendar'),
      );
}

// ---------- Donate seedlings ----------
class DonateScreen extends StatefulWidget {
  final Campaign c;
  const DonateScreen(this.c, {super.key});
  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String species = 'Persian oak';
  int qty = 10;
  bool dropOff = true;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Body([
          Crumb(widget.c.title),
          Text('Give a seedling.\nGrow a future.', style: h1()),
          gapS,
          Text('Your donation helps ${widget.c.goal} native trees find their roots.', style: body),
          gap,
          Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your seedlings', style: h2()),
            gap,
            const Text('Tree species *', style: label),
            gapS,
            DropdownButtonFormField<String>(
              value: species,
              style: const TextStyle(fontSize: 13, color: C.ink),
              items: [for (final s in speciesDb) DropdownMenuItem(value: s.name, child: Text(s.name))],
              onChanged: (v) => setState(() => species = v!),
            ),
            gap,
            const Text('Quantity *', style: label),
            gapS,
            Row(children: [
              IconButton.outlined(onPressed: qty > 1 ? () => setState(() => qty--) : null, icon: const Icon(Icons.remove)),
              Expanded(child: Center(child: Text('$qty', style: h2()))),
              IconButton.outlined(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
            ]),
            gapS,
            const Text('Healthy native seedlings, ideally 1–2 years old.', style: TextStyle(fontSize: 11, color: C.muted)),
            gap,
            const Text('How will they reach us? *', style: label),
            gapS,
            _opt("I'll drop them off", dropOff, () => setState(() => dropOff = true)),
            gapS,
            _opt('Request a pickup', !dropOff, () => setState(() => dropOff = false)),
            gap,
            Text(dropOff ? 'Drop-off · Fri, Nov 27, 10 AM–4 PM\nCampaign nursery, ${widget.c.place}' : 'Pickup · we will call you to arrange a time',
                style: body),
          ])),
          gap,
          Btn('Donate $qty seedlings', onTap: () {
            app.donate(widget.c.id, qty);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) => _Confirm(
                          title: '${_word(qty)} seedlings.\nCountless possibilities.',
                          intro:
                              'Thank you, ${app.name.split(' ').first}. Your $qty $species seedlings will help a whole neighborhood flourish.',
                          code: 'DONATION ${widget.c.id}-D${1042 + app.seedlingsDonated}',
                          heading: widget.c.title,
                          lines: [
                            '$qty × $species',
                            dropOff ? 'Drop-off · Fri, Nov 27, 10 AM–4 PM' : 'Pickup requested',
                            '${widget.c.place} campaign nursery'
                          ],
                          primary: 'Back to campaign',
                          onPrimary: () => Navigator.pop(ctx),
                        )));
          }),
        ]),
      );

  Widget _opt(String t, bool on, VoidCallback tap) => GestureDetector(
        onTap: tap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: on ? C.tint : const Color(0xFFF1F3EC), borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            Icon(on ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: C.green2),
            const SizedBox(width: 8),
            Text(t, style: const TextStyle(fontSize: 12, color: C.green)),
          ]),
        ),
      );

  static String _word(int n) =>
      const {1: 'One', 2: 'Two', 3: 'Three', 4: 'Four', 5: 'Five', 6: 'Six', 7: 'Seven', 8: 'Eight', 9: 'Nine', 10: 'Ten'}[n] ??
      '$n';
}

// ---------- Campaign editor (organization) ----------
class CampaignEditorScreen extends StatefulWidget {
  const CampaignEditorScreen({super.key});
  @override
  State<CampaignEditorScreen> createState() => _CampaignEditorScreenState();
}

class _CampaignEditorScreenState extends State<CampaignEditorScreen> {
  final title = TextEditingController(text: 'Winter roots at Shanidar');
  final desc = TextEditingController(
      text: 'Help us restore native shade at Shanidar. Join neighbors for a morning of planting, learning, and connection.');
  final place = TextEditingController(text: 'Shanidar valley');
  final goal = TextEditingController(text: '150');
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Body([
          const Crumb('Organization / Campaigns / New campaign'),
          Text('Give your community something to grow.', style: h1()),
          gapS,
          const Text('Create a campaign · Draft saved just now', style: body),
          gap,
          Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('01  The essentials', style: h2()),
            gap,
            Field('Campaign title *', '', ctrl: title),
            Field('Description *', '', ctrl: desc, lines: 4),
            Field('Location *', '', ctrl: place),
            Field('Tree goal *', '', ctrl: goal),
            const Text('Cover photo *', style: label),
            gapS,
            const Photo('assets/community.png', h: 160),
          ])),
          gap,
          Btn('Publish campaign', onTap: () {
            app.addCampaign(Campaign(
                id: 'NC',
                title: title.text,
                place: place.text,
                area: 'Erbil Governorate',
                date: 'Saturday, January 9',
                time: '9:00 AM–12:00 PM',
                orgId: 'gec',
                blurb: desc.text,
                species: 'Persian oak, wild pistachio',
                pos: const LatLng(36.30, 44.10),
                goal: int.tryParse(goal.text) ?? 100,
                planted: 0,
                volunteers: 0));
            toast(context, 'Campaign published');
            Navigator.pop(context);
          }),
        ]),
      );
}
