class CardModel {
  CardModel(this.cardNumber, this.expiryDate, this.cvvCode, this.isCvvFocused);

  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';
  String brand = '';
  bool isCvvFocused = false;
}
