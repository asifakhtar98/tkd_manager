import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/invoice_data_entity.dart';

/// Predefined SaaS access plans for tournament software.
class _PredefinedSaasItem {
  final String title;
  final String description;
  final double rate;

  const _PredefinedSaasItem({
    required this.title,
    required this.description,
    required this.rate,
  });
}

const List<_PredefinedSaasItem> _saasPlansAvailable = [
  _PredefinedSaasItem(
    title: '3 Days License',
    description: 'TKD Manager SaaS Software activation (3 days access period)',
    rate: 2800,
  ),
  _PredefinedSaasItem(
    title: '7 Days License',
    description: 'TKD Manager SaaS Software activation (7 days access period)',
    rate: 5600,
  ),
  _PredefinedSaasItem(
    title: '15 Days License',
    description: 'TKD Manager SaaS Software activation (15 days access period)',
    rate: 10200,
  ),
  _PredefinedSaasItem(
    title: '1 Month License',
    description: 'SaaS Software activation for 30 days (Bulk discount)',
    rate: 18000,
  ),
];

class InvoiceGeneratorScreen extends StatefulWidget {
  const InvoiceGeneratorScreen({super.key});

  @override
  State<InvoiceGeneratorScreen> createState() => _InvoiceGeneratorScreenState();
}

class _InvoiceGeneratorScreenState extends State<InvoiceGeneratorScreen> {
  final GlobalKey<FormState> _invoiceFormIdentifierKey = GlobalKey<FormState>();

  final TextEditingController _companyNameInputController =
      TextEditingController(text: 'Asif Akhtar (Indie Softwares)');
  final TextEditingController _companyAddressLine1InputController =
      TextEditingController(text: 'Rohini, Delhi');
  final TextEditingController _companyAddressLine2InputController =
      TextEditingController(text: 'Delhi NCR, India 110089');
  final TextEditingController _companyPanInputController =
      TextEditingController(text: 'CWKPA1964R');
  final TextEditingController _companyEmailInputController =
      TextEditingController(text: 'asifakhtar91298.personal@gmail.com');
  final TextEditingController _companyPhoneInputController =
      TextEditingController(text: '+917002689673');
  Uint8List? _uploadedCompanyLogoBytes;

  final TextEditingController _clientOrgNameInputController =
      TextEditingController();
  final TextEditingController _clientAddr1InputController =
      TextEditingController();
  final TextEditingController _clientAddr2InputController =
      TextEditingController();
  final TextEditingController _clientGstInputController =
      TextEditingController();
  final TextEditingController _clientContactNameInputController =
      TextEditingController();
  final TextEditingController _clientContactEmailInputController =
      TextEditingController();

  final TextEditingController _bankNameInputController =
      TextEditingController();
  final TextEditingController _accHolderNameInputController =
      TextEditingController();
  final TextEditingController _accNumberInputController =
      TextEditingController();
  final TextEditingController _ifscCodeInputController =
      TextEditingController();
  final TextEditingController _branchNameInputController =
      TextEditingController();
  final TextEditingController _upiIdInputController = TextEditingController();
  final TextEditingController _paymentModeInputController =
      TextEditingController(text: 'UPI');
  final TextEditingController _txRefIdInputController = TextEditingController();
  DateTime? _selectedPaymentDate;

  final TextEditingController _invoiceTitleInputController =
      TextEditingController(text: 'INVOICE');
  final TextEditingController _invoiceNumberInputController =
      TextEditingController();
  final TextEditingController _invoiceRefNoInputController =
      TextEditingController();
  DateTime _selectedIssueDate = DateTime.now();
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 15));
  String _selectedCurrency = 'INR ';
  bool _isFullyPaid = false;
  bool _isRoundingEnabled = true;
  final TextEditingController _taxLabelInputController = TextEditingController(
    text: 'GST',
  );
  final TextEditingController _taxPercentageInputController =
      TextEditingController(text: '0');
  final TextEditingController _paymentInstructionsInputController =
      TextEditingController();

  final List<_InvoiceLineItemControllers> _lineItemControllersList = [];
  final TextEditingController _termsAndNotesInputController =
      TextEditingController(text: 'Payment due within 3 days.');
  final TextEditingController
  _legalDeclarationInputController = TextEditingController(
    text:
        'Supplier is not registered under GST. No GST charged under threshold exemption.',
  );
  bool _includeSignatureBlocks = true;
  final TextEditingController _signatoryNameInputController =
      TextEditingController(text: 'Asif Akhtar');
  bool _showComputerNotice = true;

  @override
  void initState() {
    super.initState();
    _invoiceNumberInputController.text =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _selectedPaymentDate = DateTime.now();
    _addNewLineItem();
  }

  @override
  void dispose() {
    _companyNameInputController.dispose();
    _companyAddressLine1InputController.dispose();
    _companyAddressLine2InputController.dispose();
    _companyPanInputController.dispose();
    _companyEmailInputController.dispose();
    _companyPhoneInputController.dispose();
    _clientOrgNameInputController.dispose();
    _clientAddr1InputController.dispose();
    _clientAddr2InputController.dispose();
    _clientGstInputController.dispose();
    _clientContactNameInputController.dispose();
    _clientContactEmailInputController.dispose();
    _bankNameInputController.dispose();
    _accHolderNameInputController.dispose();
    _accNumberInputController.dispose();
    _ifscCodeInputController.dispose();
    _branchNameInputController.dispose();
    _paymentModeInputController.dispose();
    _txRefIdInputController.dispose();
    _upiIdInputController.dispose();
    _invoiceTitleInputController.dispose();
    _invoiceNumberInputController.dispose();
    _invoiceRefNoInputController.dispose();
    _termsAndNotesInputController.dispose();
    _legalDeclarationInputController.dispose();
    _signatoryNameInputController.dispose();
    for (final c in _lineItemControllersList) {
      c.disposeControllers();
    }
    super.dispose();
  }

  void _addNewLineItem([_PredefinedSaasItem? preset]) {
    setState(() {
      if (preset != null && _lineItemControllersList.length == 1) {
        final first = _lineItemControllersList.first;
        if (first.itemNameController.text.isEmpty &&
            first.rateController.text == '0.00') {
          first.itemNameController.text = preset.title;
          first.itemDescriptionController.text = preset.description;
          first.quantityController.text = '1';
          first.rateController.text = preset.rate.toStringAsFixed(2);
          return;
        }
      }
      _lineItemControllersList.add(
        _InvoiceLineItemControllers(
          onValuesChanged: () => setState(() {}),
          preset: preset,
        ),
      );
    });
  }

  void _removeLineItem(int index) {
    if (_lineItemControllersList.length > 1) {
      setState(() {
        _lineItemControllersList.removeAt(index).disposeControllers();
      });
    }
  }

  double _calculateRoundingAmount() {
    if (!_isRoundingEnabled) return 0.0;
    double total = 0.0;
    for (final c in _lineItemControllersList) {
      final q = int.tryParse(c.quantityController.text) ?? 0;
      final r = double.tryParse(c.rateController.text) ?? 0.0;
      total += q * r;
    }
    return total.roundToDouble() - total;
  }

  InvoiceDataEntity _compileData() {
    return InvoiceDataEntity(
      companyDetails: CompanyDetailsEntity(
        companyName: _companyNameInputController.text,
        companyAddressLine1: _companyAddressLine1InputController.text,
        companyAddressLine2: _companyAddressLine2InputController.text,
        companyTaxIdentificationNumber: _companyPanInputController.text,
        companyEmail: _companyEmailInputController.text,
        companyPhone: _companyPhoneInputController.text,
        companyLogoBytes: _uploadedCompanyLogoBytes,
      ),
      clientDetails: ClientDetailsEntity(
        clientOrganizationName: _clientOrgNameInputController.text,
        clientAddressLine1: _clientAddr1InputController.text,
        clientAddressLine2: _clientAddr2InputController.text,
        clientTaxIdentificationNumber: _clientGstInputController.text,
        clientContactPerson: _clientContactNameInputController.text,
        clientContactEmail: _clientContactEmailInputController.text,
      ),
      invoiceTitle: _invoiceTitleInputController.text,
      invoiceDocumentNumber: _invoiceNumberInputController.text,
      invoiceReferenceNumber: _invoiceRefNoInputController.text,
      invoiceIssueDate: _selectedIssueDate,
      invoiceDueDate: _selectedDueDate,
      invoiceCurrencySymbol: _selectedCurrency,
      invoiceLineItems: _lineItemControllersList
          .map(
            (c) => InvoiceItemEntity(
              itemName: c.itemNameController.text,
              itemDescription: c.itemDescriptionController.text,
              itemQuantity: int.tryParse(c.quantityController.text) ?? 1,
              itemRateAmount: double.tryParse(c.rateController.text) ?? 0.0,
            ),
          )
          .toList(),
      invoiceAppliedTaxes: [
        InvoiceTaxEntity(
          taxLabelName: _taxLabelInputController.text,
          taxPercentageValue:
              double.tryParse(_taxPercentageInputController.text) ?? 0.0,
        ),
      ],
      invoiceTermsAndConditionsText: _termsAndNotesInputController.text,
      invoicePaymentInstructionsText: _paymentInstructionsInputController.text,
      isFullyPaid: _isFullyPaid,
      includeSignaturePlaceholder: _includeSignatureBlocks,
      signatoryName: _signatoryNameInputController.text,
      paymentMode: _paymentModeInputController.text,
      transactionReferenceId: _txRefIdInputController.text,
      paymentDate: _selectedPaymentDate,
      legalDeclarationText: _legalDeclarationInputController.text,
      isComputerGeneratedNotice: _showComputerNotice,
      bankDetails: BankDetailsEntity(
        bankName: _bankNameInputController.text,
        accountHolderName: _accHolderNameInputController.text,
        accountNumber: _accNumberInputController.text,
        ifscCode: _ifscCodeInputController.text,
        branchName: _branchNameInputController.text,
        upiId: _upiIdInputController.text,
      ),
      roundingAmount: _calculateRoundingAmount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1000;
    final data = _compileData();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Invoice Generator'),
        actions: [
          TextButton.icon(
            onPressed: () => _exportPdf(context, data),
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text(
              'Export PDF',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 2, child: _buildEditor(context)),
                const VerticalDivider(width: 1),
                Expanded(flex: 3, child: _buildPreview(data)),
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildEditor(context)),
                const Divider(height: 1),
                Expanded(child: _buildPreview(data)),
              ],
            ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    return Form(
      key: _invoiceFormIdentifierKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionTitle('Seller Details (Your Info)'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _StylizedInput(
                      controller: _companyNameInputController,
                      label: 'Business Name',
                      onChanged: (v) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    _StylizedInput(
                      controller: _companyPanInputController,
                      label: 'PAN Number (Non-GST Requirement)',
                      onChanged: (v) => setState(() {}),
                      isPan: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _LogoPicker(
                bytes: _uploadedCompanyLogoBytes,
                onPicked: (b) => setState(() => _uploadedCompanyLogoBytes = b),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _companyAddressLine1InputController,
            label: 'Address Line 1',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _companyAddressLine2InputController,
            label: 'City, State, Zip',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StylizedInput(
                  controller: _companyEmailInputController,
                  label: 'Business Email',
                  onChanged: (v) => setState(() {}),
                  isEmail: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _companyPhoneInputController,
                  label: 'Phone Number',
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _SectionTitle('Client Details (Bill To)'),
          _StylizedInput(
            controller: _clientOrgNameInputController,
            label: 'Client Organization Name',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _clientAddr1InputController,
            label: 'Client Address Line 1',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _clientAddr2InputController,
            label: 'City, State, Zip',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StylizedInput(
                  controller: _clientGstInputController,
                  label: 'Client GSTIN (If any)',
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _clientContactNameInputController,
                  label: 'Contact Person',
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _clientContactEmailInputController,
            label: 'Client Contact Email',
            isEmail: true,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Invoice & Payment Metadata'),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _StylizedInput(
                  controller: _invoiceTitleInputController,
                  label: 'Document Title',
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _invoiceNumberInputController,
                  label: 'Invoice #',
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _invoiceRefNoInputController,
                  label: 'Reference / PO #',
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DateInputField(
                  label: 'Issue Date',
                  date: _selectedIssueDate,
                  onTap: () => _pickDate(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateInputField(
                  label: 'Due Date',
                  date: _selectedDueDate,
                  onTap: () => _pickDate(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CurrencyPicker(
            value: _selectedCurrency,
            onChanged: (v) => setState(() => _selectedCurrency = v!),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Bank Transfer Details'),
          _StylizedInput(
            controller: _bankNameInputController,
            label: 'Bank Name',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _accHolderNameInputController,
            label: 'Account Holder Name',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _branchNameInputController,
            label: 'Bank Branch Name',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _StylizedInput(
                  controller: _accNumberInputController,
                  label: 'Account Number',
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _ifscCodeInputController,
                  label: 'IFSC Code',
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _upiIdInputController,
            label: 'UPI ID (e.g., yourname@bank)',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Audit Tracking & Totals'),
          CheckboxListTile(
            title: const Text('Mark as Fully Paid'),
            subtitle: const Text('Adds a PAID badge to the PDF'),
            value: _isFullyPaid,
            activeColor: Colors.green[700],
            onChanged: (v) => setState(() => _isFullyPaid = v ?? false),
          ),
          if (_isFullyPaid) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StylizedInput(
                    controller: _paymentModeInputController,
                    label: 'Payment Mode',
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StylizedInput(
                    controller: _txRefIdInputController,
                    label: 'Tx Reference ID',
                    onChanged: (v) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DateInputField(
              label: 'Payment Date',
              date: _selectedPaymentDate,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _selectedPaymentDate = date);
                }
              },
            ),
          ],
          const SizedBox(height: 12),
          _SectionTitle('Tax Details'),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _StylizedInput(
                  controller: _taxLabelInputController,
                  label: 'Tax Name (e.g., GST / VAT)',
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StylizedInput(
                  controller: _taxPercentageInputController,
                  label: 'Tax %',
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Auto-Round Grand Total'),
            subtitle: const Text('Round total to nearest whole rupee.'),
            value: _isRoundingEnabled,
            onChanged: (v) => setState(() => _isRoundingEnabled = v),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Billable Items'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _saasPlansAvailable.map((plan) {
              return OutlinedButton.icon(
                onPressed: () => _addNewLineItem(plan),
                label: Text(
                  plan.title,
                  style: const TextStyle(color: Colors.black87),
                ),
                icon: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ..._lineItemControllersList.asMap().entries.map((e) {
            return _LineItemRow(
              index: e.key,
              controllers: e.value,
              onRemove: () => _removeLineItem(e.key),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _addNewLineItem(),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Custom Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Notes & Terms'),
          _StylizedInput(
            controller: _termsAndNotesInputController,
            label: 'Terms & Conditions / Notes',
            maxLines: 3,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _paymentInstructionsInputController,
            label: 'Payment Instructions',
            maxLines: 2,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Compliance & Signature'),
          _StylizedInput(
            controller: _legalDeclarationInputController,
            label: 'Legal Declaration',
            maxLines: 2,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _StylizedInput(
            controller: _signatoryNameInputController,
            label: 'Authorised Signatory Name',
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Include Signature Placeholder'),
            value: _includeSignatureBlocks,
            onChanged: (v) => setState(() => _includeSignatureBlocks = v),
          ),
          SwitchListTile(
            title: const Text('Show Computer Generated Notice'),
            value: _showComputerNotice,
            onChanged: (v) => setState(() => _showComputerNotice = v),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPreview(InvoiceDataEntity data) {
    return FutureBuilder<Uint8List>(
      future: _generatePdf(data),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SfPdfViewer.memory(snapshot.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Uint8List> _generatePdf(InvoiceDataEntity data) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins = PdfMargins()..all = 40;

    final DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');
    final PdfColor primaryColor = PdfColor(0, 0, 0);
    final PdfColor secondaryColor = PdfColor(96, 96, 96);
    final PdfColor accentColor = PdfColor(238, 238, 238);
    final PdfColor successColor = PdfColor(27, 94, 32);
    final PdfColor errorColor = PdfColor(183, 28, 28);
    final PdfColor whiteColor = PdfColor(255, 255, 255);
    final PdfColor lightGreenColor = PdfColor(232, 245, 233);
    final PdfColor lightRedColor = PdfColor(255, 235, 238);
    final PdfColor greyBorderColor = PdfColor(224, 224, 224);
    final PdfColor grey500Color = PdfColor(158, 158, 158);
    final PdfColor grey600Color = PdfColor(117, 117, 117);
    final PdfColor grey700Color = PdfColor(97, 97, 97);

    PdfBitmap? logoImage;
    if (data.companyDetails.companyLogoBytes != null) {
      try {
        logoImage = PdfBitmap(data.companyDetails.companyLogoBytes!);
      } catch (_) {
        logoImage = null;
      }
    }

    final PdfPage page = document.pages.add();
    final PdfGraphics pageGraphics = page.graphics;
    final Size pageSize = page.getClientSize();
    final double pageWidth = pageSize.width;
    double currentY = 0;

    final PdfPageTemplateElement headerBar = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, pageWidth + 80, 10),
    );
    headerBar.graphics.drawRectangle(
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(0, 0, pageWidth + 80, 10),
    );
    document.template.top = headerBar;

    currentY = 10;

    final double leftColumnX = 0;
    final double rightColumnX = pageWidth * 0.55;
    final double rightColumnWidth = pageWidth - rightColumnX;

    if (logoImage != null) {
      final double logoHeight = 60;
      final double logoWidth =
          logoImage.width * (logoHeight / logoImage.height);
      pageGraphics.drawImage(
        logoImage,
        Rect.fromLTWH(leftColumnX, currentY, logoWidth, logoHeight),
      );
      currentY += logoHeight + 5;
    }

    final PdfFont companyNameFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      16,
      style: PdfFontStyle.bold,
    );
    final Size companyNameSize = companyNameFont.measureString(
      data.companyDetails.companyName.toUpperCase(),
    );
    pageGraphics.drawString(
      data.companyDetails.companyName.toUpperCase(),
      companyNameFont,
      brush: PdfSolidBrush(secondaryColor),
      bounds: Rect.fromLTWH(
        leftColumnX,
        currentY,
        companyNameSize.width,
        companyNameSize.height,
      ),
    );
    currentY += companyNameSize.height + 4;

    final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    void drawLeftLine(String text) {
      final Size textSize = smallFont.measureString(text);
      pageGraphics.drawString(
        text,
        smallFont,
        bounds: Rect.fromLTWH(
          leftColumnX,
          currentY,
          textSize.width,
          textSize.height,
        ),
      );
      currentY += textSize.height + 2;
    }

    drawLeftLine(data.companyDetails.companyAddressLine1);
    drawLeftLine(data.companyDetails.companyAddressLine2);
    if (data.companyDetails.companyTaxIdentificationNumber.isNotEmpty) {
      drawLeftLine(
        'PAN: ${data.companyDetails.companyTaxIdentificationNumber}',
      );
    }
    drawLeftLine('P: ${data.companyDetails.companyPhone}');
    drawLeftLine('E: ${data.companyDetails.companyEmail}');

    double rightColumnCurrentY = 10;

    final PdfFont titleFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      32,
      style: PdfFontStyle.bold,
    );
    final String titleText = data.invoiceTitle.toUpperCase();
    final Size titleSize = titleFont.measureString(titleText);
    pageGraphics.drawString(
      titleText,
      titleFont,
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(
        rightColumnX,
        rightColumnCurrentY,
        rightColumnWidth,
        titleSize.height,
      ),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
    rightColumnCurrentY += titleSize.height + 10;

    void drawRightMetadataRow(String label, String value) {
      final PdfFont labelFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfFont valueFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );
      final Size labelSize = labelFont.measureString('$label: ');
      final Size valueSize = valueFont.measureString(value);
      final double totalWidth = labelSize.width + valueSize.width;
      final double startX = rightColumnX + rightColumnWidth - totalWidth;
      pageGraphics.drawString(
        '$label: ',
        labelFont,
        brush: PdfSolidBrush(grey700Color),
        bounds: Rect.fromLTWH(
          startX,
          rightColumnCurrentY,
          labelSize.width,
          labelSize.height,
        ),
      );
      pageGraphics.drawString(
        value,
        valueFont,
        bounds: Rect.fromLTWH(
          startX + labelSize.width,
          rightColumnCurrentY,
          valueSize.width,
          valueSize.height,
        ),
      );
      rightColumnCurrentY += max(labelSize.height, valueSize.height) + 2;
    }

    drawRightMetadataRow('Invoice #', data.invoiceDocumentNumber);
    drawRightMetadataRow('Date', dateFormatter.format(data.invoiceIssueDate));
    drawRightMetadataRow('Due Date', dateFormatter.format(data.invoiceDueDate));
    if (data.invoiceReferenceNumber.isNotEmpty) {
      drawRightMetadataRow('Ref #', data.invoiceReferenceNumber);
    }

    if (data.isFullyPaid) {
      rightColumnCurrentY += 10;
      final PdfFont badgeFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );
      const String badgeText = 'COMPLETED / PAID';
      final Size badgeSize = badgeFont.measureString(badgeText);
      const double badgePaddingH = 10;
      const double badgePaddingV = 4;
      final double badgeWidth = badgeSize.width + badgePaddingH * 2;
      final double badgeHeight = badgeSize.height + badgePaddingV * 2;
      final double badgeX = rightColumnX + rightColumnWidth - badgeWidth;
      pageGraphics.drawRectangle(
        pen: PdfPen(successColor, width: 0.5),
        brush: PdfSolidBrush(lightGreenColor),
        bounds: Rect.fromLTWH(
          badgeX,
          rightColumnCurrentY,
          badgeWidth,
          badgeHeight,
        ),
      );
      pageGraphics.drawString(
        badgeText,
        badgeFont,
        brush: PdfSolidBrush(successColor),
        bounds: Rect.fromLTWH(
          badgeX + badgePaddingH,
          rightColumnCurrentY + badgePaddingV,
          badgeSize.width,
          badgeSize.height,
        ),
      );
      rightColumnCurrentY += badgeHeight;
    }

    if (!data.isFullyPaid && data.invoiceDueDate.isBefore(DateTime.now())) {
      rightColumnCurrentY += 10;
      final PdfFont badgeFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );
      const String badgeText = 'OVERDUE';
      final Size badgeSize = badgeFont.measureString(badgeText);
      const double badgePaddingH = 10;
      const double badgePaddingV = 4;
      final double badgeWidth = badgeSize.width + badgePaddingH * 2;
      final double badgeHeight = badgeSize.height + badgePaddingV * 2;
      final double badgeX = rightColumnX + rightColumnWidth - badgeWidth;
      pageGraphics.drawRectangle(
        pen: PdfPen(errorColor, width: 0.5),
        brush: PdfSolidBrush(lightRedColor),
        bounds: Rect.fromLTWH(
          badgeX,
          rightColumnCurrentY,
          badgeWidth,
          badgeHeight,
        ),
      );
      pageGraphics.drawString(
        badgeText,
        badgeFont,
        brush: PdfSolidBrush(errorColor),
        bounds: Rect.fromLTWH(
          badgeX + badgePaddingH,
          rightColumnCurrentY + badgePaddingV,
          badgeSize.width,
          badgeSize.height,
        ),
      );
      rightColumnCurrentY += badgeHeight;
    }

    currentY = max(currentY, rightColumnCurrentY) + 40;

    final PdfFont sectionHeaderFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      8,
      style: PdfFontStyle.bold,
    );
    final PdfFont bold12Font = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      style: PdfFontStyle.bold,
    );

    pageGraphics.drawString(
      'BILL TO',
      sectionHeaderFont,
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(
        0,
        currentY,
        pageWidth,
        sectionHeaderFont.measureString('BILL TO').height,
      ),
    );
    currentY += sectionHeaderFont.measureString('BILL TO').height + 4;

    void drawClientLine(String text, {bool isBold = false}) {
      final PdfFont font = isBold ? bold12Font : smallFont;
      final Size textSize = font.measureString(text);
      pageGraphics.drawString(
        text,
        font,
        bounds: Rect.fromLTWH(0, currentY, textSize.width, textSize.height),
      );
      currentY += textSize.height + 2;
    }

    drawClientLine(data.clientDetails.clientOrganizationName, isBold: true);
    drawClientLine(data.clientDetails.clientAddressLine1);
    drawClientLine(data.clientDetails.clientAddressLine2);
    drawClientLine('E: ${data.clientDetails.clientContactEmail}');
    if (data.clientDetails.clientTaxIdentificationNumber.isNotEmpty) {
      drawClientLine(
        'GSTIN: ${data.clientDetails.clientTaxIdentificationNumber}',
      );
    }
    currentY += 4;
    drawClientLine('Contact: ${data.clientDetails.clientContactPerson}');

    currentY += 30;

    final PdfGrid lineItemsGrid = PdfGrid();
    lineItemsGrid.columns.add(count: 5);
    lineItemsGrid.columns[0].width = 25;
    lineItemsGrid.columns[1].width = pageWidth * 0.45;
    lineItemsGrid.columns[2].width = 40;
    lineItemsGrid.columns[3].width = 80;
    lineItemsGrid.columns[4].width = 80;

    final PdfGridRow headerRow = lineItemsGrid.headers.add(1)[0];
    final PdfFont headerFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      9,
      style: PdfFontStyle.bold,
    );
    headerRow.cells[0].value = '#';
    headerRow.cells[1].value = 'DESCRIPTION';
    headerRow.cells[2].value = 'QTY';
    headerRow.cells[3].value = 'RATE';
    headerRow.cells[4].value = 'AMOUNT';
    headerRow.style.font = headerFont;
    headerRow.style.textBrush = PdfSolidBrush(whiteColor);
    headerRow.style.backgroundBrush = PdfSolidBrush(primaryColor);
    headerRow.cells[2].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );
    headerRow.cells[3].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.right,
    );
    headerRow.cells[4].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.right,
    );

    for (int index = 0; index < data.invoiceLineItems.length; index++) {
      final currentLineItem = data.invoiceLineItems[index];
      final PdfGridRow currentRow = lineItemsGrid.rows.add();
      currentRow.cells[0].value = '${index + 1}';
      currentRow.cells[1].value = currentLineItem.itemName;
      currentRow.cells[2].value = '${currentLineItem.itemQuantity}';
      currentRow.cells[3].value =
          '${data.invoiceCurrencySymbol}${currentLineItem.itemRateAmount.toStringAsFixed(2)}';
      currentRow.cells[4].value =
          '${data.invoiceCurrencySymbol}${currentLineItem.calculateTotalItemAmount().toStringAsFixed(2)}';

      final PdfFont itemNameFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );
      currentRow.cells[1].style.font = itemNameFont;
      currentRow.cells[2].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
      );
      currentRow.cells[3].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.right,
      );
      currentRow.cells[4].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.right,
      );
    }

    lineItemsGrid.style.cellPadding = PdfPaddings(
      left: 8,
      top: 8,
      right: 8,
      bottom: 8,
    );
    lineItemsGrid.style.cellSpacing = 0;

    final PdfLayoutResult? gridResult = lineItemsGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 400),
    );

    currentY = gridResult != null
        ? gridResult.bounds.bottom + 20
        : currentY + 20;

    final double leftInfoColumnWidth = pageWidth * 0.6;
    final double rightSummaryColumnWidth = pageWidth - leftInfoColumnWidth;
    final double rightSummaryColumnX = leftInfoColumnWidth + 20;

    double leftInfoY = currentY;
    double rightSummaryY = currentY;

    if (data.bankDetails.hasAnyInformationalDetails) {
      pageGraphics.drawString(
        'PAYMENT INFORMATION',
        sectionHeaderFont,
        brush: PdfSolidBrush(primaryColor),
        bounds: Rect.fromLTWH(
          0,
          leftInfoY,
          leftInfoColumnWidth,
          sectionHeaderFont.measureString('PAYMENT INFORMATION').height,
        ),
      );
      leftInfoY +=
          sectionHeaderFont.measureString('PAYMENT INFORMATION').height + 6;

      void drawLabelValue(String label, String value) {
        if (value.isEmpty) return;
        final PdfFont labelFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
        final PdfFont valueFont = PdfStandardFont(
          PdfFontFamily.helvetica,
          8,
          style: PdfFontStyle.bold,
        );
        final Size labelSize = labelFont.measureString('$label: ');
        final Size valueSize = valueFont.measureString(value);
        pageGraphics.drawString(
          '$label: ',
          labelFont,
          brush: PdfSolidBrush(grey600Color),
          bounds: Rect.fromLTWH(0, leftInfoY, 80, labelSize.height),
        );
        pageGraphics.drawString(
          value,
          valueFont,
          bounds: Rect.fromLTWH(
            80,
            leftInfoY,
            valueSize.width,
            valueSize.height,
          ),
        );
        leftInfoY += max(labelSize.height, valueSize.height) + 2;
      }

      drawLabelValue('Bank Name', data.bankDetails.bankName);
      drawLabelValue('Account Name', data.bankDetails.accountHolderName);
      drawLabelValue('Account Number', data.bankDetails.accountNumber);
      drawLabelValue('IFSC Code', data.bankDetails.ifscCode);
      drawLabelValue('Branch', data.bankDetails.branchName);
      drawLabelValue('UPI ID', data.bankDetails.upiId);

      if (data.isFullyPaid) {
        if (data.paymentMode.isNotEmpty)
          drawLabelValue('Payment Mode', data.paymentMode);
        if (data.transactionReferenceId.isNotEmpty)
          drawLabelValue('Tx Ref ID', data.transactionReferenceId);
        if (data.paymentDate != null)
          drawLabelValue('Paid Date', dateFormatter.format(data.paymentDate!));
      }
      leftInfoY += 10;
    }

    if (data.invoicePaymentInstructionsText.isNotEmpty) {
      pageGraphics.drawString(
        'PAYMENT INSTRUCTIONS',
        sectionHeaderFont,
        brush: PdfSolidBrush(primaryColor),
        bounds: Rect.fromLTWH(
          0,
          leftInfoY,
          leftInfoColumnWidth,
          sectionHeaderFont.measureString('PAYMENT INSTRUCTIONS').height,
        ),
      );
      leftInfoY +=
          sectionHeaderFont.measureString('PAYMENT INSTRUCTIONS').height + 4;
      final PdfFont instructionsFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        8,
      );
      final PdfTextElement instructionsElement = PdfTextElement(
        text: data.invoicePaymentInstructionsText,
        font: instructionsFont,
        brush: PdfSolidBrush(primaryColor),
      );
      final PdfLayoutResult? instructionsResult = instructionsElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, leftInfoY, leftInfoColumnWidth, 100),
      );
      if (instructionsResult != null) {
        leftInfoY = instructionsResult.bounds.bottom + 10;
      } else {
        leftInfoY += 20;
      }
    }

    if (data.invoiceTermsAndConditionsText.isNotEmpty) {
      pageGraphics.drawString(
        'NOTES',
        sectionHeaderFont,
        brush: PdfSolidBrush(primaryColor),
        bounds: Rect.fromLTWH(
          0,
          leftInfoY,
          leftInfoColumnWidth,
          sectionHeaderFont.measureString('NOTES').height,
        ),
      );
      leftInfoY += sectionHeaderFont.measureString('NOTES').height + 4;
      final PdfFont notesFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
      final PdfTextElement notesElement = PdfTextElement(
        text: data.invoiceTermsAndConditionsText,
        font: notesFont,
        brush: PdfSolidBrush(primaryColor),
      );
      final PdfLayoutResult? notesResult = notesElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, leftInfoY, leftInfoColumnWidth, 100),
      );
      if (notesResult != null) {
        leftInfoY = notesResult.bounds.bottom;
      }
    }

    final PdfFont summaryLabelFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
    );
    final PdfFont summaryValueFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
    );
    final PdfFont boldSummaryFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );

    void drawSummaryRow(String label, String value, {bool isBold = false}) {
      final PdfFont labelFont = isBold ? boldSummaryFont : summaryLabelFont;
      final PdfFont valueFont = isBold ? boldSummaryFont : summaryValueFont;
      final Size labelSize = labelFont.measureString(label);
      final Size valueSize = valueFont.measureString(value);
      pageGraphics.drawString(
        label,
        labelFont,
        bounds: Rect.fromLTWH(
          rightSummaryColumnX,
          rightSummaryY,
          rightSummaryColumnWidth,
          labelSize.height,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
      );
      pageGraphics.drawString(
        value,
        valueFont,
        bounds: Rect.fromLTWH(
          rightSummaryColumnX,
          rightSummaryY,
          rightSummaryColumnWidth,
          valueSize.height,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
      rightSummaryY += max(labelSize.height, valueSize.height) + 2;
    }

    drawSummaryRow(
      'Subtotal',
      '${data.invoiceCurrencySymbol}${data.calculateSubTotalAmount().toStringAsFixed(2)}',
    );

    for (final currentTax in data.invoiceAppliedTaxes) {
      final double taxAmount =
          data.calculateSubTotalAmount() *
          (currentTax.taxPercentageValue / 100.0);
      if (taxAmount == 0) continue;
      drawSummaryRow(
        '${currentTax.taxLabelName} (${currentTax.taxPercentageValue}%)',
        '${data.invoiceCurrencySymbol}${taxAmount.toStringAsFixed(2)}',
      );
    }

    if (data.roundingAmount != 0) {
      final String roundingText = data.roundingAmount > 0
          ? '+${data.roundingAmount.toStringAsFixed(2)}'
          : data.roundingAmount.toStringAsFixed(2);
      drawSummaryRow('Round Off', roundingText);
    }

    pageGraphics.drawLine(
      PdfPen(greyBorderColor),
      Offset(rightSummaryColumnX, rightSummaryY),
      Offset(rightSummaryColumnX + rightSummaryColumnWidth, rightSummaryY),
    );
    rightSummaryY += 5;

    const double grandTotalPadding = 6;
    final Size grandTotalLabelSize = boldSummaryFont.measureString(
      'Grand Total',
    );
    final Size grandTotalValueSize = boldSummaryFont.measureString(
      '${data.invoiceCurrencySymbol}${data.calculateGrandTotalAmount().toStringAsFixed(2)}',
    );
    final double grandTotalRowHeight =
        max(grandTotalLabelSize.height, grandTotalValueSize.height) +
        grandTotalPadding * 2;
    pageGraphics.drawRectangle(
      brush: PdfSolidBrush(accentColor),
      bounds: Rect.fromLTWH(
        rightSummaryColumnX,
        rightSummaryY,
        rightSummaryColumnWidth,
        grandTotalRowHeight,
      ),
    );
    pageGraphics.drawString(
      'Grand Total',
      boldSummaryFont,
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(
        rightSummaryColumnX + grandTotalPadding,
        rightSummaryY + grandTotalPadding,
        rightSummaryColumnWidth,
        grandTotalLabelSize.height,
      ),
    );
    pageGraphics.drawString(
      '${data.invoiceCurrencySymbol}${data.calculateGrandTotalAmount().toStringAsFixed(2)}',
      boldSummaryFont,
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(
        rightSummaryColumnX,
        rightSummaryY + grandTotalPadding,
        rightSummaryColumnWidth,
        grandTotalValueSize.height,
      ),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
    rightSummaryY += grandTotalRowHeight + 10;

    final PdfFont wordsFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      8,
      style: PdfFontStyle.italic,
    );
    final String wordsText =
        'Total In Words: ${_NumberToWordsConverter.convert(data.calculateGrandTotalAmount())}';
    final Size wordsSize = wordsFont.measureString(wordsText);
    pageGraphics.drawString(
      wordsText,
      wordsFont,
      brush: PdfSolidBrush(grey700Color),
      bounds: Rect.fromLTWH(
        rightSummaryColumnX,
        rightSummaryY,
        rightSummaryColumnWidth,
        wordsSize.height,
      ),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    final double footerSectionY = max(leftInfoY, rightSummaryY) + 20;

    if (data.legalDeclarationText.isNotEmpty) {
      pageGraphics.drawLine(
        PdfPen(greyBorderColor, width: 2),
        Offset(0, footerSectionY),
        Offset(0, footerSectionY + 30),
      );
      final PdfFont legalFont = PdfStandardFont(PdfFontFamily.helvetica, 7);
      final PdfTextElement legalElement = PdfTextElement(
        text: data.legalDeclarationText,
        font: legalFont,
        brush: PdfSolidBrush(grey700Color),
      );
      legalElement.draw(
        page: page,
        bounds: Rect.fromLTWH(8, footerSectionY, pageWidth - 8, 30),
      );
    }

    final double signatureSectionY =
        footerSectionY + (data.legalDeclarationText.isNotEmpty ? 40 : 0);

    if (data.isComputerGeneratedNotice) {
      pageGraphics.drawString(
        'E. & O.E. | This is a computer generated document.',
        PdfStandardFont(PdfFontFamily.helvetica, 7),
        brush: PdfSolidBrush(grey500Color),
        bounds: Rect.fromLTWH(0, signatureSectionY, pageWidth * 0.5, 10),
      );
    }

    if (data.includeSignaturePlaceholder) {
      final double signatureX = pageWidth - 120;
      final PdfFont signatoryHeaderFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        8,
        style: PdfFontStyle.bold,
      );
      pageGraphics.drawString(
        'For ${data.companyDetails.companyName}',
        signatoryHeaderFont,
        bounds: Rect.fromLTWH(
          signatureX,
          signatureSectionY,
          120,
          signatoryHeaderFont
              .measureString('For ${data.companyDetails.companyName}')
              .height,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );

      final PdfFont signatoryNameFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );
      final double nameY = signatureSectionY + 30;
      pageGraphics.drawString(
        data.signatoryName,
        signatoryNameFont,
        bounds: Rect.fromLTWH(
          signatureX,
          nameY,
          120,
          signatoryNameFont.measureString(data.signatoryName).height,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );

      pageGraphics.drawLine(
        PdfPen(secondaryColor),
        Offset(
          signatureX,
          nameY +
              signatoryNameFont.measureString(data.signatoryName).height +
              5,
        ),
        Offset(
          signatureX + 120,
          nameY +
              signatoryNameFont.measureString(data.signatoryName).height +
              5,
        ),
      );

      pageGraphics.drawString(
        'Authorised Signatory',
        PdfStandardFont(PdfFontFamily.helvetica, 7),
        bounds: Rect.fromLTWH(
          signatureX,
          nameY +
              signatoryNameFont.measureString(data.signatoryName).height +
              8,
          120,
          10,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  void _pickDate(bool issue) async {
    final d = await showDatePicker(
      context: context,
      initialDate: issue ? _selectedIssueDate : _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() => issue ? _selectedIssueDate = d : _selectedDueDate = d);
  }

  Future<void> _exportPdf(BuildContext context, InvoiceDataEntity data) async {
    final bytes = await _generatePdf(data);
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
      name: '${data.invoiceDocumentNumber}.pdf',
    );
  }
}

// Support Widgets (Private)

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _StylizedInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool isEmail;
  final bool isPan;
  final bool isNumeric;
  final ValueChanged<String>? onChanged;

  const _StylizedInput({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.isEmail = false,
    this.isPan = false,
    this.isNumeric = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      keyboardType: isNumeric
          ? TextInputType.numberWithOptions(decimal: true)
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return null;
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v))
          return 'Invalid Email';
        if (isPan && !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(v))
          return 'Invalid PAN Format';
        return null;
      },
    );
  }
}

class _DateInputField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateInputField({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          date != null ? DateFormat.yMMMd().format(date!) : 'Select Date',
        ),
      ),
    );
  }
}

class _CurrencyPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _CurrencyPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: const [
        DropdownMenuItem(value: 'INR ', child: Text('Indian Rupee (INR)')),
        DropdownMenuItem(value: 'USD ', child: Text('US Dollar (USD)')),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _LogoPicker extends StatelessWidget {
  final Uint8List? bytes;
  final ValueChanged<Uint8List?> onPicked;
  const _LogoPicker({this.bytes, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: bytes != null
              ? Image.memory(bytes!, fit: BoxFit.contain)
              : const Icon(Icons.business_center),
        ),
        TextButton(onPressed: _pick, child: const Text('Logo')),
      ],
    );
  }

  void _pick() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (res != null) onPicked(res.files.single.bytes);
  }
}

class _LineItemRow extends StatelessWidget {
  final int index;
  final _InvoiceLineItemControllers controllers;
  final VoidCallback onRemove;
  const _LineItemRow({
    required this.index,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StylizedInput(
                    controller: controllers.itemNameController,
                    label: 'Plan Name',
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: _StylizedInput(
                    controller: controllers.quantityController,
                    label: 'Qty',
                    isNumeric: true,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: _StylizedInput(
                    controller: controllers.rateController,
                    label: 'Rate',
                    isNumeric: true,
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StylizedInput(
              controller: controllers.itemDescriptionController,
              label: 'Full Description (Audit Ready)',
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceLineItemControllers {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController rateController = TextEditingController(
    text: '0.00',
  );

  _InvoiceLineItemControllers({
    required VoidCallback onValuesChanged,
    _PredefinedSaasItem? preset,
  }) {
    if (preset != null) {
      itemNameController.text = preset.title;
      itemDescriptionController.text = preset.description;
      rateController.text = preset.rate.toStringAsFixed(2);
    }
    itemNameController.addListener(onValuesChanged);
    itemDescriptionController.addListener(onValuesChanged);
    quantityController.addListener(onValuesChanged);
    rateController.addListener(onValuesChanged);
  }

  void disposeControllers() {
    itemNameController.dispose();
    itemDescriptionController.dispose();
    quantityController.dispose();
    rateController.dispose();
  }
}

class _NumberToWordsConverter {
  static const List<String> _onesList = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];
  static const List<String> _tensList = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];

  static String convert(double num) {
    if (num == 0) return 'Rupees Zero Only';
    final int integerPart = num.truncate();
    final int fractionalPart = ((num - integerPart) * 100).round();
    String res = '';
    if (integerPart > 0) res = '${_convertToWords(integerPart)} Rupees';
    if (fractionalPart > 0) {
      if (res.isNotEmpty) res += ' and ';
      res += '${_convertToWords(fractionalPart)} Paisa';
    }
    return res.isEmpty ? 'Rupees Zero Only' : '$res Only';
  }

  static String _convertToWords(int n) {
    if (n < 20) return _onesList[n];
    if (n < 100)
      return '${_tensList[n ~/ 10]}${n % 10 != 0 ? " ${_onesList[n % 10]}" : ""}';
    if (n < 1000)
      return '${_onesList[n ~/ 100]} Hundred${n % 100 != 0 ? " and ${_convertToWords(n % 100)}" : ""}';
    if (n < 100000)
      return '${_convertToWords(n ~/ 1000)} Thousand${n % 1000 != 0 ? " ${_convertToWords(n % 1000)}" : ""}';
    if (n < 10000000)
      return '${_convertToWords(n ~/ 100000)} Lakh${n % 100000 != 0 ? " ${_convertToWords(n % 100000)}" : ""}';
    return '${_convertToWords(n ~/ 10000000)} Crore${n % 10000000 != 0 ? " ${_convertToWords(n % 10000000)}" : ""}';
  }
}
