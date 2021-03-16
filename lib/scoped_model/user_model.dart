import 'package:communication/model/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin UserScopedModel on Model {
  User user;

  login(User u) {
    this.user = u;
    notifyListeners();
  }

  logout() {
    this.user = null;
    notifyListeners();
  }
}
