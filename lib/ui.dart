import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const green = Color(0xFF1E4D36);
  static const green2 = Color(0xFF2C6A4A);
  static const tint = Color(0xFFE5ECDD);
  static const bg = Color(0xFFF5F3EA);
  static const card = Colors.white;
  static const orange = Color(0xFFC0501F);
  static const ink = Color(0xFF1C2620);
  static const muted = Color(0xFF6B7368);
  static const line = Color(0xFFE2E2D8);
}

ThemeData buildTheme() {
  final base = GoogleFonts.interTextTheme();
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: C.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: C.green, primary: C.green, secondary: C.orange, surface: C.bg),
    textTheme: base.apply(bodyColor: C.ink, displayColor: C.ink),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      hintStyle: const TextStyle(color: C.muted, fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.line)),
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.line)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.green2)),
    ),
  );
}

TextStyle h1([Color c = C.ink]) => TextStyle(fontSize: 26, height: 1.2, fontWeight: FontWeight.w500, color: c);
TextStyle h2([Color c = C.ink]) => TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: c);
const body = TextStyle(fontSize: 13, height: 1.45, color: C.muted);
const label = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: C.ink);
const eyebrow = TextStyle(fontSize: 10, letterSpacing: .6, fontWeight: FontWeight.w600, color: C.green2);

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool outline;
  final IconData? icon;
  const Btn(this.text, {super.key, this.onTap, this.outline = false, this.icon});
  @override
  Widget build(BuildContext context) {
    final child = Row(mainAxisSize: MainAxisSize.min, children: [
      Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: outline ? C.green : Colors.white)),
      if (icon != null) ...[const SizedBox(width: 6), Icon(icon, size: 16, color: outline ? C.green : Colors.white)],
    ]);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
    return SizedBox(
      height: 46,
      child: outline
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(shape: shape, side: const BorderSide(color: C.line), backgroundColor: Colors.white),
              child: child)
          : FilledButton(onPressed: onTap, style: FilledButton.styleFrom(backgroundColor: C.orange, shape: shape), child: child),
    );
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets pad;
  const Box({super.key, required this.child, this.color = C.card, this.pad = const EdgeInsets.all(20)});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: pad,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: child);
}

class Field extends StatelessWidget {
  final String title, hint;
  final TextEditingController? ctrl;
  final int lines;
  final bool obscure;
  const Field(this.title, this.hint, {super.key, this.ctrl, this.lines = 1, this.obscure = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: label),
          const SizedBox(height: 6),
          TextField(
              controller: ctrl,
              maxLines: lines,
              obscureText: obscure,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(hintText: hint)),
        ]),
      );
}

class Crumb extends StatelessWidget {
  final String text;
  const Crumb(this.text, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.maybePop(context),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(children: [
            const Icon(Icons.arrow_back, size: 14, color: C.green2),
            const SizedBox(width: 4),
            Flexible(child: Text(text, style: const TextStyle(fontSize: 11, color: C.green2))),
          ]),
        ),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;
  const Pill(this.text, {super.key, this.selected = false, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
              color: selected ? C.tint : Colors.white,
              border: Border.all(color: selected ? C.green2 : C.line),
              borderRadius: BorderRadius.circular(6)),
          child: Text(text, style: TextStyle(fontSize: 12, color: selected ? C.green : C.ink)),
        ),
      );
}

class Photo extends StatelessWidget {
  final String asset;
  final double h;
  const Photo(this.asset, {super.key, this.h = 180});
  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(asset, height: h, width: double.infinity, fit: BoxFit.cover));
}

class Dot extends StatelessWidget {
  final String text;
  final Color color;
  const Dot(this.text, {super.key, this.color = C.green2});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text.toUpperCase(), style: eyebrow.copyWith(color: color)),
      ]);
}

/// Scrollable page body with standard padding.
class Body extends StatelessWidget {
  final List<Widget> children;
  const Body(this.children, {super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: children);
}

void toast(BuildContext context, String msg) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg), backgroundColor: C.green, behavior: SnackBarBehavior.floating));

const gap = SizedBox(height: 16);
const gapS = SizedBox(height: 8);
