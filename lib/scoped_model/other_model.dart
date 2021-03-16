import 'package:communication/views/admin_sales_page/Admin_sales_page.dart';
import 'package:communication/views/home_page/home_page.dart';
import 'package:communication/views/manage_items/manage_items.dart';
import 'package:scoped_model/scoped_model.dart';

mixin OtherScopedModel on Model {
  HomePagePopups currentPopup = HomePagePopups.NoPopup;
  ManageItemPopup manageItemCurrentPopup = ManageItemPopup.NoPopup;
  AdminSalesPagePopup adminSalePagePopup = AdminSalesPagePopup.NoPopup;

  setHomePagePopup(HomePagePopups popup) {
    currentPopup = popup;
    notifyListeners();
  }

  setManageItemPopup(ManageItemPopup popup) {
    manageItemCurrentPopup = popup;
    notifyListeners();
  }

  setAdminSalePagePopup(AdminSalesPagePopup popup) {
    adminSalePagePopup = popup;
    notifyListeners();
  }
}
