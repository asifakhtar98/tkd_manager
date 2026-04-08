# Document Creation Reference

## Creating a New PDF Document

```dart
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

void createPdf() async {
  final PdfDocument document = PdfDocument();
  
  final PdfPage page = document.pages.add();
  
  page.graphics.drawString(
    'Hello World!',
    PdfStandardFont(PdfFontFamily.helvetica, 12),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(0, 0, 150, 20)
  );
  
  final List<int> bytes = await document.save();
  File('output.pdf').writeAsBytesSync(bytes);
  document.dispose();
}
```

## Page Management

```dart
// Add a new page
final PdfPage page = document.pages.add();

// Get page count
int pageCount = document.pages.count;

// Get specific page
final PdfPage firstPage = document.pages[0];

// Remove page
document.pages.removeAt(0);

// Insert page at specific index
document.pages.insert(0);

// Get client size (page content area)
final Size pageSize = page.getClientSize();
```

## Page Settings

```dart
// Set page size
final PdfPage page = document.pages.add();
page.size = PdfPageSize.a4;

// Set orientation
page.orientation = PdfPageOrientation.landscape;

// Set margins
page.section.margins = PdfMargins(left: 50, right: 50, top: 50, bottom: 50);

// Set rotate angle
page.rotation = PdfPageRotateAngle.rotateAngle90;
```

## Document Information

```dart
final PdfDocument document = PdfDocument();

// Set document properties
document.documentInformation.title = 'My Document';
document.documentInformation.author = 'Author Name';
document.documentInformation.subject = 'Subject';
document.documentInformation.keywords = 'keyword1, keyword2';
document.documentInformation.creator = 'Application Name';
document.documentInformation.producer = 'Syncfusion PDF';
```

## Template (Headers/Footers)

```dart
final PdfDocument document = PdfDocument();

// Create header template
final PdfPageTemplateElement header = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 515, 50)
);
header.graphics.drawString(
  'Page Header',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: const Rect.fromLTWH(0, 15, 200, 20)
);
document.template.top = header;

// Create footer template
final PdfPageTemplateElement footer = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 515, 50)
);
footer.graphics.drawString(
  'Page Footer',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: const Rect.fromLTWH(0, 15, 200, 20)
);
document.template.bottom = footer;

// Create left margin template
document.template.left = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 50, 500)
);

// Create right margin template
document.template.right = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 50, 500)
);

// Add pages
document.pages.add();
document.pages.add();
```

## Document Structure

```dart
// Enable incremental update
document.fileStructure.incrementalUpdate = true;

// Set PDF version
document.fileStructure.pdfVersion = PdfVersion.v1_7;

// Enable object stream
document.fileStructure.enableObjectStream = true;

// Enable cross-reference compression
document.fileStructure.crossReferenceCompression = true;
```

## Loading Existing PDF

```dart
// Load from file
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Load from bytes
final PdfDocument document = PdfDocument(
  inputBytes: pdfBytes
);

// Get info from loaded document
int pages = document.pages.count;
String title = document.documentInformation.title;

// Modify and save
document.pages[0].graphics.drawString(
  'Added Text',
  PdfStandardFont(PdfFontFamily.helvetica, 12)
);
File('output.pdf').writeAsBytesSync(await document.save());
document.dispose();
```