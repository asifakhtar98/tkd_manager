---
name: syncfusion_flutter_pdfviewer
description: >
  Use this skill whenever the user wants to display, interact with, or integrate
  PDF documents in a Flutter app using the syncfusion_flutter_pdfviewer package.
  Trigger for any mention of: SfPdfViewer, PDF viewer in Flutter, loading PDFs
  from network/asset/file/memory, PDF text search, text selection, bookmarks,
  annotations, form filling, page navigation, or password-protected PDFs. Also
  trigger when the user asks how to customize, control, or extend a PDF viewer
  widget in Flutter — even if they don't mention "Syncfusion" by name.
---

# syncfusion_flutter_pdfviewer Skill

Helps you build feature-rich PDF viewing experiences in Flutter using
`syncfusion_flutter_pdfviewer` (commercial package — requires a Syncfusion
license or free Community license).

**Supported platforms:** Android, iOS, Web, Windows, macOS, Linux

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  syncfusion_flutter_pdfviewer: ^32.2.4
```

```dart
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
```

### Web — required extra step

Add to `web/index.html` inside `<body>`:

```html
<!-- pdf.js v4+ -->
<script type="module" async>
  import * as pdfjsLib from 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/4.9.155/pdf.min.mjs';
  pdfjsLib.GlobalWorkerOptions.workerSrc =
    "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/4.9.155/pdf.worker.min.mjs";
</script>
```

---

## Loading a PDF

| Source       | Constructor                                 |
| ------------ | ------------------------------------------- |
| Network URL  | `SfPdfViewer.network(url)`                  |
| Asset file   | `SfPdfViewer.asset('assets/file.pdf')`      |
| Device file  | `SfPdfViewer.file(File(path))`              |
| Memory bytes | `SfPdfViewer.memory(Uint8List bytes)`       |
| Encrypted    | Add `password: 'secret'` to any constructor |

```dart
// Network
SfPdfViewer.network(
  'https://example.com/doc.pdf',
  password: 'optional_password',
)

// Asset (declare in pubspec.yaml assets section)
SfPdfViewer.asset('assets/sample.pdf')

// File
SfPdfViewer.file(File('/storage/emulated/0/Download/sample.pdf'))

// Memory (e.g. from API response bytes)
SfPdfViewer.memory(uint8ListBytes)
```

---

## Programmatic Control — PdfViewerController

```dart
final PdfViewerController _controller = PdfViewerController();

SfPdfViewer.network(
  'https://example.com/doc.pdf',
  controller: _controller,
)

// Navigation
_controller.nextPage();
_controller.previousPage();
_controller.jumpToPage(5);
_controller.firstPage();
_controller.lastPage();

// Zoom
_controller.zoomLevel = 2.0;

// Text search
PdfTextSearchResult result = _controller.searchText(
  'flutter',
  searchOption: TextSearchOption.caseSensitive,
);
result.nextInstance();
result.previousInstance();
result.clear();
```

---

## Key Properties

```dart
SfPdfViewer.network(
  url,
  controller: _controller,

  // Layout
  pageLayoutMode: PdfPageLayoutMode.continuous,  // or .single
  scrollDirection: PdfScrollDirection.horizontal, // or .vertical
  initialZoomLevel: 1.5,
  initialScrollOffset: Offset(0, 100),
  initialPageNumber: 3,
  canShowScrollHead: true,
  canShowScrollStatus: true,
  canShowPaginationDialog: true,

  // Interaction
  enableDoubleTapZooming: true,
  enableTextSelection: true,
  enableDocumentLinkAnnotation: true,
  enableHyperlinkNavigation: true,

  // Appearance
  pageSpacing: 4.0,
  canShowPageLoadingIndicator: true,
  canShowPasswordDialog: true,  // auto-prompts for encrypted PDFs

  // Callbacks
  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
    print('Pages: ${details.document.pages.count}');
  },
  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
    print('Error: ${details.error}');
  },
  onPageChanged: (PdfPageChangedDetails details) {
    print('Now on page ${details.newPageNumber}');
  },
  onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
    if (details.selectedText != null) {
      print('Selected: ${details.selectedText}');
    }
  },
  onHyperlinkClicked: (PdfHyperlinkClickedDetails details) {
    print('URL: ${details.uri}');
  },
)
```

---

## Bookmark Navigation

```dart
SfPdfViewer.network(
  url,
  controller: _controller,
  onDocumentLoaded: (details) {
    // Open the built-in bookmark panel
    _pdfViewerKey.currentState?.openBookmarkView();
  },
)

// Or navigate to a specific bookmark programmatically:
// Obtain PdfBookmark from the document's bookmarks list,
// then use controller.jumpToBookmark(bookmark)
_controller.jumpToBookmark(bookmark);
```

---

## Text Markup Annotations

```dart
// Enable annotation mode (highlight, underline, strikethrough, squiggly)
SfPdfViewer.network(
  url,
  onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
    // details.globalSelectedRegion — bounding rect for custom context menu
    // details.selectedText — selected string
  },
  // Built-in annotation toolbar is shown automatically when text is selected
  // in default interaction mode
)
```

---

## Form Filling

```dart
// Forms are interactive by default — no extra config needed.
// To save/export form data:
final List<PdfFormField> fields = _controller.getFormFields();
// iterate fields, read .value, set .value to fill programmatically

// Export to FDF/XFDF
// Use syncfusion_flutter_pdf for low-level form export if needed
```

---

## Themes & Localization

```dart
// Wrap with SfTheme for dark mode / accent colors
SfTheme(
  data: SfThemeData(
    brightness: Brightness.dark,
    pdfViewerThemeData: SfPdfViewerThemeData(
      backgroundColor: Colors.grey[900],
    ),
  ),
  child: SfPdfViewer.asset('assets/doc.pdf'),
)

// Localization — wrap MaterialApp
MaterialApp(
  localizationsDelegates: [
    SfGlobalLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [Locale('en'), Locale('ar')],
  locale: Locale('ar'),
)
```

---

## Common Patterns

### Full-screen viewer page

```dart
class PdfViewerPage extends StatelessWidget {
  final String url;
  const PdfViewerPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: SfPdfViewer.network(url),
    );
  }
}
```

### Search bar integration

```dart
class _PdfViewerState extends State<MyPdfPage> {
  final _controller = PdfViewerController();
  PdfTextSearchResult? _searchResult;

  void _search(String query) {
    _searchResult?.clear();
    _searchResult = _controller.searchText(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextField(onSubmitted: _search),
      actions: [
        IconButton(icon: const Icon(Icons.arrow_upward),
            onPressed: () => _searchResult?.previousInstance()),
        IconButton(icon: const Icon(Icons.arrow_downward),
            onPressed: () => _searchResult?.nextInstance()),
      ],
    ),
    body: SfPdfViewer.network(widget.url, controller: _controller),
  );
}
```

---

## Important Notes

- **License required**: Syncfusion commercial license or free Community license
  (≤ 5 devs, company revenue ≤ $1M USD).
- **Web**: pdf.js CDN script in `index.html` is mandatory; without it the viewer
  will be blank on web.
- **iOS**: No extra permissions needed for network PDFs. For file access,
  handle `NSPhotoLibraryUsageDescription` / storage permissions per normal
  Flutter file-picking patterns.
- **Android**: Add `INTERNET` permission to `AndroidManifest.xml` for network
  PDFs.
- Pages are rendered on demand (virtual scrolling) — do not pre-cache pages
  manually.
- Use `syncfusion_flutter_pdf` (companion package) for PDF creation,
  manipulation, or low-level form/annotation work beyond what the viewer exposes.

---

## Useful Links

- [pub.dev package](https://pub.dev/packages/syncfusion_flutter_pdfviewer)
- [User guide](https://help.syncfusion.com/flutter/pdf-viewer/overview)
- [API reference](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/)
