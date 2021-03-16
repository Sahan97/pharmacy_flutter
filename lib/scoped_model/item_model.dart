import 'package:communication/model/item.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ItemScopedModel on Model {
  List<Item> items = [];
  int editItemIndex;
  bool getItemsFromBarCode = false;

  setEditItem(int index) {
    editItemIndex = index;
    notifyListeners();
  }

  setItems(List<Item> it) {
    items = it;
    notifyListeners();
  }

  List<Item> _billedItems = [];
  addToBill(Item item) {
    _billedItems.add(item);
    notifyListeners();
  }

  List<Item> get billedItems => _billedItems;
  clearBill() {
    _billedItems = [];
    notifyListeners();
  }

  removeItem(int index) {
    _billedItems.removeAt(index);
    notifyListeners();
  }

  setTotalPrice(double price, int index) {
    _billedItems[index].totalPrice = price;
    notifyListeners();
  }

  setGetItemsFromBarCode(bool value) {
    getItemsFromBarCode = value;
    notifyListeners();
  }
}
