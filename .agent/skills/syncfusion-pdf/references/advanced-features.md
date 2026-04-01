# Advanced Features Reference

## Automatic Fields

### Page Number Field

```dart
final PdfDocument document = PdfDocument();
final PdfPage page = document.pages.add();

// Add automatic page number
final PdfPageNumberField pageNumber = PdfPageNumberField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  format: PdfStringFormat(
    alignment: PdfTextAlignment.center
  )
);

page.graphics.drawString(
  'Page ',
  PdfStandardFont(PdfFontFamily.helvetica, 10)
);
pageNumber.draw(page, const Offset(50, 0));
```

### Page Count Field

```dart
// Display total page count
final PdfPageCountField pageCount = PdfPageCountField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  brush: PdfSolidBrush(PdfColor(0, 0, 0))
);

page.graphics.drawString(
  ' of ',
  PdfStandardFont(PdfFontFamily.helvetica, 10)
);
pageCount.draw(page, Offset(page.getClientSize().width - 50, 0));
```

### Combined Page Number and Count

```dart
// Combined "Page X of Y" field
final PdfCompositeField compositeField = PdfCompositeField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  fields: <PdfAutomaticField>[
    PdfPageNumberField(font: PdfStandardFont(PdfFontFamily.helvetica, 10)),
    PdfStaticField(
      value: ' of ',
      font: PdfStandardFont(PdfFontFamily.helvetica, 10)
    ),
    PdfPageCountField(font: PdfStandardFont(PdfFontFamily.helvetica, 10))
  ],
  format: PdfStringFormat(alignment: PdfTextAlignment.center)
);

compositeField.draw(page, const Offset(200, page.getClientSize().height - 20));
```

### Date/Time Field

```dart
// Current date
final PdfDateTimeField dateField = PdfDateTimeField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  dateFormat: 'MMMM dd, yyyy'  // e.g., "January 15, 2024"
);

dateField.draw(page, const Offset(0, 0));

// Creation date (from document info)
final PdfDateTimeField creationDate = PdfDateTimeField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  dateFormat: 'MM/dd/yyyy HH:mm',
  source: PdfAutomaticFieldSource.creationDate
);

creationDate.draw(page, const Offset(0, 20));

// Modification date
final PdfDateTimeField modDate = PdfDateTimeField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  dateFormat: 'MM/dd/yyyy',
  source: PdfAutomaticFieldSource.modificationDate
);
```

### Document Information Fields

```dart
// Title field
final PdfDocumentField titleField = PdfDocumentField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  source: PdfAutomaticFieldSource.title
);
titleField.draw(page, const Offset(0, 40));

// Author field
final PdfDocumentField authorField = PdfDocumentField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  source: PdfAutomaticFieldSource.author
);

// Subject, keywords, creator, producer
```

### Destination Page Number

```dart
// Display page number of a specific destination
final PdfDestinationPageNumberField destPageField = 
    PdfDestinationPageNumberField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  destination: PdfDestination(document.pages[5], const Offset(0, 0))
);

destPageField.draw(page, const Offset(0, 60));
```

## Template System

### Create and Use Template

```dart
// Create template
final PdfTemplate template = PdfTemplate(
  width: 200,
  height: 50
);

// Draw on template
template.graphics.drawRectangle(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.lightGray,
  const Rect.fromLTWH(0, 0, 200, 50)
);
template.graphics.drawString(
  'Company Header',
  PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  bounds: const Rect.fromLTWH(10, 10, 180, 30),
  format: PdfStringFormat(alignment: PdfTextAlignment.center)
);

// Use template on page
final PdfPage page = document.pages.add();
page.graphics.drawPdfTemplate(
  template,
  const Offset(0, 0)
);

// Reuse template on another page
final PdfPage page2 = document.pages.add();
page2.graphics.drawPdfTemplate(
  template,
  const Offset(0, 0)
);
```

### Dynamic Template Content

```dart
// Template with placeholders
PdfTemplate createHeaderTemplate(String title) {
  final PdfTemplate template = PdfTemplate(
    width: 400,
    height: 60
  );
  
  template.graphics.drawRectangle(
    PdfSolidBrush(PdfColor(50, 100, 150)),
    const Rect.fromLTWH(0, 0, 400, 60)
  );
  
  template.graphics.drawString(
    title,
    PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
    brush: PdfSolidBrush(PdfColor.white),
    bounds: const Rect.fromLTWH(20, 20, 360, 30),
    format: PdfStringFormat(alignment: PdfTextAlignment.center)
  );
  
  return template;
}

// Use
final PdfPage page = document.pages.add();
page.graphics.drawPdfTemplate(
  createHeaderTemplate('Invoice #12345'),
  const Offset(0, 0)
);
```

## Page Templates (Headers/Footers)

### Simple Header/Footer

```dart
final PdfDocument document = PdfDocument();

// Header template
final PdfPageTemplateElement header = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 500, 40)
);
header.graphics.drawString(
  'Document Header',
  PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  bounds: const Rect.fromLTWH(0, 10, 500, 20),
  format: PdfStringFormat(alignment: PdfTextAlignment.center)
);
document.template.top = header;

// Footer template
final PdfPageTemplateElement footer = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 500, 30)
);
footer.graphics.drawString(
  'Page Footer - Confidential',
  PdfStandardFont(PdfFontFamily.helvetica, 9),
  brush: PdfSolidBrush(PdfColor(100, 100, 100)),
  bounds: const Rect.fromLTWH(0, 5, 500, 20),
  format: PdfStringFormat(alignment: PdfTextAlignment.center)
);
document.template.bottom = footer;

// Add pages
document.pages.add();
document.pages.add();
```

### Dynamic Header with Page Numbers

```dart
final PdfDocument document = PdfDocument();

// Create composite footer with page numbers
final PdfPageTemplateElement footer = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 500, 30)
);

// Draw static text
footer.graphics.drawString(
  'Page ',
  PdfStandardFont(PdfFontFamily.helvetica, 9),
  const Offset(0, 10)
);

// Add page number field
final PdfPageNumberField pageNum = PdfPageNumberField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 9)
);
pageNum.draw(footer, const Offset(35, 10));

footer.graphics.drawString(
  ' of ',
  PdfStandardFont(PdfFontFamily.helvetica, 9),
  Offset(pageNum.bounds.right, 10)
);

final PdfPageCountField totalPages = PdfPageCountField(
  font: PdfStandardFont(PdfFontFamily.helvetica, 9)
);
totalPages.draw(footer, Offset(pageNum.bounds.right + 30, 10));

document.template.bottom = footer;
```

### Margin Templates

```dart
// Left margin (for notes)
final PdfPageTemplateElement leftMargin = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 50, 700)
);
leftMargin.graphics.drawLine(
  PdfPen(PdfColor(200, 200, 200)),
  const Offset(48, 0),
  const Offset(48, 700)
);
document.template.left = leftMargin;

// Right margin
final PdfPageTemplateElement rightMargin = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 50, 700)
);
rightMargin.graphics.drawLine(
  PdfPen(PdfColor(200, 200, 200)),
  const Offset(2, 0),
  const Offset(2, 700)
);
document.template.right = rightMargin;
```

## Complex Document Structures

### Multiple Sections

```dart
final PdfDocument document = PdfDocument();

// Section 1
final PdfSection section1 = document.sections.add();
section1.pageSettings.size = PdfPageSize.a4;
section1.pageSettings.orientation = PdfPageOrientation.portrait;
section1.pageSettings.margins = PdfMargins(all: 50);

final PdfPage section1Page = section1.pages.add();
section1Page.graphics.drawString(
  'Section 1: Introduction',
  PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold)
);

// Section 2 - landscape
final PdfSection section2 = document.sections.add();
section2.pageSettings.size = PdfPageSize.a4;
section2.pageSettings.orientation = PdfPageOrientation.landscape;
section2.pageSettings.margins = PdfMargins(all: 30);

final PdfPage section2Page = section2.pages.add();
section2Page.graphics.drawString(
  'Section 2: Data Tables',
  PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold)
);
```

### Table of Contents

```dart
void addTableOfContents(PdfDocument document, List<TocEntry> entries) {
  final PdfPage tocPage = document.pages.add();
  
  tocPage.graphics.drawString(
    'Table of Contents',
    PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
    bounds: const Rect.fromLTWH(0, 0, 200, 30)
  );
  
  double y = 40;
  for (final entry in entries) {
    // Entry title
    tocPage.graphics.drawString(
      entry.title,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, y, 350, 20)
    );
    
    // Leader dots (optional)
    // ... drawing dotted line ...
    
    // Page number
    tocPage.graphics.drawString(
      entry.pageNumber.toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(400, y, 50, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right)
    );
    
    // Add bookmark
    final PdfBookmark bookmark = document.bookmarks.add(entry.title);
    bookmark.destination = PdfDestination(entry.page, const Offset(0, 0));
    
    y += 25;
  }
}

// Usage
class TocEntry {
  final String title;
  final PdfPage page;
  final int pageNumber;
  
  TocEntry(this.title, this.page, this.pageNumber);
}
```

### Master Pages

```dart
// Create master page template
final PdfPageTemplateElement masterPage = PdfPageTemplateElement(
  const Rect.fromLTWH(0, 0, 500, 700)
);

// Add logo
masterPage.graphics.drawImage(
  PdfBitmap(File('logo.png').readAsBytesSync()),
  const Rect.fromLTWH(10, 10, 80, 40)
);

// Add border
masterPage.graphics.drawRectangle(
  PdfPen(PdfColor(200, 200, 200), strokeWidth: 1),
  const Rect.fromLTWH(0, 0, 500, 700)
);

// Apply to template
document.template.left = masterPage;
document.template.top = masterPage;
```

## Graphics Features

### Clipping

```dart
final PdfGraphics graphics = page.graphics;

// Save graphics state
graphics.save();

// Define clipping region
graphics.setClip(Rect.fromLTWH(0, 0, 100, 100));

// Draw content (clipped to region)
graphics.drawImage(
  PdfBitmap(File('image.png').readAsBytesSync()),
  const Rect.fromLTWH(0, 0, 100, 100)
);

// Clear clip
graphics.clearClip();

// Restore state
graphics.restore();
```

### Layer Support (Optional Content)

```dart
// Create optional content group
final PdfOptionalContentGroup group = PdfOptionalContentGroup(
  'WatermarkLayer'
);

// Add content to group
group.properties.visible = true;
group.properties.printable = false;

// Draw watermark in group
final PdfGraphics groupGraphics = group.graphics;
groupGraphics.setTransparency(0.3);
groupGraphics.rotateTransform(-45);
groupGraphics.drawString(
  'DRAFT',
  PdfTrueTypeFont(File('arial.ttf').readAsBytesSync(), 60),
  brush: PdfSolidBrush(PdfColor(200, 200, 200)),
  bounds: const Rect.fromLTWH(100, 200, 300, 80)
);

// Add group to page
page.optionalContent.add(group);
```

### Transparency Groups

```dart
// Create transparency group
final PdfTransparencyGroup group = PdfTransparencyGroup();

// Draw elements in group
group.graphics.drawRectangle(
  PdfSolidBrush(PdfColor(255, 0, 0, alpha: 128)),
  const Rect.fromLTWH(0, 0, 50, 50)
);
group.graphics.drawRectangle(
  PdfSolidBrush(PdfColor(0, 0, 255, alpha: 128)),
  const Offset(25, 25),
  const Size(50, 50)
);

// Draw group on page
page.graphics.drawTransparencyGroup(
  group,
  const Offset(100, 100)
);
```

## Performance Optimization

### Memory Management

```dart
// Always dispose document when done
final PdfDocument document = PdfDocument();
// ... operations ...
document.dispose();

// For large documents, process in chunks
Future<void> createLargeDocument() async {
  final PdfDocument document = PdfDocument();
  
  for (int i = 0; i < 1000; i++) {
    final PdfPage page = document.pages.add();
    // Add content
    
    // Save periodically to avoid memory issues
    if (i % 100 == 0) {
      // Process intermediate result
    }
  }
  
  final List<int> bytes = await document.save();
  document.dispose();
}
```

### Streaming Output

```dart
// For very large PDFs, use file-based operations
Future<void> createLargePdf(String outputPath) async {
  final RandomAccessFile outputFile = File(outputPath).openSync(mode: FileMode.write);
  
  final PdfDocument document = PdfDocument();
  
  // Add content
  for (int i = 0; i < 100; i++) {
    document.pages.add().graphics.drawString(
      'Page $i',
      PdfStandardFont(PdfFontFamily.helvetica, 12)
    );
  }
  
  final List<int> bytes = await document.save();
  outputFile.writeFromSync(bytes);
  outputFile.closeSync();
  
  document.dispose();
}
```