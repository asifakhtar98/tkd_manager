# Security Reference

## Encryption

### Basic Encryption (Password Protection)

```dart
final PdfDocument document = PdfDocument();

// Add content
document.pages.add().graphics.drawString(
  'Protected Document',
  PdfStandardFont(PdfFontFamily.helvetica, 12)
);

// Set up security
final PdfSecurity security = document.security;

// Set passwords
security.userPassword = 'user123';      // Required to open
security.ownerPassword = 'owner123';     // Full access

// Set encryption algorithm
security.algorithm = PdfEncryptionAlgorithm.aes256Bit;

// Save
File('encrypted.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Encryption Algorithms

```dart
// 40-bit RC4
security.algorithm = PdfEncryptionAlgorithm.rc440Bit;

// 128-bit RC4
security.algorithm = PdfEncryptionAlgorithm.rc4128Bit;

// 128-bit AES
security.algorithm = PdfEncryptionAlgorithm.aes128Bit;

// 256-bit AES (recommended)
security.algorithm = PdfEncryptionAlgorithm.aes256Bit;

// 256-bit AES Revision 6 (PDF 2.0)
security.algorithm = PdfEncryptionAlgorithm.aes256BitRevision6;
```

### Permission Settings

```dart
final PdfSecurity security = document.security;

// Set permissions (what users can do)
security.permissions = PdfPermissions(
  printing: PdfPermissionFlags.highResolution,  // highResolution, lowResolution, notAllowed
  editing: PdfPermissionFlags.assembly,        // assembly, modification, notAllowed
  copying: PdfPermissionFlags.accessibility,   // accessibility, notAllowed
  annotation: PdfPermissionFlags.default,      // default, notAllowed
  filling: PdfPermissionFlags.default,          // default, notAllowed
);

// Or use preset permissions
security.permissions = PdfPermissions(
  printing: PdfPermissionFlags.highResolution,
  editing: PdfPermissionFlags.notAllowed,
  copying: PdfPermissionFlags.notAllowed,
  annotation: PdfPermissionFlags.notAllowed,
  filling: PdfPermissionFlags.notAllowed
);
```

### Encrypt Existing PDF

```dart
// Load existing PDF
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Add encryption
document.security.userPassword = 'password';
document.security.algorithm = PdfEncryptionAlgorithm.aes256Bit;
document.security.permissions = PdfPermissions(
  printing: PdfPermissionFlags.highResolution,
  editing: PdfPermissionFlags.notAllowed
);

// Save encrypted
File('encrypted.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Decryption

```dart
// Load encrypted PDF
final PdfDocument document = PdfDocument(
  inputBytes: File('encrypted.pdf').readAsBytesSync(),
  password: 'user123'  // Provide password
);

// Or use owner password for full access
final PdfDocument document = PdfDocument(
  inputBytes: File('encrypted.pdf').readAsBytesSync(),
  password: 'owner123'
);

// Remove encryption
document.security.userPassword = '';
document.security.ownerPassword = '';
document.security.algorithm = PdfEncryptionAlgorithm.none;

// Save as plain PDF
File('decrypted.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Digital Signatures

### Creating a Signature

```dart
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Create document
final PdfDocument document = PdfDocument();
final PdfPage page = document.pages.add();

// Create signature field
final PdfSignatureField signatureField = PdfSignatureField(
  page,
  'signature',
  bounds: Rect.fromLTWH(0, 0, 200, 50)
);

// Create certificate from PFX file
final PdfCertificate certificate = PdfCertificate(
  File('certificate.pfx').readAsBytesSync(),
  'password123'  // Certificate password
);

// Create signature
final PdfSignature signature = PdfSignature(
  certificate: certificate,
  contactInfo: 'signer@example.com',
  location: 'Location',
  reason: 'Document signing',
  date: DateTime.now()
);

// Add signature to field
signatureField.signature = signature;

// Add field to form
document.form.fields.add(signatureField);

// Save
File('signed.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Signature Properties

```dart
final PdfSignature signature = PdfSignature(
  certificate: certificate,
  
  // Optional information
  contactInfo: 'email@example.com',
  location: 'City, Country',
  reason: 'Approval',
  date: DateTime.now(),
  
  // Image (optional)
  // signatureImage: PdfBitmap(signatureImageBytes),
  
  // Hash algorithm
  hashAlgorithm: PdfHashAlgorithm.sha256,
  
  // Cryptographic standards
  cryptographicStandard: PdfCryptographicStandard.rsa
);
```

### Adding Signature to Existing PDF

```dart
// Load existing PDF
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Add signature field
final PdfPage page = document.pages[0];
final PdfSignatureField signatureField = PdfSignatureField(
  page,
  'signature',
  bounds: Rect.fromLTWH(100, 400, 200, 50)
);

signatureField.signature = PdfSignature(
  certificate: PdfCertificate(
    File('certificate.pfx').readAsBytesSync(),
    'password123'
  ),
  reason: 'Signing',
  location: 'Server',
  contactInfo: 'admin@example.com'
);

document.form.fields.add(signatureField);

File('signed.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

### Multiple Signatures

```dart
// Add multiple signature fields to same or different pages
final PdfPage page1 = document.pages[0];
final PdfPage page2 = document.pages.add();

final PdfSignatureField sig1 = PdfSignatureField(
  page1,
  'signature1',
  bounds: Rect.fromLTWH(0, 0, 200, 50)
);
sig1.signature = PdfSignature(
  certificate: PdfCertificate(File('cert1.pfx').readAsBytesSync(), 'pass1')
);
document.form.fields.add(sig1);

final PdfSignatureField sig2 = PdfSignatureField(
  page2,
  'signature2',
  bounds: Rect.fromLTWH(0, 0, 200, 50)
);
sig2.signature = PdfSignature(
  certificate: PdfCertificate(File('cert2.pfx').readAsBytesSync(), 'pass2')
);
document.form.fields.add(sig2);
```

### External Signing (Custom Signer)

```dart
// Implement IPdfExternalSigner
class CustomSigner implements IPdfExternalSigner {
  @override
  Uint8List sign(Uint8List data) {
    // Custom signing logic
    // Return signed data
    return customSign(data);
  }
  
  @override
  String get algorithm => 'RSA';
}

// Use external signer
final PdfSignature signature = PdfSignature(
  certificate: certificate,
  externalSigner: CustomSigner()
);

signatureField.signature = signature;
```

## Redaction (Removing Content)

```dart
// Load document
final PdfDocument document = PdfDocument(
  inputBytes: File('input.pdf').readAsBytesSync()
);

// Find and remove sensitive text
final PdfTextExtractor extractor = PdfTextExtractor(document);
final List<MatchedItem> matches = extractor.findText(['SSN', 'password']);

for (final match in matches) {
  // Get page and bounds
  final PdfPage page = document.pages[match.pageIndex];
  
  // Add redaction annotation (visual only)
  page.annotations.add(PdfRectangleAnnotation(
    match.bounds,
    '',
    color: PdfColor(0, 0, 0),
    setAppearance: true
  ));
}

// Flatten to remove underlying content
document.form.flattenAllFields();

// Redact annotations (remove content under annotation)
for (final page in document.pages) {
  for (final annotation in page.annotations) {
    if (annotation is PdfRedactionAnnotation) {
      annotation.redact();
    }
  }
}

File('redacted.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

## Certificate Management

```dart
// Load certificate from file
final PdfCertificate cert = PdfCertificate(
  File('certificate.pfx').readAsBytesSync(),
  'password'
);

// Get certificate info
String subject = cert.subject;
String issuer = cert.issuer;
DateTime validFrom = cert.validFrom;
DateTime validTo = cert.validTo;

// Get public key info
BigInt publicKey = cert.publicKey;

// Verify certificate
bool isValid = cert.isValid();

// Create self-signed certificate (for testing)
final PdfCertificate selfSigned = PdfCertificate(
  Uint8List.fromList([...]),  // Generate or use existing
  'password'
);
```