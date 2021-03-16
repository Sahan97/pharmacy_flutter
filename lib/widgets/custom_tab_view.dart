import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading_btn.dart';

class CustomTabView extends StatefulWidget {
  final String title;
  final List<String> labels;
  final List<Widget> tabs;

  CustomTabView(
      {Key key,
      @required this.title,
      @required this.labels,
      @required this.tabs})
      : super(key: key);

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  int selectedTab = 0;
  bool animation = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              _title(widget.title),
              _shadedBox(),
            ],
          ),
        ),
        Align(
          child: _backBtn(),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }

  Widget _backBtn() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 40, color: Colors.white, fontFamily: 'Sunday Best'),
      ),
    );
  }

  Widget _shadedBox() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _leftButtons(),
            ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ScaleAnimatedWidget(
                    enabled: animation,
                    duration: Duration(milliseconds: 500),
                    values: [1,0,1.01,1],
                    child: widget.tabs[selectedTab]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _leftButtons() {
    List<Widget> tabList = [];
    for (int i = 0; i < widget.labels.length; i++) {
      String label = widget.labels[i];
      tabList.add(LoadingBtn(
        onPressed: () {
          changeTab(i);
        },
        text: label,
        height: 50,
        color: getBtnColor(i),
      ));
    }
    return Container(
      child: ListView(children: tabList),
    );
  }

  Color getBtnColor(int thisTab) {
    return thisTab == selectedTab ? Colors.blue : Colors.grey.withOpacity(0.5);
  }

  changeTab(int tab) {
    setState(() {
      selectedTab = tab;
      animation = false;
      Future.delayed(Duration(milliseconds: 100),(){
        setState(() {
          animation = true;
        });
        
      });
    });
  }
}
