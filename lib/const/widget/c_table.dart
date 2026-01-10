
import 'package:flutter/material.dart';

import '../c_helper.dart';
import '../theme/colors.dart';

// ignore: must_be_immutable
class CustomTableGeneratorFaster extends StatelessWidget {
  CustomTableGeneratorFaster({
    super.key,
    required this.colWidths,
    required this.headers,
    required this.rows,
    Decoration? decorationHeader,
  });
  final List<int> colWidths;
  final List<Widget> headers;
  final List<TableRow> rows;
  Decoration? decorationHeader;

  @override
  Widget build(BuildContext context) {
    final sBorder = safeOutlineBorder(context);
    TableBorder border = TableBorder.all(
        color: sBorder.borderSide.color,
        width: sBorder.borderSide.width * .5);
    decorationHeader = decorationHeader ??
        BoxDecoration(
           border: Border.all( width: AppThemeColors.borderWidth(context) *.6,color: AppThemeColors(context).borderColor ),
          color: AppThemeColors(context).hoverBg,
          // borderRadius: BorderRadius.only(
          //     topRight:
          //         sBorder.borderRadius.topRight,
          //     topLeft:
          //         sBorder.borderRadius.topLeft),
        );
    final ScrollController _contr = ScrollController();
    return Column(
      children: [
        Table(
          border: border,
          columnWidths: _columnWidthFlex(colWidths),
          children: [
            TableRow(decoration: decorationHeader, children: headers),
          ],
        ),
        Expanded(
            child: Scrollbar(
          controller: _contr,
          child: ListView.builder(
              controller: _contr,
              itemCount: rows.length,
              itemBuilder: (context, index) {
                var x = rows[index];
                return Table(
                  border: border,
                  columnWidths: _columnWidthFlex(colWidths),
                  children: [
                    x,
                  ],
                );
              }),
        ))
      ],
    );
  }
}

Map<int, TableColumnWidth> _columnWidthFlex(List<int> widths) =>
    widths.asMap().map(
          (i, w) => MapEntry(i, FlexColumnWidth(w.toDouble())),
        );

Map<int, TableColumnWidth> columnWidthFixed(
  List<int> widths, {
  double minWidth = 1200,
  double colWidth = 0,
  bool scrollable = false,
}) {
  final sum = widths.fold<int>(0, (a, b) => a + b);
  final factor = minWidth / sum;

  return widths.asMap().map((i, w) {
    final width = colWidth == 0 && !scrollable
        ? FlexColumnWidth(w.toDouble())
        : FixedColumnWidth(
            (colWidth == 0 ? w * factor : w * colWidth).toDouble());

    return MapEntry(i, width);
  });
}

class _CustomTableHeaderWeb extends StatelessWidget {
  const _CustomTableHeaderWeb({
    super.key,
    required this.colWidths,
    required this.children,
    this.fixed = false,
    this.minWidth = 1200,
    this.transparent = false,
    this.fixedColWidth = 0,
    this.scrollable = false,
  });

  final List<int> colWidths;
  final List<Widget> children;
  final bool fixed;
  final double minWidth;
  final bool transparent;
  final double fixedColWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeColors(context);

    return Table(
      border: TableBorder.all(
        color: theme.borderColor,
        width: AppThemeColors.borderWidth(context) * .5,
      ),
      columnWidths: fixed
          ? columnWidthFixed(
              colWidths,
              minWidth: minWidth,
              colWidth: fixedColWidth,
              scrollable: scrollable,
            )
          : _columnWidthFlex(colWidths),
      children: [
        TableRow(
          decoration: transparent
              ? null
              : BoxDecoration(
                  color: theme.hoverBg,
                  borderRadius: BorderRadius.only(
                    topLeft: AppThemeColors.inputBorder(context)
                        .borderRadius
                        .topLeft,
                    topRight: AppThemeColors.inputBorder(context)
                        .borderRadius
                        .topRight,
                  ),
                ),
          children: children,
        ),
      ],
    );
  }
}

class CustomTableGenerator extends StatelessWidget {
  const CustomTableGenerator({
    super.key,
    required this.colWidths,
    required this.headers,
    required this.rows,
    this.scrollBody = true,
    this.fixed = false,
    this.minWidth = 1200,
    this.oneColumnResponsive = false,
    this.fixedColWidth = 0,
    this.wideScrollable = false,
  });

  final List<int> colWidths;
  final List<Widget> headers;
  final List<TableRow> rows;

  final bool scrollBody;
  final bool fixed;
  final bool oneColumnResponsive;
  final double minWidth;
  final double fixedColWidth;
  final bool wideScrollable;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeColors(context);
    final ScrollController _scrollController = ScrollController();
    final border = TableBorder.all(
      color: theme.borderColor,
      width: AppThemeColors.borderWidth(context) * .8,
    );

    final widths = fixed
        ? columnWidthFixed(
            oneColumnResponsive ? [1] : colWidths,
            minWidth: minWidth,
            colWidth: fixedColWidth,
            scrollable: wideScrollable,
          )
        : _columnWidthFlex(colWidths);

    final table = Table(
      border: border,
      columnWidths: widths,
      children: rows,
    );

    return Column(
      children: [
        if (headers.isNotEmpty)
          _CustomTableHeaderWeb(
            colWidths: colWidths,
            children: headers,
            fixed: fixed,
            minWidth: minWidth,
            fixedColWidth: fixedColWidth,
            scrollable: wideScrollable,
          ),
        scrollBody
            ? Expanded(
                child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController, child: table)))
            : table,
      ],
    );
  }
}




class CResizableTable extends StatefulWidget {
  final List<double>? colwith;
  final List<String> headers;
  final List<List<Widget>> data;
  final EdgeInsets? cellPading;
  const CResizableTable({
    super.key,
    this.colwith,
    this.cellPading,
    required this.headers,
    required this.data,
  });

  @override
  State<CResizableTable> createState() => _CResizableTableState();
}

class _CResizableTableState extends State<CResizableTable> {
  late List<double> colWidths;
  final ScrollController _hScroll = ScrollController();
  final ScrollController _vScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    colWidths = widget.colwith == null
        ? List<double>.filled(widget.headers.length, 150)
        : widget.colwith!;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _hScroll,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _hScroll,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Scrollbar(
                controller: _vScroll,
                thumbVisibility: true,
                child: SizedBox(
                  width: _tableWidth(),
                  child: _buildRows(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _tableWidth() {
    return colWidths.fold(0, (sum, w) => sum + w);
  }

  Widget _buildHeader() {
    // TableBorder border = TableBorder.all(
    //     color: AppThemeColors(context).borderColor,
    //     width: AppThemeColors.borderWidth(context) * .5);
    var sBoder = safeOutlineBorder(context);
    BoxDecoration decoration = BoxDecoration(
      // border: Border.all( width: AppThemeColors.borderWidth(context) *.6,color: AppThemeColors(context).borderColor ),
      color: AppThemeColors(context).hoverBg,
      border: Border.all(
          width: sBoder.borderSide.width * .8, color: sBoder.borderSide.color),
    );

    return Row(
      children: List.generate(widget.headers.length, (index) {
        return Stack(
          children: [
            Container(
              width: colWidths[index],
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: decoration,
              child: Text(
                widget.headers[index],
                style: AppThemeColors.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primary(context)),
              ),
            ),

            /// ------------ DRAG HANDLE -------------- ///
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      colWidths[index] += details.delta.dx;
                      if (colWidths[index] < 60) colWidths[index] = 60;
                    });
                  },
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildRows() {
    var sBorder = safeOutlineBorder(context);
    return ListView.builder(
      controller: _vScroll,
      itemCount: widget.data.length,
      itemBuilder: (context, rowIndex) {
        return Row(
          children: List.generate(widget.data[rowIndex].length, (colIndex) {
            return Container(
              width: colWidths[colIndex],
              padding: widget.cellPading ??
                  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                    width: sBorder.borderSide.width * .5,
                    color: sBorder.borderSide.color),
              ),
              child: widget.data[rowIndex][colIndex],
            );
          }),
        );
      },
    );
  }
}
