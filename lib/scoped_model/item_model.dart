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

  reduceFromItems(List<Item> itemsToReduce) {
    itemsToReduce.forEach((reduce) {
      int index = items.indexWhere((it) => it.id == reduce.id);
      if (index >= 0) {
        items[index].currentQty -= reduce.sellQuantity;
      }
    });
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

  removeItem(int id) {
    var t = _billedItems;
    t.removeWhere((element) => element.id == id);
    _billedItems = [];
    notifyListeners();
    Future.delayed(Duration(milliseconds: 100), () {
      _billedItems = t;
      notifyListeners();
    });
  }

  setTotalPrice(double price, int index) {
    _billedItems[index].totalPrice = price;
    notifyListeners();
  }

  setGetItemsFromBarCode(bool value) {
    getItemsFromBarCode = value;
    notifyListeners();
  }

  setQuantity(int index, double qty) {
    _billedItems[index].sellQuantity = qty;
    notifyListeners();
  }

  setSellPrice(int index, double sellPrice) {
    _billedItems[index].sellPrice = sellPrice;
    notifyListeners();
  }
}
