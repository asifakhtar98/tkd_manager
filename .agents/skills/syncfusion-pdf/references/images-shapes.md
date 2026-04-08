# Images and Shapes Reference

## Images

### Loading Images

```dart
// Load JPEG or PNG from file
final Uint8List imageData = File('image.png').readAsBytesSync();
final PdfBitmap image = PdfBitmap(imageData);

// Load JPEG from file
final PdfBitmap jpegImage = PdfBitmap(File('photo.jpg').readAsBytesSync());
```

### Drawing Images

```dart
final PdfPage page = document.pages.add();

// Draw image with size
page.graphics.drawImage(
  image,
  const Rect.fromLTWH(0, 0, 200, 150)
);

// Draw image maintaining aspect ratio
final double aspectRatio = image.width / image.height;
final double drawWidth = 200;
final double drawHeight = drawWidth / aspectRatio;

page.graphics.drawImage(
  image,
  Rect.fromLTWH(0, 0, drawWidth, drawHeight)
);

// Draw with transparency
page.graphics.drawImage(
  image,
  Rect.fromLTWH(100, 0, 200, 150),
  opacity: 0.7
);
```

### Image Properties

```dart
// Get image dimensions
print('Width: ${image.width}');
print('Height: ${image.height}');

// Get image format
// image.imageFormat
```

## Shapes

### Lines

```dart
final PdfGraphics graphics = page.graphics;

// Simple line
graphics.drawLine(
  PdfPen(PdfColor(0, 0, 0)),
  const Offset(0, 0),
  const Offset(100, 100)
);

// Line with width and dash
final PdfPen linePen = PdfPen(
  PdfColor(255, 0, 0),
  strokeWidth: 2
);
linePen.dashStyle = PdfDashStyle.dash;

graphics.drawLine(
  linePen,
  const Offset(0, 0),
  const Offset(200, 0)
);

// Multiple lines (polygon)
final List<Offset> points = [
  const Offset(0, 0),
  const Offset(100, 0),
  const Offset(100, 100),
  const Offset(0, 100)
];
graphics.drawPolygon(
  PdfPen(PdfColor(0, 0, 0)),
  points
);
```

### Rectangles

```dart
// Filled rectangle
graphics.drawRectangle(
  PdfBrushes.red,
  const Rect.fromLTWH(0, 0, 100, 50)
);

// Rectangle with border
final PdfPen rectPen = PdfPen(PdfColor(0, 0, 0), strokeWidth: 1);
graphics.drawRectangle(
  rectPen,
  PdfBrushes.blue,
  const Rect.fromLTWH(0, 60, 100, 50)
);

// Rounded rectangle
graphics.drawRoundedRectangle(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.green,
  const Rect.fromLTWH(0, 120, 100, 50),
  cornerRadius: 10
);
```

### Ellipses and Circles

```dart
// Ellipse
graphics.drawEllipse(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.yellow,
  const Rect.fromLTWH(0, 0, 100, 50)
);

// Circle (ellipse with equal dimensions)
graphics.drawEllipse(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.orange,
  const Rect.fromLTWH(0, 70, 50, 50)
);

// Filled ellipse without border
graphics.drawEllipse(
  PdfSolidBrush(PdfColor(0, 255, 0)),
  const Rect.fromLTWH(70, 70, 50, 50)
);
```

### Arcs

```dart
// Draw arc
graphics.drawArc(
  PdfPen(PdfColor(0, 0, 0)),
  const Rect.fromLTWH(0, 0, 100, 100),
  0,
  180  // Start and sweep angle in degrees
);

// Arc from point
graphics.drawArc(
  PdfPen(PdfColor(255, 0, 0)),
  Rect.fromLTWH(0, 0, 100, 50),
  startAngle: 45,
  sweepAngle: 90
);
```

### Bezier Curves

```dart
// Cubic Bezier curve
graphics.drawBezier(
  PdfPen(PdfColor(0, 0, 0)),
  const Offset(0, 0),    // Start point
  const Offset(30, 50),   // Control point 1
  const Offset(70, 50),  // Control point 2
  const Offset(100, 0)   // End point
);

// Multiple Bezier curves
final PdfBezierCurve curve = PdfBezierCurve(
  const Offset(0, 0),
  const Offset(30, 50),
  const Offset(70, 50),
  const Offset(100, 0)
);
graphics.drawBezierCurve(PdfPen(PdfColor(0, 0, 0)), curve);
```

### Pie Shapes

```dart
// Pie slice
graphics.drawPie(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.orange,
  const Rect.fromLTWH(0, 0, 100, 100),
  0,
  90  // Start and sweep angles
);

// Pie with specific angles
graphics.drawPie(
  PdfPen(PdfColor(255, 0, 0)),
  PdfSolidBrush(PdfColor(255, 200, 0)),
  const Rect.fromLTWH(120, 0, 100, 100),
  startAngle: 45,
  sweepAngle: 120
);
```

## Colors

### PdfColor

```dart
// RGB color
final PdfColor color = PdfColor(255, 0, 0);  // Red

// CMYK color
final PdfColor cmykColor = PdfColor.fromCMYK(0, 100, 100, 0);  // Red

// Grayscale
final PdfColor grayColor = PdfColor.fromGray(128);

// Transparent color
final PdfColor transparentColor = PdfColor(255, 0, 0, alpha: 128);

// HSV color
final PdfColor hsvColor = PdfColor.fromHSV(0, 100, 100);
```

### PdfBrushes

```dart
// Standard color brushes
PdfBrushes.black
PdfBrushes.white
PdfBrushes.red
PdfBrushes.green
PdfBrushes.blue
PdfBrushes.yellow
PdfBrushes.cyan
PdfBrushes.magenta
PdfBrushes.gray

// Custom brush
final PdfBrush customBrush = PdfSolidBrush(PdfColor(100, 150, 200));
```

## Pens

```dart
// Simple pen
final PdfPen pen = PdfPen(PdfColor(0, 0, 0));

// Pen with stroke width
final PdfPen thickPen = PdfPen(PdfColor(0, 0, 0), strokeWidth: 3);

// Dash styles
final PdfPen dashedPen = PdfPen(PdfColor(0, 0, 0));
dashedPen.dashStyle = PdfDashStyle.dash;
dashedPen.dashPattern = [5, 3];  // Custom dash pattern

// Available dash styles
// PdfDashStyle.solid
// PdfDashStyle.dash
// PdfDashStyle.dot
// PdfDashStyle.dashDot
// PdfDashStyle.dashDotDot
// PdfDashStyle.custom

// Line cap style
dashedPen.lineCap = PdfLineCap.round;

// Line join style
dashedPen.lineJoin = PdfLineJoin.round;
```

## Graphics State

```dart
final PdfGraphics graphics = page.graphics;

// Save current state
graphics.save();

// Translate origin
graphics.translateTransform(50, 100);

// Rotate
graphics.rotateTransform(45);

// Scale
graphics.scaleTransform(1.5, 1.0);

// Restore to saved state
graphics.restore();

// Set clipping region
graphics.setClip(Rect.fromLTWH(0, 0, 100, 100));

// Clear clipping
graphics.clearClip();
```

## Transparency

```dart
// Set opacity for brush
final PdfBrush semiTransparentBrush = PdfSolidBrush(
  PdfColor(255, 0, 0)
);
semiTransparentBrush.opacity = 0.5;

// Set opacity for pen
final PdfPen transparentPen = PdfPen(PdfColor(0, 0, 0));
transparentPen.opacity = 0.7;

// Set transparency for entire graphics
graphics.setTransparency(0.8);
```

## Gradient Brushes

```dart
// Linear gradient
final PdfLinearGradientBrush gradientBrush = PdfLinearGradientBrush(
  const Offset(0, 0),
  const Offset(100, 0),
  PdfColor(0, 0, 255),
  PdfColor(255, 0, 0)
);

// Linear gradient with angle
final PdfLinearGradientBrush angleGradient = PdfLinearGradientBrush(
  const Offset(0, 0),
  const Offset(100, 100),
  [PdfColor(0, 0, 255), PdfColor(0, 255, 0), PdfColor(255, 0, 0)]
);

// Radial gradient
final PdfRadialGradientBrush radialBrush = PdfRadialGradientBrush(
  const Offset(50, 50),  // Center
  50,  // Radius
  PdfColor(255, 255, 0),
  PdfColor(255, 0, 0)
);

graphics.drawRectangle(
  gradientBrush,
  const Rect.fromLTWH(0, 0, 100, 100)
);
```

## Pattern Brushes

```dart
// Image pattern (tiled image)
final PdfImagePattern imagePattern = PdfImagePattern(
  PdfBitmap(File('pattern.png').readAsBytesSync()),
  PdfBrushStyle.tiled,
  const Size(20, 20)
);

// Set pattern transformation
imagePattern.setTransformationMatrix([1, 0, 0, 1, 0, 0]);

graphics.drawRectangle(
  PdfBrush(imagePattern),
  const Rect.fromLTWH(0, 0, 200, 100)
);
```