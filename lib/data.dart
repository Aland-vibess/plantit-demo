import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class Org {
  final String name, about;
  final bool real;
  const Org(this.name, this.about, {this.real = false});
}

const orgs = {
  'rwanga': Org('Rwanga Foundation',
      'Erbil-based NGO (est. 2013) working in education, youth, environment and support for vulnerable groups. Runs the "Green Kurdistan" olive and oak programs.',
      real: true),
  'hasar': Org('Hasar Organization',
      'Erbil environmental group co-founded in 2019, working toward one million oak trees across the Kurdistan Region.',
      real: true),
  'gec': Org('Green Erbil Community', 'Neighborhood volunteers who plant and look after shade trees in Erbil parks.'),
  'citadel': Org('Citadel Neighbors Collective', 'Residents greening the streets around Erbil Citadel.'),
  'zagros': Org('Zagros Roots Network', 'Hikers and students reforesting the mountains north of Erbil.'),
  'ankawa': Org('Ankawa Youth Green Club', 'Students planting street trees in Ankawa.'),
};

class Campaign {
  final String id, title, place, area, date, time, orgId, blurb, species, image;
  final LatLng pos;
  final int goal;
  int planted, volunteers;
  Campaign({
    required this.id,
    required this.title,
    required this.place,
    required this.area,
    required this.date,
    required this.time,
    required this.orgId,
    required this.blurb,
    required this.species,
    required this.pos,
    required this.goal,
    required this.planted,
    required this.volunteers,
    this.image = 'assets/community.png',
  });
  Org get org => orgs[orgId]!;
  double get progress => (planted / goal).clamp(0, 1).toDouble();
}

final campaigns = <Campaign>[
  Campaign(
      id: 'GC',
      title: 'Greener roots for Erbil',
      place: 'Sami Abdulrahman Park',
      area: 'Erbil',
      date: 'Saturday, November 28',
      time: '9:00 AM–12:00 PM',
      orgId: 'gec',
      blurb:
          'Help us give 60 native trees a new home. Spend a morning outdoors with neighbors and leave something beautiful for generations to come.',
      species: 'Persian oak, pistachio, Oriental plane',
      pos: const LatLng(36.2005, 43.9775),
      goal: 60,
      planted: 22,
      volunteers: 28),
  Campaign(
      id: 'MO',
      title: 'Million Oaks: Kasnazan',
      place: 'Kasnazan forest',
      area: 'East of Erbil',
      date: 'Friday, December 4',
      time: '8:00 AM–1:00 PM',
      orgId: 'hasar',
      blurb:
          'Plant oak saplings on the hillsides of Kasnazan as part of the drive to plant a million oaks across the Kurdistan Region.',
      species: 'Persian oak (Quercus brantii)',
      pos: const LatLng(36.2330, 44.1250),
      goal: 2000,
      planted: 1340,
      volunteers: 54,
      image: 'assets/oak.png'),
  Campaign(
      id: 'OL',
      title: 'Olive Legacy: Dilopa',
      place: 'Dilopa, Kasnazan',
      area: 'Erbil',
      date: 'Saturday, December 12',
      time: '9:00 AM–2:00 PM',
      orgId: 'rwanga',
      blurb:
          'Care day at the drought-resistant olive grove. Mulch, water and replace young olive trees that did not survive the summer.',
      species: 'Olive',
      pos: const LatLng(36.2480, 44.1080),
      goal: 500,
      planted: 310,
      volunteers: 41),
  Campaign(
      id: 'CR',
      title: 'Citadel green ring',
      place: 'Foot of Erbil Citadel',
      area: 'Erbil',
      date: 'Sunday, December 6',
      time: '7:30 AM–10:30 AM',
      orgId: 'citadel',
      blurb: 'Shade the walk around the Citadel with sissoo and elm trees, and water the ones planted in October.',
      species: 'Sissoo, elm',
      pos: const LatLng(36.1912, 44.0092),
      goal: 120,
      planted: 64,
      volunteers: 19),
  Campaign(
      id: 'SH',
      title: 'Winter roots at Shanidar',
      place: 'Shanidar valley',
      area: 'Barzan, Erbil Governorate',
      date: 'Friday, December 18',
      time: '8:00 AM–3:00 PM',
      orgId: 'zagros',
      blurb: 'Restore native shade near Shanidar. Join neighbors for a day of planting, learning and connection.',
      species: 'Persian oak, wild pistachio, almond',
      pos: const LatLng(36.8336, 44.2203),
      goal: 300,
      planted: 45,
      volunteers: 12,
      image: 'assets/oak.png'),
  Campaign(
      id: 'AK',
      title: 'Ankawa street trees',
      place: 'Ankawa main street',
      area: 'Erbil',
      date: 'Saturday, December 19',
      time: '9:00 AM–12:00 PM',
      orgId: 'ankawa',
      blurb: 'Line the main street of Ankawa with young trees, and adopt one to water every week.',
      species: 'Ash, jujube, pomegranate',
      pos: const LatLng(36.2290, 43.9930),
      goal: 80,
      planted: 18,
      volunteers: 15),
];

class Tree {
  final String id, name, latin, campaign, planted;
  double height;
  String status;
  final List<String> updates;
  Tree(this.id, this.name, this.latin, this.campaign, this.planted, this.height, this.status, this.updates);
}

class CareTask {
  final String title, tree, when;
  final int day;
  bool done;
  CareTask(this.title, this.tree, this.when, this.day, {this.done = false});
}

class Note {
  final String title, body, time;
  bool read;
  Note(this.title, this.body, this.time, {this.read = false});
}

class Species {
  final String name, latin, why;
  final Set<String> soils, water;
  const Species(this.name, this.latin, this.why, this.soils, this.water);
}

const speciesDb = [
  Species('Persian oak', 'Quercus brantii', 'The native oak of the Zagros. Deep roots, very drought tolerant once established.',
      {'Rocky', 'Clay', 'Loam'}, {'Low', 'Medium'}),
  Species('Wild pistachio', 'Pistacia atlantica', 'Native to Kurdistan hillsides. Handles heat and poor soil.',
      {'Rocky', 'Clay'}, {'Low'}),
  Species('Olive', 'Olea europaea', 'Drought resistant and productive. Suits the Erbil plain.', {'Loam', 'Sandy'}, {'Low', 'Medium'}),
  Species('Oriental plane (chinar)', 'Platanus orientalis', 'Big shade tree for parks and streams. Needs regular water.',
      {'Loam', 'Clay'}, {'High'}),
  Species('Pomegranate', 'Punica granatum', 'Small fruit tree for gardens and courtyards.', {'Loam', 'Sandy', 'Clay'},
      {'Medium'}),
  Species("Christ's thorn jujube", 'Ziziphus spina-christi', 'Tough native for hot, dry sites.', {'Sandy', 'Rocky'}, {'Low'}),
  Species('Sissoo', 'Dalbergia sissoo', 'Fast-growing street tree used along Erbil roads.', {'Loam', 'Sandy'},
      {'Medium', 'High'}),
];

class AppState extends ChangeNotifier {
  String name = 'Aland Shirzad';
  String email = 'aland.shirzad@example.com';
  String role = 'Volunteer';
  bool reminders = true;
  final registrations = <String>{};
  int seedlingsDonated = 0;

  final trees = <Tree>[
    Tree('GC-0184', 'Persian oak', 'Quercus brantii', 'Greener roots for Erbil', 'Mar 14, 2026', 1.2, 'Healthy & growing',
        ['Nov 2: New leaves, 1.2 m', 'Aug 10: Survived summer, 0.9 m', 'Mar 14: Planted, 0.5 m']),
    Tree('MO-0912', 'Wild pistachio', 'Pistacia atlantica', 'Million Oaks: Kasnazan', 'Apr 3, 2026', 0.7, 'Needs water',
        ['Oct 20: Dry soil, leaves curling', 'Apr 3: Planted, 0.4 m']),
    Tree('CR-0031', 'Sissoo', 'Dalbergia sissoo', 'Citadel green ring', 'Oct 7, 2026', 1.8, 'Healthy & growing',
        ['Oct 7: Planted, 1.8 m']),
  ];

  final tasks = <CareTask>[
    CareTask('Water the young pistachios', 'MO-0912', 'Today · Mon, Nov 23', 23),
    CareTask('Check mulch around the oak', 'GC-0184', 'Wed, Nov 25', 25),
    CareTask('Water the sissoo', 'CR-0031', 'Thu, Nov 26', 26),
    CareTask('Log a growth photo', 'GC-0184', 'Sat, Nov 28', 28),
  ];

  final notes = <Note>[
    Note('Planting day this Saturday', 'Greener roots for Erbil starts 9:00 AM at Sami Abdulrahman Park, main gate.', '2h ago'),
    Note('Your pistachio needs water', 'No rain in Kasnazan for 12 days. Water MO-0912 today.', '5h ago'),
    Note('Rwanga Foundation posted an update', 'Olive Legacy care day added for Dec 12 in Dilopa.', 'Yesterday', read: true),
    Note('Badge earned: First roots', 'You planted your first tree with PlantIt.', 'Mar 14', read: true),
  ];

  int get unread => notes.where((n) => !n.read).length;

  void touch() => notifyListeners();

  void register(String id) {
    if (registrations.add(id)) campaigns.firstWhere((c) => c.id == id).volunteers++;
    notifyListeners();
  }

  void donate(String campaignId, int qty) {
    seedlingsDonated += qty;
    notifyListeners();
  }

  void addCampaign(Campaign c) {
    campaigns.insert(0, c);
    notifyListeners();
  }
}

final app = AppState();
