import 'dart:io';

import 'package:communication/helpers/api_service.dart';
import 'package:communication/model/item.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/loading_btn.dart';
import 'package:flutter/material.dart';

import 'package:filepicker_windows/filepicker_windows.dart';

class AddFromExcel extends StatefulWidget {
  AddFromExcel({Key key}) : super(key: key);

  @override
  _AddFromExcelState createState() => _AddFromExcelState();
}

class _AddFromExcelState extends State<AddFromExcel> {
  Item newItem = Item();
  bool _isBusy = false;
  File selectedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  final file = OpenFilePicker()
                    ..filterSpecification = {
                      'Excel Sheet (*.xlsx)': '*.xlsx',
                    }
                    ..defaultFilterIndex = 0
                    ..defaultExtension = 'xlsx'
                    ..title = 'Select a document';

                  final result = file.getFile();
                  if (result != null) {
                    print(result.path);
                    setState(() {
                      selectedFile = result;
                    });
                  } else {
                    setState(() {
                      selectedFile = null;
                    });
                  }
                },
                child: Text('Select File'),
              ),
              Text(selectedFile != null
                  ? selectedFile.path
                      .split('\\')[selectedFile.path.split('\\').length - 1]
                  : 'No file selected!'),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingBtn(
                    onPressed: _onSubmit,
                    text: 'Submit',
                    isBusy: _isBusy,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _onSubmit() {
    setState(() {
      _isBusy = true;
    });
    ApiService.shared.addItemsFromExcel(selectedFile).then((value) {
      setState(() {
        _isBusy = false;
      });

      Messages.simpleMessage(head: value.title, body: value.subtitle);
    });
  }
}
