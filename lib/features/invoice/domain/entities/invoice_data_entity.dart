import 'dart:typed_data';

/// Represents a single line item in the invoice.
class InvoiceItemEntity {
  final String itemName;
  final String itemDescription;
  final int itemQuantity;
  final double itemRateAmount;

  const InvoiceItemEntity({
    required this.itemName,
    required this.itemDescription,
    required this.itemQuantity,
    required this.itemRateAmount,
  });

  /// Calculates the total amount for this specific item line.
  double calculateTotalItemAmount() {
    return itemQuantity * itemRateAmount;
  }
}

/// Represents the details of the company issuing the invoice.
class CompanyDetailsEntity {
  final String companyName;
  final String companyAddressLine1;
  final String companyAddressLine2;
  final String companyTaxIdentificationNumber;
  final String companyEmail;
  final String companyPhone;
  final Uint8List? companyLogoBytes;

  const CompanyDetailsEntity({
    this.companyName = '',
    this.companyAddressLine1 = '',
    this.companyAddressLine2 = '',
    this.companyTaxIdentificationNumber = '',
    this.companyEmail = '',
    this.companyPhone = '',
    this.companyLogoBytes,
  });
}

/// Represents the details of the client receiving the invoice.
class ClientDetailsEntity {
  final String clientOrganizationName;
  final String clientAddressLine1;
  final String clientAddressLine2;
  final String clientTaxIdentificationNumber;
  final String clientContactPerson;
  final String clientContactEmail;

  const ClientDetailsEntity({
    this.clientOrganizationName = '',
    this.clientAddressLine1 = '',
    this.clientAddressLine2 = '',
    this.clientTaxIdentificationNumber = '',
    this.clientContactPerson = '',
    this.clientContactEmail = '',
  });
}

/// Represents the bank account details for payment transfers (NEFT/IMPS/UPI).
class BankDetailsEntity {
  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String upiId;

  const BankDetailsEntity({
    this.bankName = '',
    this.accountHolderName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.branchName = '',
    this.upiId = '',
  });

  bool get hasAnyInformationalDetails =>
      bankName.isNotEmpty ||
      accountHolderName.isNotEmpty ||
      accountNumber.isNotEmpty ||
      ifscCode.isNotEmpty ||
      upiId.isNotEmpty;
}

/// Represents a specific tax applied to the invoice subtotal.
class InvoiceTaxEntity {
  final String taxLabelName; // e.g. "CGST (9%)" or "SGST (9%)"
  final double taxPercentageValue;

  const InvoiceTaxEntity({
    required this.taxLabelName,
    required this.taxPercentageValue,
  });
}

/// The root entity encompassing all data required to generate an invoice PDF.
class InvoiceDataEntity {
  final CompanyDetailsEntity companyDetails;
  final ClientDetailsEntity clientDetails;
  
  final String invoiceTitle; // e.g. TAX INVOICE
  final String invoiceDocumentNumber;
  final String invoiceReferenceNumber; // e.g. PO Number
  final DateTime invoiceIssueDate;
  final DateTime invoiceDueDate;
  
  final String invoiceCurrencySymbol; // e.g., '₹' or '$'
  
  final List<InvoiceItemEntity> invoiceLineItems;
  final List<InvoiceTaxEntity> invoiceAppliedTaxes;
  
  final String invoiceTermsAndConditionsText;
  final String invoicePaymentInstructionsText;
  
  final bool isFullyPaid;
  final bool includeSignaturePlaceholder;
  final String signatoryName;
  final String paymentMode;
  final String transactionReferenceId;
  final DateTime? paymentDate;
  final String legalDeclarationText;
  final bool isComputerGeneratedNotice;

  final BankDetailsEntity bankDetails;
  final double roundingAmount;

  const InvoiceDataEntity({
    this.companyDetails = const CompanyDetailsEntity(),
    this.clientDetails = const ClientDetailsEntity(),
    this.invoiceTitle = 'TAX INVOICE',
    this.invoiceDocumentNumber = '',
    this.invoiceReferenceNumber = '',
    required this.invoiceIssueDate,
    required this.invoiceDueDate,
    this.invoiceCurrencySymbol = '₹',
    this.invoiceLineItems = const [],
    this.invoiceAppliedTaxes = const [],
    this.invoiceTermsAndConditionsText = '',
    this.invoicePaymentInstructionsText = '',
    this.isFullyPaid = false,
    this.includeSignaturePlaceholder = true,
    this.signatoryName = '',
    this.paymentMode = '',
    this.transactionReferenceId = '',
    this.paymentDate,
    this.legalDeclarationText = '',
    this.isComputerGeneratedNotice = true,
    this.bankDetails = const BankDetailsEntity(),
    this.roundingAmount = 0.0,
  });

  /// Calculates the sum of all line items before taxes.
  double calculateSubTotalAmount() {
    double computedSubTotal = 0.0;
    for (final InvoiceItemEntity currentItem in invoiceLineItems) {
      computedSubTotal += currentItem.calculateTotalItemAmount();
    }
    return computedSubTotal;
  }

  /// Calculates the total monetary amount of taxes applied to the subtotal.
  double calculateTotalTaxAmount() {
    final double computedSubTotal = calculateSubTotalAmount();
    double computedTotalTax = 0.0;
    
    for (final InvoiceTaxEntity currentTax in invoiceAppliedTaxes) {
      final double specificTaxAmount = computedSubTotal * (currentTax.taxPercentageValue / 100.0);
      computedTotalTax += specificTaxAmount;
    }
    
    return computedTotalTax;
  }

  /// Calculates the final grand total amount including subtotal, all applied taxes, and rounding.
  double calculateGrandTotalAmount() {
    return calculateSubTotalAmount() + calculateTotalTaxAmount() + roundingAmount;
  }
}
