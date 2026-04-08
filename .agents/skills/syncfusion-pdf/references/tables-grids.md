# Tables and Grids Reference

## Basic PdfGrid

```dart
final PdfGrid grid = PdfGrid();

// Set column count
grid.columns.add(count: 3);

// Add header row
final PdfGridRow headerRow = grid.headers.add(1)[0];
headerRow.cells[0].value = 'ID';
headerRow.cells[1].value = 'Name';
headerRow.cells[2].value = 'Email';

// Style header
headerRow.style.font = PdfStandardFont(
  PdfFontFamily.helvetica,
  10,
  style: PdfFontStyle.bold
);
headerRow.style.backgroundBrush = PdfBrushes.gray;

// Add data rows
final PdfGridRow row1 = grid.rows.add();
row1.cells[0].value = '1';
row1.cells[1].value = 'John Doe';
row1.cells[2].value = 'john@example.com';

final PdfGridRow row2 = grid.rows.add();
row2.cells[0].value = '2';
row2.cells[1].value = 'Jane Smith';
row2.cells[2].value = 'jane@example.com';

// Draw grid
grid.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height)
);
```

## Grid Styling

```dart
// Grid style (applies to entire grid)
grid.style = PdfGridStyle(
  // Cell padding
  cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
  
  // Cell spacing
  cellSpacing: 2,
  
  // Border
  border: PdfBorders(
    left: PdfPen(PdfColor(0, 0, 0)),
    top: PdfPen(PdfColor(0, 0, 0)),
    right: PdfPen(PdfColor(0, 0, 0)),
    bottom: PdfPen(PdfColor(0, 0, 0))
  ),
  
  // Default cell style
  cellStyle: PdfGridCellStyle(
    font: PdfStandardFont(PdfFontFamily.helvetica, 10),
    brush: PdfBrushes.white,
    pen: PdfPen(PdfColor(0, 0, 0))
  ),
  
  // Header style
  headerStyle: PdfGridCellStyle(
    font: PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
    brush: PdfBrushes.lightGray,
    pen: PdfPen(PdfColor(0, 0, 0))
  ),
  
  // Alternate row style
  alternateRowStyle: PdfGridCellStyle(
    brush: PdfBrushes.lightYellow
  )
);
```

## Cell Styling

```dart
// Individual cell style
final PdfGridCell cell = row1.cells[0];

// Text value
cell.value = 'Cell Value';

// Font
cell.style.font = PdfStandardFont(
  PdfFontFamily.helvetica,
  12,
  style: PdfFontStyle.bold
);

// Background color
cell.style.backgroundBrush = PdfSolidBrush(PdfColor(200, 200, 200));

// Text color (via brush)
cell.style.textBrush = PdfSolidBrush(PdfColor(255, 0, 0));

// Text alignment
cell.style.stringFormat = PdfStringFormat(
  alignment: PdfTextAlignment.center,
  lineAlignment: PdfVerticalAlignment.middle
);

// Borders
cell.style.borders = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0), strokeWidth: 2),
  top: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(0, 0, 0))
);

// Padding
cell.style.cellPadding = PdfPaddings(left: 10, top: 5);
```

## Column Widths

```dart
// Set column widths
grid.columns[0].width = 50;
grid.columns[1].width = 150;
grid.columns[2].width = 200;

// Auto-fit to content
grid.columns[0].width = 100;

// Percentage-based width
grid.columns[0].width = page.getClientSize().width * 0.2;

// Allow column to stretch
grid.columns[0].format = PdfGridColumnFormat(
  widthType: PdfColumnWidthType.auto
);
```

## Row Span and Column Span

```dart
// Row span (merge vertically)
row1.cells[0].rowSpan = 2;

// Column span (merge horizontally)
row1.cells[0].columnSpan = 2;

// Cell with spans needs specific value handling
// The span creates empty cells that should be skipped
```

## Nested Tables

```dart
// Add nested grid to a cell
final PdfGrid nestedGrid = PdfGrid();
nestedGrid.columns.add(count: 2);
final PdfGridRow nestedRow = nestedGrid.rows.add();
nestedRow.cells[0].value = 'Nested 1';
nestedRow.cells[1].value = 'Nested 2';

row1.cells[1].value = nestedGrid;
row1.cells[1].style.isNested = true;
```

## Drawing Options

```dart
// Draw with specific bounds
grid.draw(
  page: page,
  bounds: Rect.fromLTWH(50, 50, 400, 300)
);

// Draw with layout format
grid.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
  format: PdfLayoutFormat(
    layoutType: PdfLayoutType.paginate,  // Paginate if exceeds page
    breakType: PdfLayoutBreakType.fitElement
  )
);

// Get layout result
final PdfLayoutResult? result = grid.draw(
  page: page,
  bounds: const Rect.fromLTWH(0, 0, 500, 500)
);

if (result != null) {
  print('Grid bounds: ${result.bounds}');
  print('Page: ${result.page}');
}
```

## Cell Images

```dart
// Add image to cell
final PdfBitmap image = PdfBitmap(File('logo.png').readAsBytesSync());

row1.cells[0].value = image;

// Image size in cell
row1.cells[0].imageLayout = true;
row1.cells[0].imageAlignment = PdfImageAlignment.fit;

// Image in cell with stretch
row1.cells[0].imageLayout = true;
row1.cells[0].imageStretch = PdfImageStretch.fit;
```

## Cell Events

```dart
// Begin cell layout event
grid.beginCellLayout = (sender, args) {
  // args contains row index, column index, bounds, etc.
  if (args.rowIndex == 0) {
    // Style header cells
    args.style.backgroundBrush = PdfBrushes.gray;
  }
};

// End cell layout event
grid.endCellLayout = (sender, args) {
  print('Cell drawn at ${args.bounds}');
};
```

## Automatic Pagination

```dart
// Draw grid that paginates across pages
final PdfLayoutResult result = grid.draw(
  page: page,
  bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
  format: PdfLayoutFormat(
    layoutType: PdfLayoutType.paginate,
    breakType: PdfLayoutBreakType.fitElement
  )
)!;

// If grid spans multiple pages, continue drawing
if (!result.isLastLine) {
  final PdfPage nextPage = document.pages.add();
  grid.draw(
    page: nextPage,
    bounds: Rect.fromLTWH(0, 0, nextPage.getClientSize().width, nextPage.getClientSize().height),
    format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate)
  );
}
```

## Header Repeat on New Pages

```dart
// Enable header repeat
grid.repeatHeader = true;

// Custom header rows (first N rows)
grid.headers = 2;  // Repeat first 2 rows
```

## Cell Text Wrapping

```dart
// Enable text wrap in cells
cell.style.stringFormat = PdfStringFormat(
  wordWrap: PdfWordWrapType.word
);

// Set cell height to accommodate wrapped text
row.style = PdfGridRowStyle(
  height: 40
);
```