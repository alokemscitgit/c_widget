import 'dart:async'; 

import 'package:c_widget/const/widget/c_tab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../theme/colors.dart';

// --- 1. Model (No change needed) ---

class ItemModel {
  final String id;
  final String name;

  ItemModel({required this.id, required this.name});
}

// --- 2. State Classes (Added 'const' to constructors) ---

abstract class ItemMenuState extends Equatable {
  final List<ItemModel> menuitem;
  final String currentID;

  const ItemMenuState({
    required this.menuitem,
    required this.currentID,
  });

  @override
  List<Object?> get props => [menuitem, currentID];
}

class ItemMenuInit extends ItemMenuState {
  const ItemMenuInit() : super(menuitem: const [], currentID: '');
}

class ItemMenuAdded extends ItemMenuState {
  const ItemMenuAdded({
    required super.menuitem,
    required super.currentID,
  });
}

// --- 3. Event Classes (No change needed) ---

abstract class ItemMenuEvent {}

class ItemMenuAdd extends ItemMenuEvent {
  final ItemModel menuitem;
  ItemMenuAdd({required this.menuitem});
}

class ItemMenuDelete extends ItemMenuEvent {
  final ItemModel menuitem;
  ItemMenuDelete({required this.menuitem});
}

class ItemMenuSetCurrent extends ItemMenuEvent {
  final String id;
  ItemMenuSetCurrent({required this.id});
}
// --- 4. Bloc Logic (Crucial corrections here) ---

// Assuming Bloc is imported
class MenuItemBloc extends Bloc<ItemMenuEvent, ItemMenuState> {
  MenuItemBloc() : super(const ItemMenuInit()) {
    on<ItemMenuAdd>(_addItem);
    on<ItemMenuDelete>(_deleteItem);
    on<ItemMenuSetCurrent>(_setCurrentID);
  }

  FutureOr<void> _setCurrentID(
      ItemMenuSetCurrent event, Emitter<ItemMenuState> emit) {
    emit(ItemMenuAdded(
      menuitem: state.menuitem,
      currentID: event.id,
    ));
  }

  FutureOr<void> _addItem(ItemMenuAdd event, Emitter<ItemMenuState> emit) {
    final exists = state.menuitem.any((e) => e.id == event.menuitem.id);

    List<ItemModel> updatedList;

    if (exists) {
      // Item already exists → keep list unchanged
      updatedList = state.menuitem;
    } else {
      // Item does not exist → add new item
      updatedList = [...state.menuitem, event.menuitem];
    }

    emit(ItemMenuAdded(
      menuitem: updatedList,
      currentID: event.menuitem.id, // Always select the item
    ));
  }

  FutureOr<void> _deleteItem(
      ItemMenuDelete event, Emitter<ItemMenuState> emit) {
    final deletedId = event.menuitem.id;
    final currentId = state.currentID;

    // Remove the item
    final updatedList = state.menuitem.where((e) => e.id != deletedId).toList();

    String newCurrentID;

    if (currentId == deletedId) {
      // Deleted item was selected → select last item OR empty
      newCurrentID = updatedList.isNotEmpty ? updatedList.last.id : '';
    } else {
      // Deleted item was not selected → keep same selection
      newCurrentID = currentId;
    }

    emit(ItemMenuAdded(
      menuitem: updatedList,
      currentID: newCurrentID,
    ));
  }
}

// --- 5. Widget (Minor corrections) ---

// Assuming StatelessWidget and needed imports are present
class CTabMenuBar extends StatelessWidget {
  final ScrollController scrollController;

  const CTabMenuBar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuItemBloc, ItemMenuState>(
      builder: (context, state) {
        if (state.menuitem.isEmpty) return const SizedBox();

        final itemList = state.menuitem;
        final kTabButtonHeight = calculateHeight(context);

        return SizedBox(
          height: kTabButtonHeight,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: itemList.asMap().entries.map((entry) {
                final index = entry.key;
                final menuitem = entry.value;
                final bool isSelected = (state is ItemMenuAdded)
                    ? state.currentID == menuitem.id
                    : false;

                return Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                  child: CTabButton(
                    isSelected: isSelected,
                    isCrossButton: true,
                    text: menuitem.name,
                    buttonClick: () {
                      context.read<MenuItemBloc>().add(
                            ItemMenuSetCurrent(id: menuitem.id),
                          );

                      // Scroll to selected tab
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          index * 100.0, // approximate width per tab
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    crossButtonClick: () {
                      context.read<MenuItemBloc>().add(
                            ItemMenuDelete(menuitem: menuitem),
                          );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

double calculateHeight(BuildContext context) {
  const double kVerticalPadding = 2.0;

  // Recalculate the text style used in the build method
  final textStyle = AppThemeColors.bodySmall(context).copyWith(
    fontSize: (AppThemeColors.bodySmall(context).fontSize ?? 9.5) * .75,
  );
  final double textHeightEstimate =
      textStyle.fontSize! * (textStyle.height ?? 1.2);

  final double requiredHeight = textHeightEstimate +
      (kVerticalPadding * 2) +
      (AppThemeColors.borderWidth(context) * 2);
  return requiredHeight;
}

class CTabMenuBar1 extends StatelessWidget {
  final ScrollController scrollController;
 final void Function(ItemModel menuitem)? onCrossClick;
  const CTabMenuBar1(
      {super.key, required this.scrollController, this.onCrossClick});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuItemBloc, ItemMenuState>(
      builder: (context, state) {
        if (state.menuitem.isEmpty) return const SizedBox();

        final itemList = state.menuitem;
        final kTabButtonHeight = calculateHeight(context);

        return SizedBox(
          height: kTabButtonHeight,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: itemList.asMap().entries.map((entry) {
                final index = entry.key;
                final menuitem = entry.value;
                final bool isSelected = (state is ItemMenuAdded)
                    ? state.currentID == menuitem.id
                    : false;

                return Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                  child: CTabButton(
                    isSelected: isSelected,
                    isCrossButton: true,
                    text: menuitem.name,
                    buttonClick: () {
                      context.read<MenuItemBloc>().add(
                            ItemMenuSetCurrent(id: menuitem.id),
                          );

                      // Scroll to selected tab
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          index * 100.0, // approximate width per tab
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    crossButtonClick: () {
                      context.read<MenuItemBloc>().add(
                            ItemMenuDelete(menuitem: menuitem),
                          );
                     onCrossClick?.call(menuitem);
                      //deleteController(menuitem.id);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
