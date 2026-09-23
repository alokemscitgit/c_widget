 
import 'package:c_widget/c_widget.dart';
import 'package:c_widget/const/theme/colors.dart';
import 'package:c_widget/const/theme/theme.dart';
import 'package:c_widget/const/widget/c_cuper_alert.dart';
import 'package:c_widget/const/widget/c_dialog.dart';
import 'package:c_widget/const/widget/c_extention.dart';
import 'package:c_widget/const/widget/c_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'const/widget/c_accordion.dart';
import 'const/widget/c_checkbox.dart';
import 'const/widget/c_datepicker.dart';
import 'const/widget/c_dropdown.dart';
import 'const/widget/c_front_page.dart';
import 'const/widget/c_groupbox.dart';
import 'const/widget/c_header_with_child.dart';
import 'const/widget/c_hover_container.dart';
import 'const/widget/c_expanded_panel.dart';

import 'const/widget/c_responsive_grid.dart';
import 'const/widget/c_scrollable_panel.dart';
 

import 'const/widget/c_tab_button.dart';
import 'const/widget/c_tab_menu_bar.dart';
import 'const/widget/c_table.dart';
import 'const/widget/c_textbox.dart';
import 'const/widget/c_tool.dart';

class body2 extends StatefulWidget {
  const body2({super.key});
  @override
  State<body2> createState() => _body2State();
}

class _body2State extends State<body2> {
  bool b = true;
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Drawer(
        width: 220,
        child: _deawer(context, _updateLeftPanel, b, sKey),
      ),
      body: _body2(context, _updateLeftPanel, b, sKey),
    );
  }

  void _updateLeftPanel(bool value) {
    setState(() {
      b = value;
    });
  }
}

_body2(BuildContext context, Function(bool b) fun, bool k,
    GlobalKey<ScaffoldState> sKey) {
      // final headerBgColor =
      //    Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? AppThemeColors.primary(context);
  var w = MediaQuery.of(context).size.width;
  double w2 = 1000;
  final ScrollController scrollController=ScrollController();
  // var color = AppThemeColors.secondary(context);
  // print(k);
  return BlocProvider(
      create: (context) => MenuItemBloc(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: c_frontPage(
            firstChild: _deawer(context, fun, k, sKey),
            sKey: sKey,
            secondChild: Expanded(
              child: Column(
                children: [
          // Builder(builder: (context)=> context.read<MenuItemBloc>().state.menuitem.isEmpty && (  !k||  (w < w2))?12.h:SizedBox.shrink(),),
                 // Divider(),
                   Row(
                     children: [
                       Expanded(
                         child: Padding(
                           padding:   EdgeInsets.only(left:(  !k||  (w < w2))? 24:0),
                           child: Container(
                           padding: EdgeInsets.only(top: 4,bottom: 4,left: 4),
                            decoration: BoxDecoration(
                                       color: context.color.scaffoldBackground,
                                       
                                     //   (Theme.of(context).brightness == Brightness.dark)
                                     // ? Colors.grey[700]!
                                     // : Colors.white,
                                    
                                       borderRadius: BorderRadius.only(topRight: Radius.circular(4)),
                                     boxShadow: [
                                       BoxShadow(
                                         color: safeOutlineBorder(context).borderSide.color,
                                         spreadRadius: 0,blurRadius: 2,
                                         offset: Offset(0, 1.5)
                               
                                       )
                                     ]
                                       
                                       ),
                             child:    Builder(
                               builder: (context) {
                                 return Row(children: [
                                  CTool(
                                                    menu: ToolMenuSet.divider,
                                                  ),
                                      CTool(
                                                    menu: ToolMenuSet.file,
                                                    isDisable: true,
                                                  ),
                                      CTool(
                                                    menu: ToolMenuSet.divider,
                                                  ),
                                      CTool(
                                                    menu: ToolMenuSet.edit,
                                                  ),
                                                  CTool(
                                                    menu: ToolMenuSet.divider,
                                                  ),
                                                  CTool(
                                                    menu: ToolMenuSet.save,
                                                    onTap: () {
                                                      context
                                      .read<MenuItemBloc>()
                                      .add(ItemMenuAdd(menuitem: ItemModel(id: DateTime.now().millisecondsSinceEpoch.toString() ,name: 'Aloke'+context.read<MenuItemBloc>().state.menuitem.length.toString())));
                                                    },
                                                  ),
                                                   CTool(
                                                    menu: ToolMenuSet.divider,
                                                  ),
                                                  CTool(
                                                    menu: ToolMenuSet.update,
                                                    isDisable: true,
                                                  ),
                                                   CTool(
                                                    menu: ToolMenuSet.divider,
                                                  ),
                                                   CTool(
                                                    menu: ToolMenuSet.close,
                                                  ),
                                                     ],);
                               }
                             )
                               
                           ),
                         ),
                       ),
                     ],
                   ),
                 
                  Expanded(child: SingleChildScrollView(child: HospitalFormUI())),
                ],
              ),
            ),
            fun: fun,
            minWidth: w2,
            otherCondition: k,
            screenWidth: w,
            
            
            topBar:   Align(
              alignment: Alignment.centerLeft,
              child: CTabMenuBar(scrollController: scrollController,)) 
            
            // Row(children: [
            //   CTabButton(
            //                   text: 'Testing 123',
            //                   isSelected: false,
            //                   isCrossButton: true,
            //                   buttonClick: () {},
            //                   crossButtonClick: () {},
            //                 ),
            //                 CTabButton(
            //                   text: 'Testing ',
            //                   isSelected: true,
            //                   isCrossButton: true,
            //                   buttonClick: () {},
            //                   crossButtonClick: () {},
            //                 ),
            //                 CTabButton(
            //                   text: 'Testing ',
            //                   isSelected: false,
            //                   isCrossButton: true,
            //                   buttonClick: () {},
            //                   crossButtonClick: () {},
            //                 )],)
          ),
     
        ),
      ],
    ),
  );
}

_deawer(BuildContext context, Function(bool b) fun, bool k,
    GlobalKey<ScaffoldState> sKey) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final currentKey = Provider.of<ThemeProvider>(context).themeKey;
  return Container(
      decoration: BoxDecoration(
          color: context.color.scaffoldBackground.withOpacity(0.9),
          borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: context.color.secondary .withOpacity(0.99),
                spreadRadius: 0,
                blurRadius: 2.5)
          ]),
      child: Stack(
        children: [
          Column(
            children: [
               
              10.h,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //const Divider(),
                      _buildThemeButton(context, themeProvider, 'Light Green',
                          AppThemeKeys.lightGreen, currentKey),
                      _buildThemeButton(context, themeProvider, 'Blue Theme',
                          AppThemeKeys.blue, currentKey),
                      _buildThemeButton(context, themeProvider, 'Dark Mode',
                          AppThemeKeys.dark, currentKey),
                      _buildThemeButton(context, themeProvider, 'Min tGlass',
                          AppThemeKeys.mintGlass, currentKey),
                      _buildThemeButton(context, themeProvider, 'coolGrey',
                          AppThemeKeys.coolGrey, currentKey),
                      _buildThemeButton(context, themeProvider, 'sunsetRed',
                          AppThemeKeys.sunsetRed, currentKey),
                      _buildThemeButton(context, themeProvider, 'royalGold',
                          AppThemeKeys.royalGold, currentKey),
                      _buildThemeButton(context, themeProvider, 'TinyGreen',
                          AppThemeKeys.tinyhtGreen, currentKey),
                      _buildThemeButton(context, themeProvider, 'Purple',
                          AppThemeKeys.purple, currentKey),
                      _buildThemeButton(context, themeProvider, 'Orange',
                          AppThemeKeys.orange, currentKey),
                    ],
                  ),
                ),
              ),
            ],
          ),
       Positioned(
        top: 2,
        right: 2,
        child: InkWell(
                  onTap: () {
                    if (sKey.currentState != null &&
                        sKey.currentState!.isDrawerOpen) {
                      sKey.currentState!.closeDrawer();

                      // return;
                    }
                    fun(false);
                  },
                  child: Icon(Icons.menu_open)))
       
        ],
      ));
}

Widget _buildThemeButton(BuildContext context, ThemeProvider provider,
    String title, AppThemeKeys key, AppThemeKeys currentKey) {
  return ListTile(
    title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    trailing: currentKey == key ? Icon(Icons.check_circle) : null,
    onTap: () => provider.setTheme(key),
  );
}

class HospitalFormUI extends StatelessWidget {
  final TextEditingController _nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _idController =
      TextEditingController(text: '1004');
  final TextEditingController _idtesting = TextEditingController();
  var chk = false;
  // A small content box to represent a 'GroupBox'
  Widget _buildGroupBox(BuildContext context) {
    List<c> _list =
        List.generate(5, (i) => c(id: i.toString(), name: "Name $i"));
    return Card(
      // Card Color uses the GroupBox color from the theme
      elevation: 1,
      //margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
              const SizedBox(height: 15),
                CTextBox(
                  controller: _idtesting,
                  width: double.infinity,
                  label: 'Passwords',
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                CTextBox(
                  controller: TextEditingController(),
                  width: double.infinity,
                  isDisable: true,
                  label: 'Disabled',
                ),
              const SizedBox(height: 15),
                CTextBox(
                  controller: TextEditingController(),
                  width: double.infinity,
                  isError: true,
                  label: 'Error',
                ),
            const SizedBox(height: 15),
                CTextBox(
                  controller: TextEditingController(),
                  width: double.infinity,
                  isReadonly: true,
                  label: 'Readonly',
                ),
               const SizedBox(height: 15),
                CTextBox(
                  controller: _idtesting,
                  width: double.infinity,
                  label: 'Search',
                  isSearchBox: true,
                ),
                const SizedBox(height: 15),
                CTextBox(
                    controller: _idtesting,
                    width: double.infinity,
                    label: 'Passwords'),
                const SizedBox(height: 15),
                CDatePicker(controller: TextEditingController()),
                const SizedBox(height: 15),
                Row(
                  children: [
                    CDropDown(
                      isDisable: true,
                      id: null,
                      list: List.generate(
                          5, (i) => c(id: i.toString(), name: "Name $i")),
                      onTap: (v) {},
                      // isError: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
          
          //Row(children: [CustomGroupBox(children: [],)],),
          
                Row(
                  children: [
                    Flexible(
                        child: SizedBox(
                      width: 800,
                      // height: 200,
                      child: CGroupBox(
                        headerText: 'Password :: ',
                        padding: EdgeInsets.all(12),
                        children: [
                          Text(
                            'Widget Details',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Divider(),
                          CDatePicker(controller: TextEditingController()),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CHeaderWithChild(
                                    expandChild: true,
                                    caption: 'Text',
                                    child: CTextBox(
                                        borderRadious: BorderRadius.only(
                                            bottomRight: Radius.circular(4),
                                            topRight: Radius.circular(4)),
                                        controller: TextEditingController())),
                              ),
                              10.h,
                              CTextBox(controller: TextEditingController()),
                              10.h,
                              CDatePicker(
                                  isDisable: true,
                                  controller: TextEditingController())
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              // CSearchableDropdown<c>(
                              //     //  isDisable: true,
                              //     isDownIcon: true,
                              //     label: 'Search Text',
                              //     width: 100,
                              //     callback: (v) => Text(v.name ?? ''),
                              //     suggestionList: (s) => _list
                              //         .where((e) => (e.name ?? '')
                              //             .toUpperCase()
                              //             .contains(s.toUpperCase()))
                              //         .toList(),
                              //     onSelected: (v) {},
                              //     controller: TextEditingController(),
                              //     focusNode: FocusNode()),
                              // 15.h,
                              Flexible(
                                child: CDropDown(
                                  id: null,
                                  list: List.generate(5,
                                      (i) => c(id: i.toString(), name: "Name $i")),
                                  onTap: (v) {},
                                  width: 100,
                                ),
                              ),
                              Flexible(
                                  child: CTextBox(
                                      controller: TextEditingController())),
                              Flexible(
                                  child: CDatePicker(
                                      controller: TextEditingController()))
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                15.h,
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.1)),
                          child: Row(
                            children: [
                              CTool(
                                menu: ToolMenuSet.edit,
                              ),
                              CTool(
                                menu: ToolMenuSet.divider,
                              ),
                              CTool(
                                menu: ToolMenuSet.save,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              CTabButton(
                                text: 'Testing ',
                                isSelected: false,
                                isCrossButton: true,
                                buttonClick: () {},
                                crossButtonClick: () {},
                              ),
                              CTabButton(
                                text: 'Testing ',
                                isSelected: true,
                                isCrossButton: true,
                                buttonClick: () {},
                                crossButtonClick: () {},
                              ),
                              CTabButton(
                                text: 'Testing ',
                                isSelected: false,
                                isCrossButton: false,
                                buttonClick: () {},
                                crossButtonClick: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          //             SizedBox(
          //               height: 15,
          //             ),
          
                CTreeNode(
                  isSpashColor: false,
                  textSize: 14,
                  leftPad: 12,
                  title: "Accounts",
                  isSurfix: true,
                  children: [
                    CTreeNode(
                        paddingBottom: 0, leftPad: 18, title: "Cash", children: []),
                    CTreeNode(
                        iconSize: 14,
                        textSize: 11,
                        paddingBottom: 0,
                        leftPad: 18,
                        title: "Bank",
                        children: []),
                  ],
                ),
                15.h,
                CAccordion(height: 150, width: 800, header: 'View', children: [
                  Expanded(
                    child: CScrollablePanel(
                      minWidth: 600,
                      // isVerticalScroll: true,
                      children: [
                        // Container(width: 700, height: 100,color: Colors.amber,)
                        Expanded(
                          child: CustomTableGeneratorFaster(
                            //  scrollBody: false,
                            //  minWidth: 1300,
                            colWidths: [100, 150],
                            headers: [
                              // Text('data'),Text('data')
                              'Name'.tableCol.asThemeM(context).bold.widget,
                              'Address'.tableCol.asThemeM(context).bold.widget
                            ],
                            rows: [
                              ...List.generate(
                                  20,
                                  (i) => TableRow(
                                          decoration: BoxDecoration(),
                                          children: [
                                            'Name'
                                                .tableCell
                                                .asThemeS(context)
                                                .widget,
                                            'Address'
                                                .tableCell
                                                .asThemeS(context)
                                                .widget
                                          ]))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
                15.h,
                CAccordion(height: 250, width: 800, header: 'View', children: [
                  Expanded(
                    child: CScrollablePanel(
                      minWidth: 600,
                      // isVerticalScroll: true,
                      children: [
                        // Container(width: 700, height: 100,color: Colors.amber,)
                        Expanded(
                          child: CResizableTable(
                            cellPading: EdgeInsets.zero,
                            colwith: [50, 400, 50, 100],
                            headers: ["ID", "Name", "Qty", "Price"],
                            data: [
                              [
                                Text("1"),
                                Text("Cable Tie"),
                                Text("100"),
                                Text("1")
                              ],
                              [
                                Text("1"),
                                Text("Cable Tie"),
                                Text("100"),
                                Text("1")
                              ],
                              [
                                Text("1"),
                                CTextBox(
                                  label: '',
                                  controller: TextEditingController(),
                                  height: 18,
                                  borderRadious: BorderRadius.all(Radius.zero),
                                ),
                                Text("100"),
                                Text("1")
                              ],
                            ],
                          ),
                        ),
                        15.h,
                        Row(
                          children: [
                            CTextBox(controller: TextEditingController()),
                            25.w,
                            CPoppUpMenu(
                              iconWidget: Text('Menu'),
                              menuList: List.generate(
                                  100,
                                  (i) => PopupMenuItem(
                                      child: CustopPopUpItemList(
                                          'Abcd wrw etrwet eryerwy ery',
                                          Icons.co_present_sharp))),
                            )
                          ],
                        ),
                        15.h,
                        CDropDown(
                          id: null,
                          list: List.generate(
                              5, (i) => c(id: i.toString(), name: "Name $i")),
                          onTap: (v) {},
                          isError: true,
                        ),
                      ],
                    ),
                  )
                ]),
                20.h,
          
                SizedBox(
                    height: 500,
                    child: SingleChildScrollView(
                      child: CResponsiveGrid(
                          breakpoints: RB({
                            1: 0,
                            2: 700,
                            3: 1200,
                            4: 1600,
                            5: 2000,
                          }),
                          screenWidth: MediaQuery.of(context).size.width,
                          children: List.generate(
                              10,
                              (i) => Container(
                                    width: 200,
                                    height: 80,
                                    color: Colors.amber,
                                  ))),
                    )),
                15.h,
          
                Row(
                  children: [
                    CCheckbox(
                      label: 'Testing',
                      initialValue: chk,
                      onChanged: (value) {
                        chk = value;
                      },
                    )
                  ],
                ),
                15.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _customDialog(context);
                      },
                      child: const Text('Save Data'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text('Cancel',
                          style: TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildGroupBox(context),
        const SizedBox(height: 30),

        // Example of a second form element/section
        Text(
          'Approval Status',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
        const SizedBox(height: 10),

        SwitchListTile(
          title: const Text('Manager Approval Required'),
          value: true,
          onChanged: (bool value) {},
          // Color of the active switch uses the theme's primaryColor
          activeColor: Theme.of(context).primaryColor,
        ),

        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  CCupertinoAlertWithYesNo(
                      context,
                      Text('?'),
                      Column(
                        children: [],
                      ));
                },
                // style: ElevatedButton.styleFrom(
                //   minimumSize: const Size(double.infinity ),
                // ),
                child: const Text('SUBMIT FINAL APPROVAL'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

_customDialog(BuildContext context) => CDialog(
      context,
      'Dialog::  ',
      SizedBox(
        width: 500,
        height: 1200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.red,
                    // Colors.orange,
                    // Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ],
                ).createShader(bounds),
                child: Text(
                  "Aloke ",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              15.h,
              CHoverMaskContainer(
                  child:
                      ElevatedButton(onPressed: () {}, child: Text('Click'))),
              CHoverMaskContainer(
                  child: CDropDown(
                id: null,
                list: [],
                onTap: (value) {},
              ))
            ],
          ),
        ),
      ),
      onClose: () => print('Close button pressed!'),
      onSave: () => print('Save button pressed!'),
    );

class c {
  String? id;
  String? name;
  c({
    this.id,
    this.name,
  });
}

Widget CustopPopUpItemList(String name, IconData icon) {
  final ValueNotifier<bool> isHovered = ValueNotifier(false);

  return MouseRegion(
    onEnter: (_) => isHovered.value = true,
    onExit: (_) => isHovered.value = false,
    child: ValueListenableBuilder<bool>(
      valueListenable: isHovered,
      builder: (context, hover, child) {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hover
                      ? context.color.hoverBg
                      : context.color.normalBg,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: hover
                  //         ? AppThemeColors.primary(context)
                  //         : AppThemeColors.primary(context).withOpacity(0.2),
                  //     spreadRadius: hover ? 0 : -20,
                  //     blurRadius: hover ? 20 : 15,
                  //   ),
                  // ],
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: hover
                          ?context.color.hoverText
                          : context.color.normalText,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: context.style.bodySmall.style.copyWith(
                          color: hover
                              ? context.color.hoverText
                              : context.color.normalText),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
