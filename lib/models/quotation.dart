import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';

class QuotationLine {
  final String productName;
  final String description;
  final double quantity;
  final double unitPrice;
  final double taxRate;
  final double taxAmount;
  final double subtotal;

  QuotationLine({
    required this.productName,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
  }) : taxAmount = (quantity * unitPrice) * (taxRate / 100),
       subtotal = (quantity * unitPrice) + ((quantity * unitPrice) * (taxRate / 100));
}

class Quotation {
  final String id;
  final String number;
  final Lead? lead;
  final Opportunity? opportunity;
  final DateTime date;
  final DateTime validUntil;
  final String status; // Draft, Sent, Accepted, Rejected, Expired
  final List<QuotationLine> lines;
  final double totalAmount;
  final double totalTax;
  final String notes;
  final String termsAndConditions;

  Quotation({
    required this.id,
    required this.number,
    this.lead,
    this.opportunity,
    required this.date,
    required this.validUntil,
    required this.status,
    required this.lines,
    required this.notes,
    required this.termsAndConditions,
  }) : totalAmount = lines.fold(0, (sum, line) => sum + line.subtotal),
       totalTax = lines.fold(0, (sum, line) => sum + line.taxAmount);
}

class SalesOrder {
  final String id;
  final String number;
  final Quotation quotation;
  final DateTime date;
  final String status; // Draft, Confirmed, In Progress, Delivered, Cancelled
  final List<QuotationLine> lines;
  final double totalAmount;
  final double totalTax;
  final String deliveryAddress;
  final String paymentTerms;
  final String notes;

  SalesOrder({
    required this.id,
    required this.number,
    required this.quotation,
    required this.date,
    required this.status,
    required this.lines,
    required this.deliveryAddress,
    required this.paymentTerms,
    required this.notes,
  }) : totalAmount = lines.fold(0, (sum, line) => sum + line.subtotal),
       totalTax = lines.fold(0, (sum, line) => sum + line.taxAmount);
} 