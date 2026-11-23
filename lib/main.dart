import 'package:flutter/material.dart';
import 'data.dart';
import 'ui.dart';
import 'explore.dart';
import 'trees.dart';
import 'more.dart';

void main() => runApp(const PlantIt());

class PlantIt extends StatelessWidget {
  const PlantIt({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'PlantIt',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        // Show as a phone on wide screens (laptop demo), full screen on phones.
        builder: (context, child) => LayoutBuilder(
          builder: (context, c) => c.maxWidth <= 500
              ? child!
              : ColoredBox(
                  color: const Color(0xFF1B1F1C),
                  child: Center(
                    child: Container(
                      width: 390,
                      height: c.maxHeight.clamp(0, 844).toDouble(),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
                      child: child,
                    ),
                  ),
                ),
        ),
        home: const WelcomeScreen(),
      );
}

class Logo extends StatelessWidget {
  final Color color;
  const Logo({super.key, this.color = C.ink});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.eco_outlined, size: 20, color: color == C.ink ? C.green2 : color),
        const SizedBox(width: 8),
        Text('PlantIt', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: color)),
      ]);
}

// ---------- Welcome / onboarding ----------
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int page = 0;
  static const slides = [
    ('assets/community.png', 'Put down roots.\nLift up a community.',
        'Join neighbors across Erbil and the Kurdistan Region to plant native trees.'),
    ('assets/oak.png', 'Every tree has\na story.', 'Follow the trees you planted, log their growth, and get care reminders.'),
    ('assets/community.png', 'Give what\nyou can.', 'Volunteer a morning, donate seedlings, or run a campaign for your organization.'),
  ];
  @override
  Widget build(BuildContext context) {
    final s = slides[page];
    return Scaffold(
      backgroundColor: C.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Logo(color: Colors.white),
            const SizedBox(height: 28),
            Photo(s.$1, h: 300),
            const SizedBox(height: 28),
            Text('TOGETHER, WE GROW', style: eyebrow.copyWith(color: const Color(0xFFB9D3B4))),
            gapS,
            Text(s.$2, style: h1(Colors.white).copyWith(fontSize: 30)),
            const SizedBox(height: 12),
            Text(s.$3, style: body.copyWith(color: const Color(0xFFD5E0D2), fontSize: 14)),
            const Spacer(),
            Row(
                children: List.generate(
                    3,
                    (i) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: i == page ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: i == page ? Colors.white : Colors.white30, borderRadius: BorderRadius.circular(4))))),
            gap,
            SizedBox(
                width: double.infinity,
                child: Btn(page < 2 ? 'Next' : 'Get started',
                    icon: Icons.arrow_forward,
                    onTap: () => page < 2
                        ? setState(() => page++)
                        : Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())))),
            Center(
              child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text('I already have an account · Log in', style: TextStyle(color: Colors.white))),
            ),
          ]),
        ),
      ),
    );
  }
}

void enterApp(BuildContext context) =>
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const Shell()), (_) => false);

// ---------- Login ----------
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Body([
            const Logo(),
            const SizedBox(height: 24),
            Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome back.', style: h1()),
              gapS,
              const Text('Log in to see your trees and campaigns.', style: body),
              gap,
              Field('Email address', 'you@example.com', ctrl: TextEditingController(text: app.email)),
              Field('Password', 'Your password', ctrl: TextEditingController(text: 'demo1234'), obscure: true),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => toast(context, 'Reset link sent to ${app.email}'),
                      child: const Text('Forgot password?', style: TextStyle(color: C.green2, fontSize: 12)))),
              SizedBox(width: double.infinity, child: Btn('Log in', onTap: () => enterApp(context))),
              gap,
              Center(
                child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: const Text('New here? Create an account →', style: TextStyle(color: C.green2, fontSize: 12))),
              ),
            ])),
          ]),
        ),
      );
}

// ---------- Create account ----------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String role = 'Volunteer';
  bool agree = true;
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget roleBox(String r, String sub) => Expanded(
          child: GestureDetector(
            onTap: () => setState(() => role = r),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: role == r ? C.tint : Colors.white,
                  border: Border.all(color: role == r ? C.green2 : C.line),
                  borderRadius: BorderRadius.circular(6)),
              child: Column(children: [
                Text(r, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.green)),
                const SizedBox(height: 2),
                Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: C.muted)),
              ]),
            ),
          ),
        );
    return Scaffold(
      body: SafeArea(
        child: Body([
          const Logo(),
          const SizedBox(height: 20),
          Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Let's grow together.", style: h1()),
            gapS,
            const Text('Create your free PlantIt account.', style: body),
            gap,
            const Text("I'm joining as", style: label),
            gapS,
            Row(children: [
              roleBox('Volunteer', 'Plant & care'),
              roleBox('Donor', 'Give\nseedlings'),
              roleBox('Organization', 'Lead\ncampaigns'),
            ]),
            gap,
            Field('Full name', 'Your full name', ctrl: nameC),
            Field('Email address', 'you@example.com', ctrl: emailC),
            const Field('Password', 'Create a password · 8+ characters', obscure: true),
            Row(children: [
              Checkbox(value: agree, activeColor: C.green2, onChanged: (v) => setState(() => agree = v!)),
              const Expanded(child: Text('I agree to the Terms of Service and Privacy Policy.', style: TextStyle(fontSize: 11))),
            ]),
            gapS,
            SizedBox(
                width: double.infinity,
                child: Btn('Create account', onTap: () {
                  if (!agree) return toast(context, 'Please accept the terms first');
                  if (nameC.text.trim().isNotEmpty) app.name = nameC.text.trim();
                  if (emailC.text.trim().isNotEmpty) app.email = emailC.text.trim();
                  app.role = role;
                  enterApp(context);
                })),
            gapS,
            TextButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Already have an account? Log in →', style: TextStyle(color: C.green2, fontSize: 12))),
            const Text('Your details stay private. Your impact grows.', style: TextStyle(fontSize: 11, color: C.muted)),
          ])),
        ]),
      ),
    );
  }
}

// ---------- Main shell: header + 4 tabs, each with its own navigator ----------
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;
  final keys = List.generate(4, (_) => GlobalKey<NavigatorState>());
  final roots = const [ExploreScreen(), MyTreesScreen(), CareScreen(), ImpactScreen()];
  static const items = [
    (Icons.search, 'Explore'),
    (Icons.park_outlined, 'My trees'),
    (Icons.water_drop_outlined, 'Care'),
    (Icons.show_chart, 'Impact'),
  ];

  void push(Widget w) => keys[tab].currentState!.push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => keys[tab].currentState?.maybePop(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: C.line))),
              child: Row(children: [
                const Logo(),
                const Spacer(),
                ListenableBuilder(
                  listenable: app,
                  builder: (_, __) => IconButton(
                    onPressed: () => push(const NotificationsScreen()),
                    icon: Badge(
                        isLabelVisible: app.unread > 0,
                        label: Text('${app.unread}'),
                        backgroundColor: C.orange,
                        child: const Icon(Icons.notifications_none, size: 22)),
                  ),
                ),
                IconButton(onPressed: () => push(const ProfileScreen()), icon: const Icon(Icons.menu, size: 22)),
              ]),
            ),
            Expanded(
              child: IndexedStack(
                index: tab,
                children: List.generate(
                    4,
                    (i) => Navigator(
                        key: keys[i],
                        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => roots[i]))),
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: C.line))),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
          child: SafeArea(
            top: false,
            child: Row(
              children: List.generate(4, (i) {
                final on = i == tab;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => on ? keys[i].currentState!.popUntil((r) => r.isFirst) : setState(() => tab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(color: on ? C.tint : null, borderRadius: BorderRadius.circular(6)),
                      child: Column(children: [
                        Icon(items[i].$1, size: 20, color: C.ink),
                        const SizedBox(height: 2),
                        Text(items[i].$2, style: const TextStyle(fontSize: 10)),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
