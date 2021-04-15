import 'package:communication/model/item.dart';
import 'package:communication/model/other_charge.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ItemScopedModel on Model {
  List<Item> items = [];
  List<OtherCharge> otherCharges = [];
  int editItemIndex;
  int editOtherChargeIndex;
  bool getItemsFromBarCode = false;

  setEditItem(int index) {
    editItemIndex = index;
    notifyListeners();
  }

  updateItem(int index, Item item) {
    items[index] = item;
    notifyListeners();
  }

  setEditOtherCharge(int index) {
    editOtherChargeIndex = index;
    notifyListeners();
  }

  setItems(List<Item> it) {
    items = it;
    notifyListeners();
  }

  setOtherCharges(List<OtherCharge> it) {
    otherCharges = it;
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
