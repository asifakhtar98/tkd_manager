# PDF Modification Reference

## Loading PDFs

```dart
// Load from file
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Load from bytes
final List<int> pdfBytes = await fetchPdfBytes();
final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

// Load with password (encrypted PDF)
final PdfDocument encryptedDoc = PdfDocument(
  inputBytes: File('encrypted.pdf').readAsBytesSync(),
  password: 'userpassword'
);

// Load specific page range
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync(),
  // Note: Full document loads, use pages property to work with specific pages
);
```

## Page Operations

```dart
// Get page count
int count = document.pages.count;

// Get specific page
final PdfPage page = document.pages[0];

// Add new page
final PdfPage newPage = document.pages.add();

// Insert page at index
final PdfPage insertedPage = document.pages.insert(0);

// Remove page
document.pages.removeAt(0);

// Remove last page
document.pages.removeLast();

// Clear all pages
document.pages.clear();

// Get page size
final Size size = page.getClientSize();
final PdfPageSize pageSize = page.size;
final PdfPageOrientation orientation = page.orientation;

// Set page properties
page.size = PdfPageSize.a4;
page.orientation = PdfPageOrientation.landscape;

// Page rotation
page.rotation = PdfPageRotateAngle.rotateAngle90;
```

## Text Extraction

### Basic Text Extraction

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Extract all text
final PdfTextExtractor extractor = PdfTextExtractor(document);
String allText = extractor.extractText();
print(allText);

// Extract from specific page
String pageText = extractor.extractText(startPageIndex: 0);

// Extract page range
String rangeText = extractor.extractText(
  startPageIndex: 0,
  endPageIndex: 5
);

// Extract with bounds
final List<MatchedItem> textWithBounds = extractor.extractText(
  startPageIndex: 0,
  format: PdfTextExtractOptions(
    extractClippedText: true
  )
);

for (final item in textWithBounds) {
  print('Text: ${item.text}');
  print('Bounds: ${item.bounds}');
  print('Page: ${item.pageIndex}');
}
```

### Find and Search Text

```dart
final PdfTextExtractor extractor = PdfTextExtractor(document);

// Find single text
List<MatchedItem> matches = extractor.findText(['invoice']);

// Find multiple texts
List<MatchedItem> multipleMatches = extractor.findText([
  'invoice',
  'total',
  'due'
]);

// Find with options
matches = extractor.findText(
  ['search'],
  searchOptions: PdfSearchOptions(
    caseSensitive: true,
    wholeWord: false
  )
);

// Access match details
for (final match in matches) {
  print('Text: ${match.text}');
  print('Page: ${match.pageIndex}');
  print('Bounds: ${match.bounds}');
  print('Match index: ${match.matchIndex}');
}

// Search with regex
matches = extractor.findText(
  [r'\d{3}-\d{4}'],  // Pattern like 123-4567
  searchOptions: PdfSearchOptions(
    regularExpression: true
  )
);
```

### Extract Text by Area

```dart
final PdfTextExtractor extractor = PdfTextExtractor(document);

// Extract from specific region
String regionText = extractor.extractText(
  startPageIndex: 0,
  extractOptions: PdfTextExtractOptions(
    extractClippedText: true,
    bounds: Rect.fromLTWH(0, 0, 200, 100)
  )
);

// Get text with layout information
List<MatchedItem> layoutText = extractor.extractText(
  startPageIndex: 0,
  extractOptions: PdfTextExtractOptions(
    layout: true
  )
);

for (final item in layoutText) {
  print('Line: ${item.text}, Y: ${item.bounds.top}');
}
```

## Image Extraction

```dart
// Extract images from PDF
final PdfImageExtractor extractor = PdfImageExtractor(document);

for (int i = 0; i < document.pages.count; i++) {
  final List<PdfImageInfo> images = extractor.extractImages(
    pageIndex: i
  );
  
  for (final imageInfo in images) {
    print('Image size: ${imageInfo.width}x${imageInfo.height}');
    print('Image type: ${imageInfo.imageFormat}');
    
    // Get image bytes
    Uint8List imageBytes = imageInfo.imageBytes;
    
    // Save image
    File('image_$i.png').writeAsBytesSync(imageBytes);
  }
}
```

## Modification Operations

### Add Content to Existing Page

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

final PdfPage page = document.pages[0];

// Add text
page.graphics.drawString(
  'New Text',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: const Rect.fromLTWH(0, 0, 100, 20)
);

// Add image
final PdfBitmap image = PdfBitmap(File('logo.png').readAsBytesSync());
page.graphics.drawImage(
  image,
  const Rect.fromLTWH(200, 0, 100, 50)
);

// Add shape
page.graphics.drawRectangle(
  PdfPen(PdfColor(255, 0, 0)),
  const Rect.fromLTWH(0, 50, 50, 50)
);

File('modified.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Modify Text

```dart
// First extract text location, then modify
final PdfTextExtractor extractor = PdfTextExtractor(document);
List<MatchedItem> matches = extractor.findText(['oldtext']);

if (matches.isNotEmpty) {
  final MatchedItem match = matches[0];
  final PdfPage page = document.pages[match.pageIndex];
  
  // Draw new text over old (not removing, just covering)
  // For true modification, you'd need to track exact bounds
  page.graphics.drawString(
    'newtext',
    PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: match.bounds
  );
}
```

### Add Watermark

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Add watermark to all pages
for (final page in document.pages) {
  final PdfGraphics graphics = page.graphics;
  
  // Save state
  graphics.save();
  
  // Rotate and set transparency
  graphics.setTransparency(0.3);
  graphics.rotateTransform(-45);
  
  // Draw watermark text
  final Size pageSize = page.getClientSize();
  graphics.drawString(
    'CONFIDENTIAL',
    PdfTrueTypeFont(File('arial.ttf').readAsBytesSync(), 60),
    brush: PdfSolidBrush(PdfColor(200, 200, 200)),
    bounds: Rect.fromLTWH(
      pageSize.width * 0.2,
      pageSize.height * 0.4,
      400,
      100
    ),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.center
    )
  );
  
  // Restore
  graphics.restore();
}

File('watermarked.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Add Page Numbers

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

final PdfFont font = PdfStandardFont(
  PdfFontFamily.helvetica,
  10
);

for (int i = 0; i < document.pages.count; i++) {
  final PdfPage page = document.pages[i];
  
  page.graphics.drawString(
    'Page ${i + 1}',
    font,
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: Rect.fromLTWH(
      page.getClientSize().width - 50,
      page.getClientSize().height - 20,
      40,
      20
    ),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.right
    )
  );
}

File('paged.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Merge PDFs

```dart
// Load source PDFs
final PdfDocument source1 = PdfDocument(
  inputBytes: File('doc1.pdf').readAsBytesSync()
);
final PdfDocument source2 = PdfDocument(
  inputBytes: File('doc2.pdf').readAsBytesSync()
);

// Create new document
final PdfDocument merged = PdfDocument();

// Copy pages from source1
for (int i = 0; i < source1.pages.count; i++) {
  merged.pages.add();
}

// Copy pages from source2
for (int i = 0; i < source2.pages.count; i++) {
  merged.pages.add();
}

// Alternatively, use page template approach
// This copies content at graphics level
```

### Split PDF

```dart
final PdfDocument source = PdfDocument(
  inputBytes: File('large.pdf').readAsBytesSync()
);

// Extract single page to new document
final PdfDocument single = PdfDocument();
single.pages.add().graphics.drawPdfTemplate(
  source.pages[0].createTemplate(),
  const Offset(0, 0)
);
File('page1.pdf').writeAsBytesSync(await single.save());
single.dispose();

// Extract page range
final PdfDocument range = PdfDocument();
for (int i = 0; i < 5; i++) {
  range.pages.add().graphics.drawPdfTemplate(
    source.pages[i].createTemplate(),
    const Offset(0, 0)
  );
}
File('pages1-5.pdf').writeAsBytesSync(await range.save());
range.dispose();

source.dispose();
```

## Annotation Operations

```dart
// Get annotations from page
final PdfPage page = document.pages[0];
final PdfAnnotationCollection annotations = page.annotations;

// Add annotation
page.annotations.add(PdfRectangleAnnotation(
  Rect.fromLTWH(0, 0, 100, 50),
  'Annotation text',
  color: PdfColor(255, 255, 0)
));

// Iterate annotations
for (final annotation in annotations) {
  print('Type: ${annotation.runtimeType}');
  print('Bounds: ${annotation.bounds}');
}

// Remove annotation
annotations.removeAt(0);

// Clear all annotations
annotations.clear();
```

## Form Operations

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('form.pdf').readAsBytesSync()
);

final PdfForm form = document.form;

// Get all fields
final fields = form.fields;
print('Field count: ${fields.count}');

// Get field by name
final textField = form.findField('name') as PdfTextBoxField?;
if (textField != null) {
  textField.text = 'New Value';
}

// Fill multiple fields
form.fields.forEach((field) {
  if (field is PdfTextBoxField) {
    // Process text fields
  } else if (field is PdfCheckBoxField) {
    // Process checkboxes
  }
});

// Flatten form
form.flattenAllFields();

// Remove form
form.remove();

File('filled.pdf').writeAsBytesSync(await document.save());
document.dispose();
```