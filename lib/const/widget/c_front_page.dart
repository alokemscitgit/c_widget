import 'package:flutter/material.dart';
import 'c_split_view.dart';

Widget c_frontPage(
        {required GlobalKey<ScaffoldState> sKey,
        required Widget firstChild,
        required Widget secondChild,
        Widget? topBar,
        double screenWidth = 1360,
        Function(bool b)? fun,
        double minWidth = 1000,
        bool otherCondition = false}) =>
    CSplitView(
      axis: Axis.horizontal,
      initialFraction: screenWidth < minWidth ? 0 : 0,
      minFirstPanelSize: screenWidth < minWidth ? 0 : 220,
      maxFirstPanelSize: screenWidth < minWidth ? 0 : 400,
      dividerThickness: screenWidth < minWidth ? 0 : 2,
      isShowLeftPanel: otherCondition,
      dividerColor: Colors.transparent,
      first: firstChild,
      second: Stack(
        children: [
          
          Column(
            children: [
              Padding(padding: EdgeInsets.only(left:  otherCondition && !(screenWidth < minWidth)?8:14 ,),child:  topBar ?? SizedBox.shrink(),)
            ,
              secondChild
            ],
          ),
          otherCondition && !(screenWidth < minWidth)
              ? SizedBox.shrink()
              : Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                      onTap: () {
                        if (screenWidth < minWidth) {
                          //print('small');
                          if (sKey.currentState != null &&
                              !sKey.currentState!.isDrawerOpen) {
                            sKey.currentState!.openDrawer();
                          }
                          return;
                        }

                        fun!(true);
                      },
                      child: Icon(Icons.menu_sharp)))
        ],
      ),
    );
