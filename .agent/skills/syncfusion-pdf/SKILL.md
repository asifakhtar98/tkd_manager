---
name: syncfusion-pdf
description: Create, read, edit, and secure PDF documents in Flutter using Syncfusion Flutter PDF library. Use when generating PDF reports, invoices, forms, or manipulating existing PDF documents.
---

# Syncfusion Flutter PDF Skill

Create, read, edit, and secure PDF documents in Flutter applications.

## Quick Reference

| Task | Class/Method |
|------|--------------|
| Create new PDF | `PdfDocument()` |
| Add page | `document.pages.add()` |
| Draw text | `page.graphics.drawString()` |
| Draw image | `page.graphics.drawImage(PdfBitmap(...))` |
| Create table | `PdfGrid` |
| Create form | `document.form.fields.add()` |
| Encrypt PDF | `document.security.algorithm = PdfEncryptionAlgorithm.aes256Bit` |
| Save PDF | `document.save()` |
| Load PDF | `PdfDocument(inputBytes: ...)` |

## Installation

```yaml
dependencies:
  syncfusion_flutter_pdf: ^33.1.45
  path_provider: ^2.1.0
```

## Import

```dart
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
```

## Document Lifecycle

```dart
// Create new document
final PdfDocument document = PdfDocument();

// Add pages and content
final PdfPage page = document.pages.add();
page.graphics.drawString('Hello World', PdfStandardFont(PdfFontFamily.helvetica, 12));

// Save to bytes
final List<int> bytes = await document.save();

// Save to file
File('output.pdf').writeAsBytesSync(bytes);

// Dispose when done
document.dispose();
```

## References

- [document-creation.md](references/document-creation.md) - Creating PDFs from scratch, pages, basic structure
- [text-formatting.md](references/text-formatting.md) - Fonts, text formatting, flow layout, lists
- [images-shapes.md](references/images-shapes.md) - Images, shapes, graphics, colors
- [tables-grids.md](references/tables-grids.md) - PDF tables, grids, cell styling
- [forms.md](references/forms.md) - PDF forms, text fields, checkboxes, buttons
- [security.md](references/security.md) - Encryption, decryption, digital signatures
- [modification.md](references/modification.md) - Load, modify, extract from existing PDFs
- [annotations.md](references/annotations.md) - Bookmarks, annotations, links
- [conformance.md](references/conformance.md) - PDF/A conformance levels
- [advanced-features.md](references/advanced-features.md) - Templates, headers, footers, automatic fields