# Annotations Reference

## Bookmarks

### Create Bookmark

```dart
final PdfDocument document = PdfDocument();

// Add some content pages
document.pages.add().graphics.drawString(
  'Chapter 1',
  PdfStandardFont(PdfFontFamily.helvetica, 20)
);
document.pages.add().graphics.drawString(
  'Chapter 2',
  PdfStandardFont(PdfFontFamily.helvetica, 20)
);

// Create bookmark
final PdfBookmark root = document.bookmarks;

// Add first bookmark
final PdfBookmark chapter1 = root.add('Chapter 1');
chapter1.destination = PdfDestination(
  document.pages[0],
  const Offset(0, 0)
);
chapter1.color = PdfColor(0, 0, 255);  // Blue
chapter1.style = PdfBookmarkStyle.bold;

// Add second bookmark
final PdfBookmark chapter2 = root.add('Chapter 2');
chapter2.destination = PdfDestination(
  document.pages[1],
  const Offset(0, 0)
);

// Add nested bookmark
final PdfBookmark section = chapter1.add('Section 1.1');
section.destination = PdfDestination(
  document.pages[0],
  const Offset(50, 100)
);
section.style = PdfBookmarkStyle.italic;

// Save
File('bookmarked.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Bookmark Properties

```dart
final PdfBookmark bookmark = document.bookmarks.add('Title');

// Set destination (page and position)
bookmark.destination = PdfDestination(
  document.pages[0],
  const Offset(20, 50)
);

// Style
bookmark.style = PdfBookmarkStyle.regular;  // regular, bold, italic, boldItalic

// Color
bookmark.color = PdfColor(255, 0, 0);  // Red

// Action (instead of destination)
bookmark.action = PdfAction(
  Uri.parse('https://example.com')
);

// Enable/Disable
bookmark.isExpanded = true;
bookmark.isVisible = true;
```

### Navigate Existing Bookmarks

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('bookmarked.pdf').readAsBytesSync()
);

// Get root bookmark
final PdfBookmarkBase root = document.bookmarks;

// Iterate bookmarks
void processBookmark(PdfBookmarkBase bookmark) {
  print('Title: ${bookmark.title}');
  if (bookmark is PdfBookmark) {
    print('Destination: ${bookmark.destination}');
    print('Color: ${bookmark.color}');
    print('Style: ${bookmark.style}');
  }
  
  // Process children
  for (final child in bookmark) {
    processBookmark(child);
  }
}

processBookmark(root);

// Find specific bookmark
PdfBookmark? findBookmark(PdfBookmarkBase bookmarks, String title) {
  for (final bookmark in bookmarks) {
    if (bookmark.title == title) {
      return bookmark;
    }
    final found = findBookmark(bookmark, title);
    if (found != null) return found;
  }
  return null;
}
```

## Annotations

### Rectangle Annotation

```dart
final PdfPage page = document.pages.add();

// Add rectangle annotation
final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
  Rect.fromLTWH(0, 0, 100, 50),
  'Rectangle Annotation',
  color: PdfColor(255, 255, 0),      // Yellow fill
  borderColor: PdfColor(255, 0, 0),  // Red border
  borderWidth: 2,
  setAppearance: true
);

// Annotation flags
rectAnnotation.flags = <PdfAnnotationFlag>[
  PdfAnnotationFlag.print,
  PdfAnnotationFlag.locked
];

page.annotations.add(rectAnnotation);
```

### Ellipse Annotation

```dart
final PdfEllipseAnnotation ellipse = PdfEllipseAnnotation(
  Rect.fromLTWH(0, 60, 80, 40),
  'Ellipse Annotation',
  color: PdfColor(0, 255, 0),
  borderColor: PdfColor(0, 0, 255),
  borderWidth: 1,
  setAppearance: true
);

page.annotations.add(ellipse);
```

### Line Annotation

```dart
final PdfLineAnnotation line = PdfLineAnnotation(
  const Offset(0, 0),
  const Offset(100, 0),
  'Line Annotation',
  lineBorder: PdfAnnotationBorder(
    width: 2,
    style: PdfBorderStyle.solid
  ),
  color: PdfColor(0, 0, 0),
  setAppearance: true
);

// Line styles
line.lineBorder = PdfAnnotationBorder(
  width: 2,
  style: PdfBorderStyle.dashed,
  dashPattern: [5, 3]
);

page.annotations.add(line);
```

### Text/Note Annotation

```dart
final PdfTextAnnotation textAnnotation = PdfTextAnnotation(
  Rect.fromLTWH(50, 50, 20, 20),
  'Note',
  text: 'This is a note annotation',
  color: PdfColor(255, 255, 0),
  setAppearance: true
);

textAnnotation.icon = PdfTextAnnotationIcon.note;
textAnnotation.icon = PdfTextAnnotationIcon.comment;
textAnnotation.icon = PdfTextAnnotationIcon.key;
textAnnotation.icon = PdfTextAnnotationIcon.help;

page.annotations.add(textAnnotation);
```

### Link Annotation

```dart
// Internal link (to page/destination)
final PdfDocumentLinkAnnotation internalLink = PdfDocumentLinkAnnotation(
  Rect.fromLTWH(0, 0, 100, 20),
  PdfDestination(document.pages[1], const Offset(0, 0))
);
internalLink.color = PdfColor(0, 0, 255);
internalLink.border = PdfAnnotationBorder(1);

page.annotations.add(internalLink);

// External link (to URL)
final PdfWebLinkAnnotation externalLink = PdfWebLinkAnnotation(
  Rect.fromLTWH(0, 30, 100, 20),
  Uri.parse('https://syncfusion.com')
);
externalLink.text = 'Visit Syncfusion';
externalLink.color = PdfColor(0, 100, 0);
externalLink.border = PdfAnnotationBorder(1);

page.annotations.add(externalLink);
```

### Highlight Annotation

```dart
// Highlight
final PdfHighlightAnnotation highlight = PdfHighlightAnnotation(
  Rect.fromLTWH(0, 0, 100, 20),
  'Highlight',
  color: PdfColor(255, 255, 0),
  setAppearance: true
);
highlight.quadrilateralPoints = [
  const Offset(0, 0),
  const Offset(100, 0),
  const Offset(100, 20),
  const Offset(0, 20)
];

page.annotations.add(highlight);

// Underline
final PdfUnderlineAnnotation underline = PdfUnderlineAnnotation(
  Rect.fromLTWH(0, 30, 100, 20),
  'Underline',
  color: PdfColor(255, 0, 0),
  setAppearance: true
);

page.annotations.add(underline);

// Strikeout
final PdfStrikeOutAnnotation strikeout = PdfStrikeOutAnnotation(
  Rect.fromLTWH(0, 60, 100, 20),
  'Strikeout',
  color: PdfColor(0, 0, 255),
  setAppearance: true
);

page.annotations.add(strikeout);
```

### Polygon Annotation

```dart
final PdfPolygonAnnotation polygon = PdfPolygonAnnotation(
  'Polygon',
  [
    const Offset(0, 0),
    const Offset(50, 0),
    const Offset(50, 50),
    const Offset(0, 50)
  ],
  color: PdfColor(200, 200, 200),
  borderColor: PdfColor(0, 0, 0),
  borderWidth: 1,
  setAppearance: true
);

page.annotations.add(polygon);
```

## Annotation Management

```dart
// Get all annotations on page
final PdfAnnotationCollection annotations = page.annotations;

// Iterate
for (final annotation in annotations) {
  print('Type: ${annotation.runtimeType}');
  print('Bounds: ${annotation.bounds}');
  print('Contents: ${annotation.contents}');
}

// Modify annotation
final PdfRectangleAnnotation rect = 
    page.annotations[0] as PdfRectangleAnnotation;
rect.text = 'Modified text';
rect.color = PdfColor(0, 255, 0);

// Remove annotation
page.annotations.removeAt(0);

// Clear all annotations
page.annotations.clear();

// Add multiple annotations
page.annotations.addAll([
  PdfRectangleAnnotation(Rect.fromLTWH(0, 0, 50, 20), '1'),
  PdfRectangleAnnotation(Rect.fromLTWH(60, 0, 50, 20), '2'),
]);
```

## Annotation Actions

```dart
// Create annotation with actions
final PdfRectangleAnnotation actionAnnotation = PdfRectangleAnnotation(
  Rect.fromLTWH(0, 0, 100, 30),
  'Click me'
);

// Add actions
actionAnnotation.actions = PdfAnnotationActions(
  onMouseUp: PdfAction(
    Uri.parse('https://example.com')
  ),
  onMouseDown: PdfAction(
    PdfActionType.remoteGoTo,
    destination: PdfDestination(document.pages[1], const Offset(0, 0))
  ),
  onMouseEnter: PdfAction(
    PdfActionType.rendition,
    sound: PdfSound(File('sound.wav').readAsBytesSync())
  ),
  onMouseExit: PdfAction(
    PdfActionType.resetForm
  )
);

page.annotations.add(actionAnnotation);
```

## Attachment

```dart
// Add file attachment
final PdfAttachment attachment = PdfAttachment(
  'attachment.pdf',
  File('attachment.pdf').readAsBytesSync(),
  description: 'Attached file',
  mimeType: 'application/pdf'
);

document.attachments.add(attachment);

// Get attachments
for (final attach in document.attachments) {
  print('Name: ${attach.fileName}');
  print('Description: ${attach.description}');
  print('Size: ${attach.data.length}');
}

// Save attachment
final PdfAttachment attachment = document.attachments[0];
File(attachment.fileName).writeAsBytesSync(attachment.data);

// Remove attachment
document.attachments.removeAt(0);
```

## Navigation

```dart
// Add named destination for navigation
final PdfNamedDestination namedDest = PdfNamedDestination(
  'Introduction',
  PdfDestination(document.pages[0], const Offset(0, 0))
);

document.namedDestinations.add(namedDest);

// Use in link annotation
final PdfDocumentLinkAnnotation link = PdfDocumentLinkAnnotation(
  Rect.fromLTWH(0, 0, 100, 20),
  document.namedDestinations[0]
);

page.annotations.add(link);

// Add outline (table of contents)
document.documentTemplate.outline = PdfOutline(
  PdfOutlineRoot()
);
document.documentTemplate.outline.root.add(
  'Introduction',
  PdfDestination(document.pages[0], const Offset(0, 0))
);
```