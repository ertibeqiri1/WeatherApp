// Run with: dart run tool/generate_icon.dart
// Generates app_icon.png and app_icon_foreground.png in assets/icon/

import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  _generateFullIcon();
  _generateForegroundIcon();
  // ignore: avoid_print
  print('Icons generated in assets/icon/');
}

/// Full icon — blue gradient background + cloud + sun (used for iOS & fallback)
void _generateFullIcon() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  // Blue gradient background (top → bottom)
  for (int y = 0; y < size; y++) {
    final t = y / size;
    final r = _lerp(0x5B, 0x1E, t).toInt();
    final g = _lerp(0xA3, 0x57, t).toInt();
    final b = _lerp(0xD9, 0x99, t).toInt();
    for (int x = 0; x < size; x++) {
      image.setPixelRgb(x, y, r, g, b);
    }
  }

  _drawSun(image, cx: 680, cy: 340, radius: 170);
  _drawCloud(image, cx: 470, cy: 530, scale: 1.0);

  File('assets/icon/app_icon.png').writeAsBytesSync(img.encodePng(image));
}

/// Foreground icon — transparent background, white cloud + sun (Android adaptive)
void _generateForegroundIcon() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  // Fully transparent background
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  _drawSun(image, cx: 620, cy: 380, radius: 150, color: img.ColorRgba8(255, 220, 80, 255));
  _drawCloud(image, cx: 470, cy: 560, scale: 0.9, color: img.ColorRgba8(255, 255, 255, 255));

  File('assets/icon/app_icon_foreground.png')
      .writeAsBytesSync(img.encodePng(image));
}

void _drawSun(
  img.Image image, {
  required int cx,
  required int cy,
  required int radius,
  img.Color? color,
}) {
  final c = color ?? img.ColorRgba8(255, 220, 80, 255);
  img.fillCircle(image, x: cx, y: cy, radius: radius, color: c);
}

void _drawCloud(
  img.Image image, {
  required int cx,
  required int cy,
  required double scale,
  img.Color? color,
}) {
  final c = color ?? img.ColorRgba8(255, 255, 255, 230);

  // Cloud body — several overlapping circles
  final circles = [
    (cx, cy, (130 * scale).toInt()),
    (cx - (130 * scale).toInt(), cy + (30 * scale).toInt(), (100 * scale).toInt()),
    (cx + (140 * scale).toInt(), cy + (20 * scale).toInt(), (110 * scale).toInt()),
    (cx + (50 * scale).toInt(), cy - (60 * scale).toInt(), (110 * scale).toInt()),
    (cx - (50 * scale).toInt(), cy - (40 * scale).toInt(), (100 * scale).toInt()),
  ];

  for (final (x, y, r) in circles) {
    img.fillCircle(image, x: x, y: y, radius: r, color: c);
  }

  // Fill bottom rectangle to flatten base of cloud
  final baseY = cy + (60 * scale).toInt();
  final left  = cx - (230 * scale).toInt();
  final right = cx + (250 * scale).toInt();
  img.fillRect(image,
    x1: left, y1: cy, x2: right, y2: baseY + 40, color: c);
}

double _lerp(num a, num b, double t) => a + (b - a) * t;
