import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  // Seller Details
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

  // Client Details
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

  // Bank & Payment Details
  final TextEditingController _bankNameInputController = TextEditingController();
  final TextEditingController _accHolderNameInputController =
      TextEditingController();
  final TextEditingController _accNumberInputController =
      TextEditingController();
  final TextEditingController _ifscCodeInputController =
      TextEditingController();
  final TextEditingController _branchNameInputController =
      TextEditingController();
  final TextEditingController _paymentModeInputController =
      TextEditingController(text: 'UPI');
  final TextEditingController _txRefIdInputController = TextEditingController();
  DateTime? _selectedPaymentDate;

  // Invoice Metadata
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

  // Items & Terms
  final List<_InvoiceLineItemControllers> _lineItemControllersList = [];
  final TextEditingController _termsAndNotesInputController =
      TextEditingController(text: 'Payment due within 3 days.');
  final TextEditingController _legalDeclarationInputController =
      TextEditingController(
    text: 'Supplier is not registered under GST. No GST charged under threshold exemption.',
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
          .map((c) => InvoiceItemEntity(
                itemName: c.itemNameController.text,
                itemDescription: c.itemDescriptionController.text,
                itemQuantity: int.tryParse(c.quantityController.text) ?? 1,
                itemRateAmount: double.tryParse(c.rateController.text) ?? 0.0,
              ))
          .toList(),
      invoiceAppliedTaxes: [],
      invoiceTermsAndConditionsText: _termsAndNotesInputController.text,
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
        title: const Text('Professional SaaS Invoice Generator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
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
          const SizedBox(height: 32),
          _SectionTitle('Audit Tracking & Totals'),
          SwitchListTile(
            title: const Text('Fully Paid Status'),
            subtitle: const Text('Marks invoice as PAID and adds audit details.'),
            value: _isFullyPaid,
            onChanged: (v) => setState(() => _isFullyPaid = v),
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
          ],
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
            children: _saasPlansAvailable.map((p) {
              return ActionChip(
                label: Text(p.title),
                onPressed: () => _addNewLineItem(p),
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
          TextButton.icon(
            onPressed: () => _addNewLineItem(),
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Row'),
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
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPreview(InvoiceDataEntity data) {
    return Container(
      color: Colors.grey[200],
      child: PdfPreview(
        build: (format) => _generatePdf(format, data),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, InvoiceDataEntity data) async {
    final pdf = pw.Document();
    final df = DateFormat('dd-MMM-yyyy');
    final logo = data.companyDetails.companyLogoBytes != null
        ? pw.MemoryImage(data.companyDetails.companyLogoBytes!)
        : null;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Header: Logo and Invoice Metadata
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logo != null) pw.Image(logo, width: 100, height: 50) else pw.SizedBox(width: 100),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(data.invoiceTitle.toUpperCase(),
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    if (data.isFullyPaid)
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 4),
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        color: PdfColors.green100,
                        child: pw.Text('PAID', style: pw.TextStyle(color: PdfColors.green800, fontWeight: pw.FontWeight.bold)),
                      ),
                    pw.SizedBox(height: 10),
                    _PdfTextRow('Invoice #:', data.invoiceDocumentNumber),
                    _PdfTextRow('Date:', df.format(data.invoiceIssueDate)),
                    if (data.invoiceReferenceNumber.isNotEmpty)
                      _PdfTextRow('Ref/PO #:', data.invoiceReferenceNumber),
                    if (data.isFullyPaid && data.paymentDate != null)
                      _PdfTextRow('Payment Date:', df.format(data.paymentDate!)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Vendor & Client Info
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('FROM', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      if (data.companyDetails.companyName.isNotEmpty)
                        pw.Text(data.companyDetails.companyName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      if (data.companyDetails.companyAddressLine1.isNotEmpty)
                        pw.Text(data.companyDetails.companyAddressLine1, style: const pw.TextStyle(fontSize: 9)),
                      if (data.companyDetails.companyAddressLine2.isNotEmpty)
                        pw.Text(data.companyDetails.companyAddressLine2, style: const pw.TextStyle(fontSize: 9)),
                      if (data.companyDetails.companyTaxIdentificationNumber.isNotEmpty)
                        pw.Text('PAN: ${data.companyDetails.companyTaxIdentificationNumber}', style: const pw.TextStyle(fontSize: 9)),
                      if (data.companyDetails.companyEmail.isNotEmpty)
                        pw.Text('Email: ${data.companyDetails.companyEmail.toLowerCase()}', style: const pw.TextStyle(fontSize: 9)),
                      if (data.companyDetails.companyPhone.isNotEmpty)
                        pw.Text('Phone: ${data.companyDetails.companyPhone}', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('BILL TO', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      if (data.clientDetails.clientOrganizationName.isNotEmpty)
                        pw.Text(data.clientDetails.clientOrganizationName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      if (data.clientDetails.clientAddressLine1.isNotEmpty)
                        pw.Text(data.clientDetails.clientAddressLine1, style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right),
                      if (data.clientDetails.clientAddressLine2.isNotEmpty)
                        pw.Text(data.clientDetails.clientAddressLine2, style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right),
                      if (data.clientDetails.clientTaxIdentificationNumber.isNotEmpty)
                        pw.Text('GSTIN: ${data.clientDetails.clientTaxIdentificationNumber}', style: const pw.TextStyle(fontSize: 9)),
                      if (data.clientDetails.clientContactPerson.isNotEmpty)
                        pw.Text('Contact: ${data.clientDetails.clientContactPerson}', style: const pw.TextStyle(fontSize: 9)),
                      if (data.clientDetails.clientContactEmail.isNotEmpty)
                        pw.Text('Email: ${data.clientDetails.clientContactEmail.toLowerCase()}', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Item Table
            pw.TableHelper.fromTextArray(
              headers: ['Service/Plan', 'Qty', 'Rate', 'Amount'],
              data: data.invoiceLineItems.map((i) => [
                '${i.itemName}\n${i.itemDescription}',
                i.itemQuantity.toString(),
                '${data.invoiceCurrencySymbol}${i.itemRateAmount.toStringAsFixed(2)}',
                '${data.invoiceCurrencySymbol}${i.calculateTotalItemAmount().toStringAsFixed(2)}'
              ]).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey900),
              cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerRight},
            ),
            pw.Divider(color: PdfColors.grey300),

            // Summary Bottom Section
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bank Details
                pw.Expanded(
                  flex: 3,
                  child: data.bankDetails.hasAnyInformationalDetails
                      ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('PAYMENT DETAILS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 4),
                            _PdfBankLine('Bank:', data.bankDetails.bankName),
                            _PdfBankLine('Acc Holder:', data.bankDetails.accountHolderName),
                            _PdfBankLine('Acc No:', data.bankDetails.accountNumber),
                            _PdfBankLine('IFSC Code:', data.bankDetails.ifscCode),
                            if (data.bankDetails.branchName.isNotEmpty)
                              _PdfBankLine('Branch:', data.bankDetails.branchName),
                          ],
                        )
                      : pw.SizedBox(),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _PdfTotalLine('Subtotal', '${data.invoiceCurrencySymbol}${data.calculateSubTotalAmount().toStringAsFixed(2)}'),
                      if (data.roundingAmount != 0)
                        _PdfTotalLine('Round Off', '${data.roundingAmount > 0 ? "+" : ""}${data.roundingAmount.toStringAsFixed(2)}'),
                      pw.Divider(color: PdfColors.grey400),
                      _PdfTotalLine('Grand Total', '${data.invoiceCurrencySymbol}${data.calculateGrandTotalAmount().toStringAsFixed(2)}', isBold: true),
                      if (data.isFullyPaid) ...[
                        pw.SizedBox(height: 4),
                        if (data.paymentMode.isNotEmpty)
                          pw.Text('Mode: ${data.paymentMode}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        if (data.transactionReferenceId.isNotEmpty)
                          pw.Text('Ref: ${data.transactionReferenceId}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      ],
                      pw.SizedBox(height: 10),
                      // Amount in words
                      pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        color: PdfColors.grey100,
                        child: pw.Text(
                          'In Words: ${_NumberToWordsConverter.convert(data.calculateGrandTotalAmount())}',
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Spacer(),

            // Footer Compliance
            if (data.legalDeclarationText.isNotEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 20),
                child: pw.Text(data.legalDeclarationText, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
              ),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (data.isComputerGeneratedNotice)
                  pw.Text('Computer Generated Invoice', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                if (data.includeSignaturePlaceholder)
                  pw.Column(
                    children: [
                      pw.Text(data.signatoryName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                      pw.Container(width: 120, height: 1, color: PdfColors.black),
                      pw.Text('Authorised Signatory', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
              ],
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  void _pickDate(bool issue) async {
    final d = await showDatePicker(
      context: context,
      initialDate: issue ? _selectedIssueDate : _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => issue ? _selectedIssueDate = d : _selectedDueDate = d);
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
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
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
      keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return null;
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Invalid Email';
        if (isPan && !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(v)) return 'Invalid PAN Format';
        return null;
      },
    );
  }
}

class _DateInputField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateInputField({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(DateFormat.yMMMd().format(date)),
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
      value: value,
      items: const [
        DropdownMenuItem(value: 'INR ', child: Text('Indian Rupee (INR)')),
        DropdownMenuItem(value: 'USD ', child: Text('US Dollar (USD)')),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Currency', border: OutlineInputBorder()),
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
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: bytes != null ? Image.memory(bytes!, fit: BoxFit.contain) : const Icon(Icons.business_center),
        ),
        TextButton(onPressed: _pick, child: const Text('Logo')),
      ],
    );
  }

  void _pick() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res != null) onPicked(res.files.single.bytes);
  }
}

class _LineItemRow extends StatelessWidget {
  final int index;
  final _InvoiceLineItemControllers controllers;
  final VoidCallback onRemove;
  const _LineItemRow({required this.index, required this.controllers, required this.onRemove});

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
                Expanded(child: _StylizedInput(controller: controllers.itemNameController, label: 'Plan Name')),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: _StylizedInput(controller: controllers.quantityController, label: 'Qty', isNumeric: true)),
                const SizedBox(width: 8),
                SizedBox(width: 100, child: _StylizedInput(controller: controllers.rateController, label: 'Rate', isNumeric: true)),
                IconButton(onPressed: onRemove, icon: const Icon(Icons.delete, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            _StylizedInput(controller: controllers.itemDescriptionController, label: 'Full Description (Audit Ready)'),
          ],
        ),
      ),
    );
  }
}

// PDF Helpers (Private)

pw.Widget _PdfTextRow(String label, String val) {
  if (val.isEmpty) return pw.SizedBox();
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(width: 5),
        pw.Text(val, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
}

pw.Widget _PdfBankLine(String label, String val) {
  if (val.isEmpty) return pw.SizedBox();
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 1),
    child: pw.Row(
      children: [
        pw.SizedBox(width: 60, child: pw.Text(label, style: const pw.TextStyle(fontSize: 8))),
        pw.Text(val, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
}

pw.Widget _PdfTotalLine(String label, String val, {bool isBold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(val, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    ),
  );
}

class _InvoiceLineItemControllers {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: '1');
  final TextEditingController rateController = TextEditingController(text: '0.00');

  _InvoiceLineItemControllers({required VoidCallback onValuesChanged, _PredefinedSaasItem? preset}) {
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
  static const List<String> _onesList = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
  static const List<String> _tensList = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

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
    if (n < 100) return '${_tensList[n ~/ 10]}${n % 10 != 0 ? " ${_onesList[n % 10]}" : ""}';
    if (n < 1000) return '${_onesList[n ~/ 100]} Hundred${n % 100 != 0 ? " and ${_convertToWords(n % 100)}" : ""}';
    if (n < 100000) return '${_convertToWords(n ~/ 1000)} Thousand${n % 1000 != 0 ? " ${_convertToWords(n % 1000)}" : ""}';
    if (n < 10000000) return '${_convertToWords(n ~/ 100000)} Lakh${n % 100000 != 0 ? " ${_convertToWords(n % 100000)}" : ""}';
    return '${_convertToWords(n ~/ 10000000)} Crore${n % 10000000 != 0 ? " ${_convertToWords(n % 10000000)}" : ""}';
  }
}
