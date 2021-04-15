import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

mixin FocusNodes on Model {
  FocusNode salesFocusNode = FocusNode();
  FocusNode itemFindeeFocusNode = FocusNode();
  FocusNode barCodeFocusNode = FocusNode();
  FocusNode messageFocusNode = FocusNode();

  focusSalesPage() {
    salesFocusNode.requestFocus();
  }

  focusItemFinder() {
    itemFindeeFocusNode.requestFocus();
  }

  focusBarcodeField() {
    barCodeFocusNode.requestFocus();
  }

  focusMessage() {
    messageFocusNode.requestFocus();
  }
}
