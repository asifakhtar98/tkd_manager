# Text Formatting Reference

## Standard Fonts

```dart
// Using built-in standard fonts
final PdfFont font = PdfStandardFont(
  PdfFontFamily.helvetica,
  12,
  style: PdfFontStyle.bold | PdfFontStyle.italic
);

// Available font families
// PdfFontFamily.helvetica
// PdfFontFamily.timesRoman
// PdfFontFamily.courier
// PdfFontFamily.symbol
// PdfFontFamily.zapfDingbats
```

## TrueType Fonts (Custom Fonts)

```dart
// Load TrueType font from file
final Uint8List fontData = File('arial.ttf').readAsBytesSync();
final PdfFont font = PdfTrueTypeFont(fontData, 12);

// Load font with style
final PdfFont boldFont = PdfTrueTypeFont(fontData, 12, style: PdfFontStyle.bold);

// Unicode font support
final PdfFont unicodeFont = PdfTrueTypeFont(
  File('NotoSans-Regular.ttf').readAsBytesSync(),
  12,
  subset: true  // Creates subset for smaller file size
);
```

## CJK (Chinese, Japanese, Korean) Fonts

```dart
// CJK standard fonts - no need to load external files
final PdfFont cjkFont = PdfCjkStandardFont(
  PdfCjkFontFamily.heiseiMinW3,
  12
);

// Available CJK families
// PdfCjkFontFamily.heiseiMinW3 (Japanese)
// PdfCjkFontFamily.sungTiL (Traditional Chinese)
// PdfCjkFontFamily.mHeiTiB (Simplified Chinese)
// PdfCjkFontFamily.bangsuh (Korean)
```

## Text Drawing

```dart
final PdfPage page = document.pages.add();

// Simple text drawing
page.graphics.drawString(
  'Hello World',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  bounds: const Rect.fromLTWH(0, 0, 200, 20)
);

// With formatting
final PdfStringFormat format = PdfStringFormat(
  alignment: PdfTextAlignment.center,
  lineAlignment: PdfVerticalAlignment.middle,
  lineSpacing: 5
);
page.graphics.drawString(
  'Centered Text',
  PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  bounds: Rect.fromLTWH(0, 0, 200, 50),
  format: format
);
```

## PdfStringFormat Options

```dart
final PdfStringFormat format = PdfStringFormat(
  // Horizontal alignment
  alignment: PdfTextAlignment.left,  // left, center, right, justify
  
  // Vertical alignment
  lineAlignment: PdfVerticalAlignment.top,  // top, center, bottom
  
  // Line spacing
  lineSpacing: 5,
  
  // Character spacing
  characterSpacing: 2,
  
  // Word spacing
  wordSpacing: 3,
  
  // Text scaling (percentage)
  scaling: 100,
  
  // First line indent
  firstLineIndent: 20,
  
  // Reading direction
  readingDirection: PdfReadingDirection.leftToRight,
  
  // Word wrap
  wordWrap: PdfWordWrapType.word,  // word, character, wordOnly
  
  // Truncation
  truncation: PdfTextOverflowellipsis,
);
```

## Text Element (Flow Layout)

```dart
const String text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...';

final PdfTextElement textElement = PdfTextElement(
  text: text,
  font: PdfStandardFont(PdfFontFamily.helvetica, 12),
  brush: PdfSolidBrush(PdfColor(0, 0, 0))
);

// Draw with automatic pagination
final PdfLayoutResult result = textElement.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
  format: PdfLayoutFormat(
    layoutType: PdfLayoutType.paginate,
    breakType: PdfLayoutBreakType.fitElement
  )
)!;

// Get layout result properties
print('Bounds: ${result.bounds}');
print('Page: ${result.page}');

// Continue on next page if needed
if (result.isLastLine) {
  final PdfPage nextPage = document.pages.add();
  final PdfLayoutResult nextResult = textElement.draw(
    page: nextPage,
    bounds: Rect.fromLTWH(0, 0, nextPage.getClientSize().width, nextPage.getClientSize().height),
    format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate)
  )!;
}
```

## Multi-line Text

```dart
// Using PdfTextElement for multi-line
final PdfTextElement multiLineElement = PdfTextElement(
  text: 'First line\nSecond line\nThird line',
  font: PdfStandardFont(PdfFontFamily.helvetica, 12),
  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  format: PdfStringFormat(lineSpacing: 8)
);

multiLineElement.draw(
  page: page,
  bounds: const Rect.fromLTWH(0, 0, 300, 200)
);
```

## RTL (Right-to-Left) Text

```dart
// Enable RTL support
final PdfStringFormat rtlFormat = PdfStringFormat(
  readingDirection: PdfReadingDirection.rightToLeft
);

page.graphics.drawString(
  'النص العربي',
  PdfTrueTypeFont(File('arial.ttf').readAsBytesSync(), 12),
  bounds: Rect.fromLTWH(0, 0, 200, 20),
  format: rtlFormat
);
```

## Bulleted Lists

```dart
// Unordered (bulleted) list
final PdfUnorderedList unorderedList = PdfUnorderedList(
  marker: PdfUnorderedMarker(
    font: PdfStandardFont(PdfFontFamily.helvetica, 10),
    style: PdfUnorderedMarkerStyle.disk  // disk, circle, square, none
  ),
  items: PdfListItemCollection([
    'First item',
    'Second item',
    'Third item'
  ]),
  textIndent: 10,
  indent: 20,
  format: PdfStringFormat(lineSpacing: 5)
);

unorderedList.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height)
);
```

## Ordered Lists

```dart
// Ordered (numbered) list
final PdfOrderedList orderedList = PdfOrderedList(
  marker: PdfOrderedMarker(
    style: PdfNumberStyle.numeric,  // numeric, roman, alphabetic
    font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    suffix: PdfNumberSuffix.period  // period, parenthesis, brackets
  ),
  markerHierarchy: true,  // Enable nested numbering
  items: PdfListItemCollection([
    'First item',
    'Second item',
    'Third item'
  ]),
  textIndent: 10,
  indent: 0,
  format: PdfStringFormat(lineSpacing: 10)
);

// Add sublist
orderedList.items[0].subList = PdfUnorderedList(
  marker: PdfUnorderedMarker(
    font: PdfStandardFont(PdfFontFamily.helvetica, 10),
    style: PdfUnorderedMarkerStyle.circle
  ),
  items: PdfListItemCollection([
    'Sub item 1',
    'Sub item 2'
  ]),
  indent: 20,
  textIndent: 10
);

orderedList.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height)
);
```

## Paragraph

```dart
// Create paragraph with alignment
final PdfTextElement paragraph = PdfTextElement(
  text: 'This is a paragraph of text that will be formatted with proper line spacing and alignment.',
  font: PdfStandardFont(PdfFontFamily.helvetica, 11),
  brush: PdfSolidBrush(PdfColor(50, 50, 50)),
  format: PdfStringFormat(
    alignment: PdfTextAlignment.justify,
    lineSpacing: 3,
    firstLineIndent: 20
  )
);

paragraph.draw(
  page: page,
  bounds: Rect.fromLTWH(50, 50, 400, 200)
);
```

## Text Measurement

```dart
final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

// Measure string width
double width = font.measureString('Hello World');

// Measure string with format
final Size size = font.measureString(
  'Hello World',
  format: PdfStringFormat(scaling: 150)
);

// Get font height
double height = font.height;

// Get font descent
double descent = font.descent;