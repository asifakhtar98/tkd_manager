# PDF Forms Reference

## Creating Forms

```dart
final PdfDocument document = PdfDocument();

// Create page
final PdfPage page = document.pages.add();

// Create form
final PdfForm form = document.form;
```

## Text Fields

### Create TextBox

```dart
// Simple text box
final PdfTextBoxField textBox = PdfTextBoxField(
  page,
  'name',
  Rect.fromLTWH(0, 0, 200, 20)
);
textBox.text = 'Default Value';
textBox.font = PdfStandardFont(PdfFontFamily.helvetica, 12);

document.form.fields.add(textBox);

// Text box with additional properties
final PdfTextBoxField fullNameField = PdfTextBoxField(
  page,
  'fullname',
  Rect.fromLTWH(0, 30, 300, 25)
);
fullNameField.text = '';
fullNameField.maxLength = 50;
fullNameField.font = PdfStandardFont(PdfFontFamily.helvetica, 11);
fullNameField.borderStyle = PdfBorderStyle.beveled;
fullNameField.borderColor = PdfColor(100, 100, 100);
fullNameField.fillColor = PdfColor(255, 255, 240);
fullNameField.textAlignment = PdfTextAlignment.left;
fullNameField.placeholderText = 'Enter your name';

document.form.fields.add(fullNameField);

// Password field
final PdfTextBoxField passwordField = PdfTextBoxField(
  page,
  'password',
  Rect.fromLTWH(0, 60, 200, 20)
);
passwordField.passwordMode = true;

document.form.fields.add(passwordField);

// Multi-line text area
final PdfTextBoxField notesField = PdfTextBoxField(
  page,
  'notes',
  Rect.fromLTWH(0, 90, 300, 80)
);
notesField.multiLine = true;
notesField.scrollable = true;

document.form.fields.add(notesField);
```

### TextBox Properties

```dart
textBox.text = 'Text value';
textBox.maxLength = 100;
textBox.isReadOnly = false;
textBox.isRequired = true;
textBox.isVisible = true;
textBox.isPrint = true;
textBox.toolTip = 'Tooltip text';

// Text formatting
textBox.textAlignment = PdfTextAlignment.center;
textBox.font = PdfStandardFont(PdfFontFamily.helvetica, 12);

// Border styles
textBox.borderStyle = PdfBorderStyle.none;
textBox.borderStyle = PdfBorderStyle.solid;
textBox.borderStyle = PdfBorderStyle.beveled;
textBox.borderStyle = PdfBorderStyle.inset;
textBox.borderStyle = PdfBorderStyle.underline;

// Colors
textBox.borderColor = PdfColor(0, 0, 0);
textBox.fillColor = PdfColor(255, 255, 255);
textBox.textColor = PdfColor(0, 0, 0);
```

## Checkboxes

### Create CheckBox

```dart
// Simple checkbox
final PdfCheckBoxField checkbox = PdfCheckBoxField(
  page,
  'agree',
  Rect.fromLTWH(0, 0, 20, 20)
);
checkbox.isChecked = false;
checkbox.checkedValue = 'Yes';
checkbox.uncheckedValue = 'No';

document.form.fields.add(checkbox);

// Checkbox with label
checkbox.toolTip = 'I agree to the terms';

// Checked by default
final PdfCheckBoxField defaultCheckedBox = PdfCheckBoxField(
  page,
  'defaultchecked',
  Rect.fromLTWH(0, 30, 20, 20),
  isChecked: true
);

document.form.fields.add(defaultCheckedBox);
```

### Checkbox Properties

```dart
checkbox.isChecked = true;
checkbox.isReadOnly = false;
checkbox.isRequired = false;
checkbox.isVisible = true;
checkbox.isPrint = true;
checkbox.toolTip = 'Checkbox tooltip';

// Border
checkbox.borderStyle = PdfBorderStyle.solid;
checkbox.borderColor = PdfColor(0, 0, 0);
checkbox.fillColor = PdfColor(255, 255, 255);

// Check style
checkbox.style = PdfCheckBoxStyle.check;  // check, cross, circle, star, square
```

## Radio Buttons

### Create Radio Button

```dart
// Create radio button group
final PdfRadioButtonListField radioGroup = PdfRadioButtonListField(
  page,
  'gender',
  Rect.fromLTWH(0, 0, 300, 20)
);
radioGroup.font = PdfStandardFont(PdfFontFamily.helvetica, 10);

// Add items
final PdfRadioButtonListItem maleItem = PdfRadioButtonListItem(
  'Male',
  Rect.fromLTWH(0, 0, 50, 20)
);
maleItem.bounds = Rect.fromLTWH(0, 0, 50, 20);

final PdfRadioButtonListItem femaleItem = PdfRadioButtonListItem(
  'Female',
  Rect.fromLTWH(60, 0, 50, 20)
);
femaleItem.bounds = Rect.fromLTWH(60, 0, 50, 20);

radioGroup.items.add(maleItem);
radioGroup.items.add(femaleItem);

// Select default
radioGroup.selectedIndex = 0;

document.form.fields.add(radioGroup);
```

### RadioButton Properties

```dart
radioGroup.selectedIndex = 0;  // By index
radioGroup.selectedValue = 'Male';  // By value

// Get selected
int index = radioGroup.selectedIndex;
String? value = radioGroup.selectedValue;

radioGroup.isReadOnly = false;
radioGroup.isRequired = true;
radioGroup.isVisible = true;
```

## Combo Boxes (Dropdowns)

### Create ComboBox

```dart
final PdfComboBoxField comboBox = PdfComboBoxField(
  page,
  'country',
  Rect.fromLTWH(0, 0, 200, 20)
);
comboBox.font = PdfStandardFont(PdfFontFamily.helvetica, 10);

// Add items
comboBox.items.add(PdfListFieldItem('USA', 'USA'));
comboBox.items.add(PdfListFieldItem('Canada', 'Canada'));
comboBox.items.add(PdfListFieldItem('UK', 'UK'));
comboBox.items.add(PdfListFieldItem('Germany', 'Germany'));

// Set default selection
comboBox.selectedIndex = 0;

// Editable combo
comboBox.editable = true;

document.form.fields.add(comboBox);
```

### ComboBox Properties

```dart
comboBox.selectedIndex = 2;
comboBox.selectedValue = 'UK';
comboBox.isEditable = true;
comboBox.isReadOnly = false;
comboBox.isRequired = false;
comboBox.isVisible = true;

// Get all items
for (final item in comboBox.items) {
  print('${item.text} - ${item.value}');
}
```

## Buttons

### Create Button

```dart
final PdfButtonField button = PdfButtonField(
  page,
  'submit',
  Rect.fromLTWH(0, 0, 100, 30)
);
button.text = 'Submit';
button.font = PdfStandardFont(PdfFontFamily.helvetica, 10);

// Button actions
button.buttonPushAction = () {
  // This would be handled by viewer
};

button.buttonCalculateAction = (args) {
  // Calculate field value
};

// Style
button.borderStyle = PdfBorderStyle.beveled;
button.borderColor = PdfColor(100, 100, 100);
button.fillColor = PdfColor(200, 200, 200);
button.textColor = PdfColor(0, 0, 0);

document.form.fields.add(button);

// Image button
final PdfButtonField imageButton = PdfButtonField(
  page,
  'imagebtn',
  Rect.fromLTWH(110, 0, 80, 30)
);
imageButton.image = PdfBitmap(File('button.png').readAsBytesSync());
imageButton.imageAlignment = PdfImageAlignment.fit;

document.form.fields.add(imageButton);
```

## Form Actions

```dart
// Field actions
textBox.actions = PdfFieldActions(
  onValidate: (args) {
    // Return true to allow, false to reject
    return true;
  },
  onCalculate: (args) {
    // Calculate field value
  },
  onFormat: (args) {
    // Format field value
  }
);

// Form-level actions
form.actions = PdfFormAction(
  onSubmit: () {
    // Form submission
  },
  onReset: () {
    // Form reset
  }
);
```

## Form Filling

### Load and Fill Existing Form

```dart
final PdfDocument document = PdfDocument(
  inputBytes: File('form.pdf').readAsBytesSync()
);

final PdfForm form = document.form;

// Fill text field
final PdfTextBoxField nameField = document.form.fields['name'] as PdfTextBoxField;
nameField.text = 'John Doe';

// Fill checkbox
final PdfCheckBoxField agreeField = document.form.fields['agree'] as PdfCheckBoxField;
agreeField.isChecked = true;

// Fill radio button
final PdfRadioButtonListField genderField = 
    document.form.fields['gender'] as PdfRadioButtonListField;
genderField.selectedValue = 'Male';

// Fill dropdown
final PdfComboBoxField countryField = 
    document.form.fields['country'] as PdfComboBoxField;
countryField.selectedValue = 'USA';

// Save
File('filled.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Form Flattening

```dart
// Flatten all fields (convert to static content)
final PdfDocument document = PdfDocument(
  inputBytes: File('filled_form.pdf').readAsBytesSync()
);

document.form.flattenAllFields();

// Or flatten specific field
document.form.fields['name'].flatten();

File('flattened.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Form Export/Import

```dart
// Export form data as FDF
final List<int> fdfData = document.form.exportFormData(
  PdfFormDataFormat.fdf
);
File('form.fdf').writeAsBytesSync(fdfData);

// Export as XFDF
final List<int> xfdfData = document.form.exportFormData(
  PdfFormDataFormat.xfdf
);
File('form.xfdf').writeAsBytesSync(xfdfData);

// Import form data
final PdfDocument document = PdfDocument(
  inputBytes: File('form.pdf').readAsBytesSync()
);
document.form.importFormData(File('form.fdf').readAsBytesSync());
```

## Form Field Organization

```dart
// Get all fields
final PdfFormFieldCollection fields = document.form.fields;
print('Total fields: ${fields.count}');

// Iterate fields
for (final field in fields) {
  print('Field: ${field.name}, Type: ${field.runtimeType}');
}

// Find specific field
final PdfTextBoxField? nameField = document.form.findField('name') as PdfTextBoxField?;

// Remove field
document.form.fields.remove(nameField);

// Clear all fields
document.form.fields.clear();
```

## Field Appearance

```dart
// Custom appearance for text field
final PdfTemplate template = PdfTemplate(
  width: 200,
  height: 30
);
template.graphics.drawRectangle(
  PdfPen(PdfColor(0, 0, 0)),
  PdfBrushes.white,
  const Rect.fromLTWH(0, 0, 200, 30)
);
template.graphics.drawString(
  'Custom',
  PdfStandardFont(PdfFontFamily.helvetica, 10),
  const Rect.fromLTWH(5, 5, 190, 20)
);

textBox.appearance.normal = template;
```