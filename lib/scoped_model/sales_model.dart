import 'package:communication/model/sale.dart';
import 'package:scoped_model/scoped_model.dart';

mixin SalesScopedModel on Model {
  Sale saleItemToView;
  setItemToView(Sale item) {
    saleItemToView = item;
    notifyListeners();
  }
}
