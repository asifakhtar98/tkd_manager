# PDF Conformance Reference

## Creating Conformance Documents

### PDF/A-1B

```dart
// Create PDF/A-1B conformant document
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// Add content
document.pages.add().graphics.drawString(
  'PDF/A-1B Document',
  PdfStandardFont(PdfFontFamily.helvetica, 12)
);

// Set document info for conformance
document.documentInformation.title = 'Document Title';
document.documentInformation.creator = 'Application Name';

File('conformance_a1b.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### PDF/A-2B

```dart
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a2b
);

document.pages.add().graphics.drawString(
  'PDF/A-2B Document',
  PdfStandardFont(PdfFontFamily.helvetica, 12)
);

File('conformance_a2b.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### PDF/A-3B

```dart
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a3b
);

document.pages.add().graphics.drawString(
  'PDF/A-3B Document',
  PdfStandardFont(PdfFontFamily.helvetica, 12)
);

// Can embed files (PDF/A-3 allows attachments)
final PdfAttachment attachment = PdfAttachment(
  'data.xml',
  File('data.xml').readAsBytesSync(),
  description: 'XML Data',
  mimeType: 'application/xml'
);
document.attachments.add(attachment);

File('conformance_a3b.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Conformance Levels

```dart
// Available conformance levels
PdfConformanceLevel.none       // No conformance (default)
PdfConformanceLevel.a1b       // PDF/A-1B
PdfConformanceLevel.a2b       // PDF/A-2B
PdfConformanceLevel.a3b       // PDF/A-3B
```

## PDF/A Requirements

### Font Embedding

```dart
// Standard fonts are automatically embedded
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// TrueType fonts must be embedded as subset for PDF/A
final Uint8List fontData = File('Roboto-Regular.ttf').readAsBytesSync();
final PdfFont font = PdfTrueTypeFont(fontData, 12, subset: true);

document.pages.add().graphics.drawString(
  'Custom Font',
  font
);
```

### Color Spaces

```dart
// Use appropriate color spaces for PDF/A
// RGB is allowed
page.graphics.drawRectangle(
  PdfSolidBrush(PdfColor(255, 0, 0)),
  const Rect.fromLTWH(0, 0, 100, 50)
);

// Grayscale
page.graphics.drawRectangle(
  PdfSolidBrush(PdfColor.fromGray(128)),
  const Rect.fromLTWH(110, 0, 100, 50)
);

// CMYK
page.graphics.drawRectangle(
  PdfSolidBrush(PdfColor.fromCMYK(0, 100, 100, 0)),
  const Rect.fromLTWH(220, 0, 100, 50)
);
```

### Metadata Requirements

```dart
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// Required metadata for PDF/A
document.documentInformation.title = 'Document Title';
document.documentInformation.creator = 'Application Name';
document.documentInformation.subject = 'Subject Description';
document.documentInformation.keywords = 'keyword1, keyword2';

// Optional but recommended
document.documentInformation.author = 'Author Name';
document.documentInformation.producer = 'Producer Name';
document.documentInformation.creationDate = DateTime.now();
document.documentInformation.modificationDate = DateTime.now();
```

### Encryption Restrictions

```dart
// PDF/A does not allow encryption
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// This will NOT work - encryption is not allowed
// document.security.userPassword = 'password';  // Don't do this!

// For PDF/A-3B, you can use encryption with specific rules
// But generally avoid encryption for PDF/A
```

## Verify Conformance

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('document.pdf').readAsBytesSync()
);

// Check conformance level
print('Conformance: ${document.conformanceLevel}');

// If document was loaded from PDF/A
// and you want to save as PDF/A
document.conformanceLevel = PdfConformanceLevel.a1b;
```

## Converting Existing PDF

```dart
// Load existing PDF
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Set conformance level
document.conformanceLevel = PdfConformanceLevel.a1b;

// Ensure required metadata
document.documentInformation.title = 'Converted Document';
document.documentInformation.creator = 'Conversion Tool';

// Ensure fonts are embedded
// (If using external fonts, re-create with subsetting)

// Save as PDF/A
File('output_a1b.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## PDF/A Specific Features

### Output Intent

```dart
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// Set output intent (color profile)
document.outputIntent = PdfOutputIntent(
  subtype: 'GTS_PDFA1',
  destOutputProfile: File('sRGB.icc').readAsBytesSync(),
  identifier: 'sRGB'
);
```

### Tagged PDF

```dart
// PDF/A requires tagged PDF structure
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// Tagged PDF is automatically enabled for PDF/A
// Structure tree can be accessed via document.tagStructure
```

### XMP Metadata

```dart
// Add XMP metadata
final PdfDocument document = PdfDocument(
  conformanceLevel: PdfConformanceLevel.a1b
);

// XMP is automatically generated for PDF/A
// Can access via document.xmpMetadata
print('XMP present: ${document.xmpMetadata != null}');
```