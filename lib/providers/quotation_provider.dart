import 'package:flutter/material.dart';
import 'package:leads_management_app/models/quotation.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';

class QuotationProvider with ChangeNotifier {
  List<Quotation> _quotations = [];
  List<SalesOrder> _salesOrders = [];
  bool _isLoading = false;
  String? _error;

  List<Quotation> get quotations => _quotations;
  List<SalesOrder> get salesOrders => _salesOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load initial data
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API calls
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      _quotations = [
        Quotation(
          id: '1',
          number: 'QT001',
          date: DateTime.now(),
          validUntil: DateTime.now().add(const Duration(days: 30)),
          status: 'Sent',
          lines: [
            QuotationLine(
              productName: 'Product A',
              description: 'Description for Product A',
              quantity: 2,
              unitPrice: 100,
              taxRate: 5,
            ),
          ],
          notes: 'Sample quotation',
          termsAndConditions: 'Standard terms and conditions apply',
        ),
      ];

      _salesOrders = [
        SalesOrder(
          id: '1',
          number: 'SO001',
          quotation: _quotations[0],
          date: DateTime.now(),
          status: 'Confirmed',
          lines: _quotations[0].lines,
          deliveryAddress: '123 Main St, City, Country',
          paymentTerms: 'Net 30',
          notes: 'Sample sales order',
        ),
      ];

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new quotation
  Future<void> createQuotation({
    required Lead? lead,
    required Opportunity? opportunity,
    required DateTime validUntil,
    required List<QuotationLine> lines,
    required String notes,
    required String termsAndConditions,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      final newQuotation = Quotation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        number: 'QT${(_quotations.length + 1).toString().padLeft(3, '0')}',
        lead: lead,
        opportunity: opportunity,
        date: DateTime.now(),
        validUntil: validUntil,
        status: 'Draft',
        lines: lines,
        notes: notes,
        termsAndConditions: termsAndConditions,
      );

      _quotations.add(newQuotation);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Convert quotation to sales order
  Future<void> convertToSalesOrder({
    required Quotation quotation,
    required String deliveryAddress,
    required String paymentTerms,
    required String notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      final newSalesOrder = SalesOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        number: 'SO${_salesOrders.length + 1}',
        quotation: quotation,
        date: DateTime.now(),
        status: 'Confirmed',
        lines: quotation.lines,
        deliveryAddress: deliveryAddress,
        paymentTerms: paymentTerms,
        notes: notes,
      );

      _salesOrders.add(newSalesOrder);
      
      // Update quotation status
      final index = _quotations.indexWhere((q) => q.id == quotation.id);
      if (index != -1) {
        _quotations[index] = Quotation(
          id: quotation.id,
          number: quotation.number,
          lead: quotation.lead,
          opportunity: quotation.opportunity,
          date: quotation.date,
          validUntil: quotation.validUntil,
          status: 'Accepted',
          lines: quotation.lines,
          notes: quotation.notes,
          termsAndConditions: quotation.termsAndConditions,
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update quotation status
  Future<void> updateQuotationStatus(String quotationId, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      final index = _quotations.indexWhere((q) => q.id == quotationId);
      if (index != -1) {
        final quotation = _quotations[index];
        _quotations[index] = Quotation(
          id: quotation.id,
          number: quotation.number,
          lead: quotation.lead,
          opportunity: quotation.opportunity,
          date: quotation.date,
          validUntil: quotation.validUntil,
          status: status,
          lines: quotation.lines,
          notes: quotation.notes,
          termsAndConditions: quotation.termsAndConditions,
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing quotation
  Future<void> updateQuotation(Quotation updated) async {
    final idx = _quotations.indexWhere((q) => q.id == updated.id);
    if (idx != -1) {
      _quotations[idx] = updated;
      notifyListeners();
    }
  }

  // Delete a quotation
  Future<void> deleteQuotation(String id) async {
    _quotations.removeWhere((q) => q.id == id);
    notifyListeners();
  }
} 