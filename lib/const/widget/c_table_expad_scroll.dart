// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:c_widget/const/widget/c_table.dart';
import 'package:flutter/material.dart';

import 'c_scrollable_panel.dart';

class CTableExpandScrollView extends StatelessWidget {
  const CTableExpandScrollView({
    super.key,
    required this.colWidths,
    required this.headers,
    required this.rows,
    this.minWidth = 1200,
    this.bottomPad=0
  });
  final List<int> colWidths;
  final List<Widget> headers;
  final List<TableRow> rows;
  final double minWidth;
  final double bottomPad;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CScrollablePanel(minWidth: minWidth, children: [
      Expanded(
        child: CTableGeneratorFaster(
            colWidths: colWidths, headers: headers, rows: rows),
      ),
       SizedBox(height: bottomPad,)
    ]));
  }
}
