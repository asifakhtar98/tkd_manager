---
name: flutter-custompaint
description: >
  Expert guidance for Flutter's CustomPaint widget and CustomPainter API. Use this skill
  whenever the user asks about custom drawing, canvas operations, painting, or graphics in
  Flutter — including shapes, gradients, paths, animations, or any use of Canvas, CustomPaint,
  or CustomPainter. Trigger this skill for requests like "draw a chart", "custom shape",
  "paint on canvas", "custom widget with drawing", "clipPath", "gradient shape", or any
  Flutter UI that requires 2D rendering beyond standard widgets.
---

# Flutter CustomPaint Skill

Use this skill to produce correct, idiomatic, and performant Flutter code that uses `CustomPaint` and `CustomPainter`.

---

## Core Concepts

### CustomPaint Widget

`CustomPaint` is the Flutter widget that provides a `Canvas` to draw on during the paint phase.

```dart
CustomPaint(
  painter: MyPainter(),          // paints BEHIND child
  foregroundPainter: MyFgPainter(), // paints IN FRONT of child
  size: const Size(200, 200),    // used only when there is no child
  isComplex: false,              // hint to enable raster caching
  willChange: false,             // hint that painting will change next frame
  child: ...,                   // optional child widget
)
```

**Paint order**: `painter` → `child` → `foregroundPainter`

**Sizing rules**:
- With a child: sized to the child
- Without a child: uses `size` property (defaults to `Size.zero`; parent may override via constraints)
- Wrap with `ClipRect` to enforce bounds if painters draw outside their area

### CustomPainter Class

Subclass `CustomPainter` and override two methods:

```dart
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // All drawing happens here
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    // Return true only if visual output changed
    return false;
  }
}
```

**Repaint listeners**: Pass a `Listenable` (e.g. `AnimationController`) to `super()` to auto-repaint:

```dart
class MyPainter extends CustomPainter {
  MyPainter(this.animation) : super(repaint: animation);
  final Animation<double> animation;
  ...
}
```

---

## Canvas API Quick Reference

### Paint object

```dart
final paint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke  // or .fill
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4) // shadow/glow
  ..shader = gradient.createShader(rect); // gradient fill
```

### Drawing primitives

```dart
// Shapes
canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)), paint);
canvas.drawCircle(Offset(cx, cy), radius, paint);
canvas.drawOval(rect, paint);
canvas.drawLine(Offset(x1,y1), Offset(x2,y2), paint);
canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

// Path (complex shapes)
final path = Path()
  ..moveTo(x, y)
  ..lineTo(x2, y2)
  ..quadraticBezierTo(cpX, cpY, x3, y3)
  ..cubicTo(cp1X, cp1Y, cp2X, cp2Y, x4, y4)
  ..arcToPoint(Offset(x5, y5), radius: Radius.circular(r))
  ..close();
canvas.drawPath(path, paint);

// Image & text
canvas.drawImage(image, offset, paint);
canvas.drawParagraph(paragraph, offset); // use dart:ui TextPainter for text
```

### Transforms & clipping

```dart
canvas.save();
canvas.translate(dx, dy);
canvas.rotate(angleInRadians);
canvas.scale(sx, sy);
canvas.skewX(sx); canvas.skewY(sy);
canvas.clipRect(rect);
canvas.clipPath(path);
canvas.restore();
```

### Gradients

```dart
final gradient = LinearGradient(
  colors: [Colors.red, Colors.blue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
).createShader(rect);

final radial = RadialGradient(
  colors: [Colors.white, Colors.black],
  center: Alignment.center,
  radius: 0.5,
).createShader(rect);

paint.shader = gradient;
```

---

## Common Patterns

### 1. Static custom shape

```dart
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    final path = _buildStarPath(size);
    canvas.drawPath(path, paint);
  }

  Path _buildStarPath(Size size) {
    // Build path using size.width / size.height
    ...
  }

  @override
  bool shouldRepaint(StarPainter old) => false;
}
```

### 2. Animated painter

```dart
class WavePainter extends CustomPainter {
  WavePainter({required this.animation}) : super(repaint: animation);
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    final path = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + sin((x / size.width * 2 * pi) + t * 2 * pi) * 20;
      x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, Paint()..color = Colors.blue..strokeWidth = 2..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(WavePainter old) => animation != old.animation;
}

// Usage in State:
late AnimationController _controller;
@override
void initState() {
  super.initState();
  _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
}

// In build:
CustomPaint(painter: WavePainter(animation: _controller), size: const Size(double.infinity, 100));
```

### 3. Layered animation (multiple controllers)

Think in layers — complex visuals are built from simple, stacked components. Use multiple `AnimationController`s and combine them with a `Listenable.merge`:

```dart
class LayeredAnimationPainter extends CustomPainter {
  LayeredAnimationPainter({
    required this.primaryAnimation,
    required this.secondaryAnimation,
    required this.tertiaryAnimation,
  }) : super(repaint: Listenable.merge([primaryAnimation, secondaryAnimation, tertiaryAnimation]));

  final Animation<double> primaryAnimation;
  final Animation<double> secondaryAnimation;
  final Animation<double> tertiaryAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Layer 1: rotating background rings
    _drawRotatingRings(canvas, center, primaryAnimation.value);
    // Layer 2: pulsing center circle
    _drawPulsingCenter(canvas, center, secondaryAnimation.value);
    // Layer 3: orbiting satellites
    _drawOrbitingSatellites(canvas, center, tertiaryAnimation.value);
  }

  void _drawRotatingRings(Canvas canvas, Offset center, double t) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      final radius = 80.0 + (i * 30);
      canvas.drawCircle(center, radius, paint..color = Colors.blue.withOpacity(0.3 + i * 0.2));
    }
  }

  void _drawPulsingCenter(Canvas canvas, Offset center, double t) {
    final radius = 20 + t * 10;
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
  }

  void _drawOrbitingSatellites(Canvas canvas, Offset center, double t) {
    for (int i = 0; i < 4; i++) {
      final angle = t * 2 * pi + (i * pi / 2);
      final pos = center + Offset(cos(angle), sin(angle)) * 60;
      canvas.drawCircle(pos, 8, Paint()..color = Colors.orange);
    }
  }

  @override
  bool shouldRepaint(LayeredAnimationPainter old) => false; // repaint driven by Listenable.merge
}

// In State:
late AnimationController _primary, _secondary, _tertiary;
@override
void initState() {
  super.initState();
  _primary = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  _secondary = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
    ..repeat(reverse: true);
  _tertiary = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
}
```

### 4. Painter with data (shouldRepaint matters)

```dart
class BarChartPainter extends CustomPainter {
  BarChartPainter({required this.values, required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / values.length;
    final maxVal = values.reduce(max);
    for (int i = 0; i < values.length; i++) {
      final barHeight = (values[i] / maxVal) * size.height;
      canvas.drawRect(
        Rect.fromLTWH(i * barWidth, size.height - barHeight, barWidth - 2, barHeight),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) =>
      old.values != values || old.color != color;
}
```

---

## Performance Best Practices

| Concern                       | Guidance                                                                                 |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| `shouldRepaint`               | Return `false` for static painters; compare fields for data-driven painters              |
| `isComplex: true`             | Set when painting is expensive and doesn't change often (enables raster cache)           |
| `willChange: true`            | Set on animated painters so raster cache is NOT used (avoids wasted work)                |
| Avoid allocation in `paint()` | Cache `Paint`, `Path`, `TextPainter` as instance fields; recreate only when data changes |
| `repaint` Listenable          | Always pass `AnimationController` to `super(repaint: ...)` for animations                |
| Clip overflow                 | Wrap with `ClipRect` if painting extends beyond widget bounds                            |

---

## Text on Canvas

```dart
import 'dart:ui' as ui;

void _drawText(Canvas canvas, String text, Offset offset) {
  final paragraphBuilder = ui.ParagraphBuilder(
    ui.ParagraphStyle(fontSize: 16, textAlign: TextAlign.left),
  )
    ..pushStyle(ui.TextStyle(color: Colors.black))
    ..addText(text);
  final paragraph = paragraphBuilder.build()
    ..layout(const ui.ParagraphConstraints(width: 200));
  canvas.drawParagraph(paragraph, offset);
}
```

Or use `TextPainter` (simpler for single-line):

```dart
final tp = TextPainter(
  text: TextSpan(text: 'Hello', style: TextStyle(color: Colors.black, fontSize: 16)),
  textDirection: TextDirection.ltr,
)..layout(maxWidth: 200);
tp.paint(canvas, Offset(x, y));
```

---

## Interactivity & Accessibility

### hitTest — make drawn shapes tappable

By default, `CustomPainter` ignores taps. Override `hitTest` to handle touch on specific drawn regions:

```dart
class TappableCirclePainter extends CustomPainter {
  TappableCirclePainter({required this.center, required this.radius});
  final Offset center;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.blue);
  }

  @override
  bool hitTest(Offset position) {
    // Return true if tap is within the circle
    return (position - center).distance <= radius;
  }

  @override
  bool shouldRepaint(TappableCirclePainter old) =>
      old.center != center || old.radius != radius;
}

// Wrap with GestureDetector as usual; hitTest determines if taps register.
GestureDetector(
  onTapDown: (details) => _handleTap(details.localPosition),
  child: CustomPaint(painter: TappableCirclePainter(center: Offset(100, 100), radius: 40)),
)
```

### semanticsBuilder — screen reader support

```dart
@override
SemanticsBuilderCallback get semanticsBuilder {
  return (Size size) => [
    CustomPainterSemantics(
      rect: Offset.zero & size,
      properties: const SemanticsProperties(
        label: 'Progress ring at 75 percent',
        value: '75%',
      ),
    ),
  ];
}
```

---

## Advanced Performance

### RepaintBoundary — isolate expensive painters

Wrap `CustomPaint` in a `RepaintBoundary` to prevent it from triggering repaints in the surrounding widget tree:

```dart
RepaintBoundary(
  child: CustomPaint(
    painter: ExpensiveBackgroundPainter(),
    isComplex: true,
  ),
)
```

### PictureRecorder — cache a static painting

For complex static graphics, record once and replay:

```dart
class CachedPainter extends CustomPainter {
  ui.Picture? _cache;

  ui.Picture _buildPicture(Size size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    // ... expensive drawing ...
    return recorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _cache ??= _buildPicture(size);
    canvas.drawPicture(_cache!);
  }

  @override
  bool shouldRepaint(CachedPainter old) => false;
}
```

### Path metrics — animate along a path

```dart
void _drawProgress(Canvas canvas, Path fullPath, double progress) {
  final metrics = fullPath.computeMetrics();
  for (final metric in metrics) {
    final length = metric.length * progress;
    final extracted = metric.extractPath(0, length);
    canvas.drawPath(extracted, Paint()..color = Colors.green..strokeWidth = 3..style = PaintingStyle.stroke);
  }
}
```

### Performance summary table

| Concern                       | Guidance                                                                           |
| ----------------------------- | ---------------------------------------------------------------------------------- |
| `shouldRepaint`               | Return `false` for static painters; compare fields for data-driven painters        |
| `isComplex: true`             | Set when painting is expensive and rarely changes (enables raster cache)           |
| `willChange: true`            | Set on animated painters so raster cache is NOT used                               |
| Avoid allocation in `paint()` | Cache `Paint`, `Path`, `TextPainter` as instance fields                            |
| `repaint` Listenable          | Always pass `AnimationController` (or `Listenable.merge`) to `super(repaint: ...)` |
| `RepaintBoundary`             | Isolate custom paint from the rest of the widget tree                              |
| `PictureRecorder`             | Cache static paintings that are expensive to compute                               |
| Clip overflow                 | Wrap with `ClipRect` if painting extends beyond widget bounds                      |
| Profile                       | Use Flutter DevTools (Timeline / Flutter Inspector) to target 60 fps               |

---

## Checklist

Before finalizing generated code:
- [ ] `CustomPainter` subclass overrides both `paint` and `shouldRepaint`
- [ ] Animated painters pass `repaint:` (single controller or `Listenable.merge`) to `super()`
- [ ] Multi-animation painters use `Listenable.merge([ctrl1, ctrl2, ...])` for `repaint`
- [ ] `shouldRepaint` compares all fields that affect rendering
- [ ] `isComplex` / `willChange` set appropriately for the use case
- [ ] Paints and Paths are created outside `paint()` when possible
- [ ] Widget has explicit `size` or a `child` to drive layout
- [ ] `hitTest` overridden if drawn shapes need to respond to taps
- [ ] `semanticsBuilder` provided for charts, progress indicators, or meaningful custom graphics
- [ ] `RepaintBoundary` added around expensive static or infrequently updated painters
- [ ] Complex static painters use `PictureRecorder` caching pattern
- [ ] Imports: `package:flutter/material.dart` (and `dart:ui as ui` for low-level APIs, `dart:math` for trig)