import 'package:communication/scoped_model/focus_nodes.dart';
import 'package:communication/scoped_model/item_model.dart';
import 'package:communication/scoped_model/other_model.dart';
import 'package:communication/scoped_model/sales_model.dart';
import 'package:communication/scoped_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with
        UserScopedModel,
        OtherScopedModel,
        ItemScopedModel,
        FocusNodes,
        SalesScopedModel {}
