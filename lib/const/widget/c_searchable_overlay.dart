import 'package:flutter/material.dart';

import 'c_textbox.dart';

class CSearchOverlay extends StatefulWidget {
  final TextEditingController controller;
  final Widget icon;
  final double width;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final void Function(String)? onChange;
  final bool isHover;
  final String label;
  final bool clearTextControlOnOpen;
  const CSearchOverlay(
      {super.key,
      required this.controller,
      this.icon = const Icon(
        Icons.search,
        size: 22,
      ),
      this.width = 320,
      this.onEditingComplete,
      this.onSubmitted,
      this.onChange,
      this.isHover = true,
      this.label = '',this.clearTextControlOnOpen=false});

  @override
  State<CSearchOverlay> createState() => _CSearchOverlayState();
}

// class _CSearchOverlayState extends State<CSearchOverlay>
//     with SingleTickerProviderStateMixin {
//   final FocusNode _focusNode = FocusNode();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   bool _isOpen = false;

//   // Animation Controller
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.3, 0), // Starts slightly to the right
//       end: Offset.zero, // Ends at its natural position
//     ).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.easeOutQuart));

//     _opacityAnimation =
//         CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

//     _focusNode.addListener(() {
//       if (!_focusNode.hasFocus && _isOpen) _toggleOverlay();
//     });
//   }

//   void _toggleOverlay() async {
//     if(widget.clearTextControlOnOpen){
//       widget.controller.text = '';
//     }
    
//     if (_isOpen) {
//     //   if(widget.clearTextControlOnOpen){
//     //   widget.controller.text = '';
//     //  }
//       // Run animation backwards then remove
//       await _animationController.reverse();
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//       if (mounted) setState(() => _isOpen = false);
//     } else {
//       _overlayEntry = _createOverlayEntry();
//       Overlay.of(context).insert(_overlayEntry!);
//       setState(() => _isOpen = true);

//       _animationController.forward(); // Run animation forwards
//       _focusNode.requestFocus();
//     }
//   }

//   OverlayEntry _createOverlayEntry() {
//     return OverlayEntry(
//       builder: (context) => Positioned(
//         width: MediaQuery.of(context).size.width < (widget.width + 20)
//             ? MediaQuery.of(context).size.width - 20
//             : widget.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: const Offset(-300, 40),
//           child: FadeTransition(
//             opacity: _opacityAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: TapRegion(
//                 onTapOutside: (event) {
//                   if (_isOpen) _toggleOverlay();
//                 },
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(50),
//                   child: CTextBox(
//                     label: widget.label,
//                     controller: widget.controller,
//                     focusNode: _focusNode,
//                     width: widget.width,
//                     isSearchBox: true,
//                     isAutofocus: true,
//                     onChange: (v) => widget.onChange?.call(v),
//                     onEditingComplete: () => widget.onEditingComplete?.call(),
//                     onSubmitted: (p0) => widget.onSubmitted?.call(p0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: !widget.isHover
//           ? IconButton(
//               visualDensity: VisualDensity.compact,
//               padding: EdgeInsets.zero,
//               hoverColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               focusColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               icon: widget.icon,
//               constraints: const BoxConstraints(
//                 maxHeight: 20, // Set custom width
//                 maxWidth: 20, // Set custom height
//               ),
//               iconSize: 18,
//               onPressed: _toggleOverlay,
//             )
//           : IconButton(
//               visualDensity: VisualDensity.standard,
//               padding: EdgeInsets.all(4),
//               constraints: const BoxConstraints(
//                 maxHeight: 28, // Set custom width
//                 maxWidth: 28, // Set custom height
//               ),
//               iconSize: 16,
//               icon: widget.icon,
//               onPressed: _toggleOverlay,
//             ),
//     );
//   }
// }

class _CSearchOverlayState extends State<CSearchOverlay>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  // Animation Controller
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutQuart));

    _opacityAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;
    if (!_focusNode.hasFocus && _isOpen) {
      _toggleOverlay();
    }
  }

  void _toggleOverlay() async {
    if (widget.clearTextControlOnOpen) {
      widget.controller.text = '';
    }

    if (_isOpen) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    } else {
      // Ensure focus node is valid before requesting focus
      if (!_focusNode.hasFocus) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
        _focusNode = FocusNode();
        _focusNode.addListener(_handleFocusChange);
      }
      
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) setState(() => _isOpen = true);

      _animationController.forward();
      _focusNode.requestFocus();
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width < (widget.width + 20)
            ? MediaQuery.of(context).size.width - 20
            : widget.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-300, 40),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: TapRegion(
                onTapOutside: (event) {
                  if (_isOpen) _toggleOverlay();
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(50),
                  child: CTextBox(
                    label: widget.label,
                    controller: widget.controller,
                    focusNode: _focusNode,
                    width: widget.width,
                    isSearchBox: true,
                    isAutofocus: true,
                    onChange: (v) => widget.onChange?.call(v),
                    onEditingComplete: () => widget.onEditingComplete?.call(),
                    onSubmitted: (p0) => widget.onSubmitted?.call(p0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: !widget.isHover
          ? IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: widget.icon,
              constraints: const BoxConstraints(
                maxHeight: 20,
                maxWidth: 20,
              ),
              iconSize: 18,
              onPressed: _toggleOverlay,
            )
          : IconButton(
              visualDensity: VisualDensity.standard,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                maxHeight: 28,
                maxWidth: 28,
              ),
              iconSize: 16,
              icon: widget.icon,
              onPressed: _toggleOverlay,
            ),
    );
  }
}