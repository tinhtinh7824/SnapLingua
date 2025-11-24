class PurchaseItemResult {
  PurchaseItemResult({
    required this.newScalesBalance,
    required this.newGemsBalance,
    required this.newQuantity,
    required this.inventoryDocumentId,
  });

  final int newScalesBalance;
  final int newGemsBalance;
  final int newQuantity;
  final String inventoryDocumentId;
}

class InsufficientFundsException implements Exception {
  InsufficientFundsException({
    required this.currency,
    required this.requiredAmount,
    required this.availableAmount,
  });

  final String currency;
  final int requiredAmount;
  final int availableAmount;

  @override
  String toString() {
    return 'InsufficientFundsException(currency: $currency, required: '
        '$requiredAmount, available: $availableAmount)';
  }
}
