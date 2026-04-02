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


  final TextEditingController _bankNameInputController = TextEditingController();
  final TextEditingController _accHolderNameInputController =
      TextEditingController();
  final TextEditingController _accNumberInputController =
      TextEditingController();
  final TextEditingController _ifscCodeInputController =
      TextEditingController();
  final TextEditingController _branchNameInputController =
      TextEditingController();
  final TextEditingController _upiIdInputController =
      TextEditingController();
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
  final TextEditingController _taxLabelInputController =
      TextEditingController(text: 'GST');
  final TextEditingController _taxPercentageInputController =
      TextEditingController(text: '0');
  final TextEditingController _paymentInstructionsInputController =
      TextEditingController();


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
          .map((c) => InvoiceItemEntity(
                itemName: c.itemNameController.text,
                itemDescription: c.itemDescriptionController.text,
                itemQuantity: int.tryParse(c.quantityController.text) ?? 1,
                itemRateAmount: double.tryParse(c.rateController.text) ?? 0.0,
              ))
          .toList(),
      invoiceAppliedTaxes: [
        InvoiceTaxEntity(
          taxLabelName: _taxLabelInputController.text,
          taxPercentageValue: double.tryParse(_taxPercentageInputController.text) ?? 0.0,
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
                label: Text(plan.title, style: const TextStyle(color: Colors.black87)),
                icon: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final primaryColor = PdfColors.black;
    final secondaryColor = PdfColors.grey700;
    final accentColor = PdfColors.grey200;
    final successColor = PdfColors.green700;
    final errorColor = PdfColors.red700;

    final logo = data.companyDetails.companyLogoBytes != null
        ? pw.MemoryImage(data.companyDetails.companyLogoBytes!)
        : null;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => pw.Container(
          height: 10,
          color: primaryColor,
          margin: const pw.EdgeInsets.only(bottom: 20),
        ),
        build: (context) {
          return [

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logo != null)
                      pw.Container(
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Image(logo, height: 60),
                      ),
                    pw.Text(
                      data.companyDetails.companyName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(data.companyDetails.companyAddressLine1, style: pw.TextStyle(fontSize: 9)),
                    pw.Text(data.companyDetails.companyAddressLine2, style: pw.TextStyle(fontSize: 9)),
                    if (data.companyDetails.companyTaxIdentificationNumber.isNotEmpty)
                      pw.Text('PAN: ${data.companyDetails.companyTaxIdentificationNumber}', style: pw.TextStyle(fontSize: 9)),
                    pw.Text('P: ${data.companyDetails.companyPhone}', style: pw.TextStyle(fontSize: 9)),
                    pw.Text('E: ${data.companyDetails.companyEmail}', style: pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      data.invoiceTitle.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    _pdfMetadataRow('Invoice #', data.invoiceDocumentNumber, primaryColor),
                    _pdfMetadataRow('Date', df.format(data.invoiceIssueDate), primaryColor),
                    _pdfMetadataRow('Due Date', df.format(data.invoiceDueDate), primaryColor),
                    if (data.invoiceReferenceNumber.isNotEmpty)
                      _pdfMetadataRow('Ref #', data.invoiceReferenceNumber, primaryColor),
                    if (data.isFullyPaid)
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 10),
                        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.green50,
                          borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                          border: pw.Border.all(color: successColor, width: 0.5),
                        ),
                        child: pw.Text('COMPLETED / PAID', style: pw.TextStyle(color: successColor, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      ),
                    if (!data.isFullyPaid && data.invoiceDueDate.isBefore(DateTime.now()))
                       pw.Container(
                        margin: const pw.EdgeInsets.only(top: 10),
                        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.red50,
                          borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                          border: pw.Border.all(color: errorColor, width: 0.5),
                        ),
                        child: pw.Text('OVERDUE', style: pw.TextStyle(color: errorColor, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 40),


            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('BILL TO', style: pw.TextStyle(fontSize: 8, color: primaryColor, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        data.clientDetails.clientOrganizationName,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                      ),
                      pw.Text(data.clientDetails.clientAddressLine1, style: pw.TextStyle(fontSize: 9)),
                      pw.Text(data.clientDetails.clientAddressLine2, style: pw.TextStyle(fontSize: 9)),
                      pw.Text('E: ${data.clientDetails.clientContactEmail}', style: pw.TextStyle(fontSize: 9)),
                      if (data.clientDetails.clientTaxIdentificationNumber.isNotEmpty)
                        pw.Text('GSTIN: ${data.clientDetails.clientTaxIdentificationNumber}', style: pw.TextStyle(fontSize: 9)),
                      pw.SizedBox(height: 4),
                      pw.Text('Contact: ${data.clientDetails.clientContactPerson}', style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 30),


            pw.TableHelper.fromTextArray(
              headers: ['#', 'DESCRIPTION', 'QTY', 'RATE', 'AMOUNT'],
              headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellPadding: pw.EdgeInsets.all(8),
              columnWidths: {
                0: pw.FixedColumnWidth(25),
                1: pw.FlexColumnWidth(5),
                2: pw.FixedColumnWidth(40),
                3: pw.FixedColumnWidth(80),
                4: pw.FixedColumnWidth(80),
              },
              data: List<List<dynamic>>.generate(data.invoiceLineItems.length, (index) {
                final item = data.invoiceLineItems[index];
                return [
                  (index + 1).toString(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(item.itemName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      pw.Text(item.itemDescription, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                    ],
                  ),
                  item.itemQuantity.toString(),
                  '${data.invoiceCurrencySymbol}${item.itemRateAmount.toStringAsFixed(2)}',
                  '${data.invoiceCurrencySymbol}${item.calculateTotalItemAmount().toStringAsFixed(2)}',
                ];
              }),
              border: null,
              rowDecoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
              ),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),

            pw.SizedBox(height: 20),


            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (data.bankDetails.hasAnyInformationalDetails) ...[
                        pw.Text('PAYMENT INFORMATION', style: pw.TextStyle(fontSize: 8, color: primaryColor, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 6),
                        _pdfLabelValue('Bank Name', data.bankDetails.bankName),
                        _pdfLabelValue('Account Name', data.bankDetails.accountHolderName),
                        _pdfLabelValue('Account Number', data.bankDetails.accountNumber),
                        _pdfLabelValue('IFSC Code', data.bankDetails.ifscCode),
                        _pdfLabelValue('Branch', data.bankDetails.branchName),
                        _pdfLabelValue('UPI ID', data.bankDetails.upiId),
                        if (data.isFullyPaid) ...[
                          if (data.paymentMode.isNotEmpty)
                            _pdfLabelValue('Payment Mode', data.paymentMode),
                          if (data.transactionReferenceId.isNotEmpty)
                            _pdfLabelValue('Tx Ref ID', data.transactionReferenceId),
                          if (data.paymentDate != null)
                            _pdfLabelValue('Paid Date', df.format(data.paymentDate!)),
                        ],
                        pw.SizedBox(height: 10),
                      ],
                      if (data.invoicePaymentInstructionsText.isNotEmpty) ...[
                        pw.Text('PAYMENT INSTRUCTIONS', style: pw.TextStyle(fontSize: 8, color: primaryColor, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text(data.invoicePaymentInstructionsText, style: pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(height: 10),
                      ],
                      if (data.invoiceTermsAndConditionsText.isNotEmpty) ...[
                        pw.Text('NOTES', style: pw.TextStyle(fontSize: 8, color: primaryColor, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text(data.invoiceTermsAndConditionsText, style: pw.TextStyle(fontSize: 8)),
                      ],
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    children: [
                      _pdfSummaryRow('Subtotal', '${data.invoiceCurrencySymbol}${data.calculateSubTotalAmount().toStringAsFixed(2)}'),
                      ...data.invoiceAppliedTaxes.map((tax) {
                        final taxAmount = data.calculateSubTotalAmount() * (tax.taxPercentageValue / 100.0);
                        if (taxAmount == 0) return pw.SizedBox();
                        return _pdfSummaryRow('${tax.taxLabelName} (${tax.taxPercentageValue}%)', '${data.invoiceCurrencySymbol}${taxAmount.toStringAsFixed(2)}');
                      }),
                      if (data.roundingAmount != 0)
                        _pdfSummaryRow('Round Off', '${data.roundingAmount > 0 ? "+" : ""}${data.roundingAmount.toStringAsFixed(2)}'),
                      pw.Divider(color: PdfColors.grey200),
                      pw.Container(
                        padding: pw.EdgeInsets.all(6),
                        decoration: pw.BoxDecoration(color: accentColor, borderRadius: pw.BorderRadius.all(pw.Radius.circular(4))),
                        child: _pdfSummaryRow(
                          'Grand Total',
                          '${data.invoiceCurrencySymbol}${data.calculateGrandTotalAmount().toStringAsFixed(2)}',
                          isBold: true,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 10),

                      pw.Text(
                        'Total In Words: ${_NumberToWordsConverter.convert(data.calculateGrandTotalAmount())}',
                        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700, fontStyle: pw.FontStyle.italic),
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.Spacer(),


            if (data.legalDeclarationText.isNotEmpty)
              pw.Container(
                margin: pw.EdgeInsets.only(top: 20),
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: PdfColors.grey300, width: 2))),
                child: pw.Text(data.legalDeclarationText, style: pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
              ),

            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                if (data.isComputerGeneratedNotice)
                  pw.Text('E. & O.E. | This is a computer generated document.',
                      style: pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
                if (data.includeSignaturePlaceholder)
                  pw.Column(
                    children: [
                      pw.Text('For ${data.companyDetails.companyName}',
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 30),
                      pw.Text(data.signatoryName,
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                      pw.Container(width: 120, height: 1, color: secondaryColor),
                      pw.Text('Authorised Signatory', style: pw.TextStyle(fontSize: 7)),
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
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
      keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : (isEmail ? TextInputType.emailAddress : TextInputType.text),
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
  final DateTime? date;
  final VoidCallback onTap;
  const _DateInputField({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(date != null ? DateFormat.yMMMd().format(date!) : 'Select Date'),
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
                IconButton(onPressed: onRemove, icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            _StylizedInput(controller: controllers.itemDescriptionController, label: 'Full Description (Audit Ready)'),
          ],
        ),
      ),
    );
  }
}



pw.Widget _pdfMetadataRow(String label, String value, PdfColor color) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 2),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$label: ', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
}

pw.Widget _pdfLabelValue(String label, String value) {
  if (value.isEmpty) return pw.SizedBox();
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 2),
    child: pw.Row(
      children: [
        pw.SizedBox(width: 80, child: pw.Text('$label:', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600))),
        pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
}

pw.Widget _pdfSummaryRow(String label, String value, {bool isBold = false, PdfColor? color}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color ?? PdfColors.black,
            )),
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
