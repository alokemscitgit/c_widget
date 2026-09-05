 
import 'package:flutter/material.dart';

class COverlay extends StatefulWidget {
  final Widget child;
  final Widget icon;
  final double width;
  final double iconSize;
  final double borderRadious;
  final COverlayController? controller;
  final bool isCloseOutsideClick;
  final bool isNotDispose;
  final Color? bgColor;
  final double maxHeight; // Added max height safety limit

  const COverlay({
    super.key,
    required this.child,
    this.icon = const Icon(Icons.search),
    this.width = 370,
    this.controller,
    this.borderRadious = 8,
    this.iconSize = 16,
    this.isCloseOutsideClick = true,
    this.isNotDispose = false,
    this.bgColor,
    this.maxHeight = 350.0, // Default max height limit
  });

  @override
  State<COverlay> createState() => _COverlayState();
}

class _COverlayState extends State<COverlay>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _openUpwards = false;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacityAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) close();
    });
  }

  Future<void> close() async {
    if (_isOpen && mounted) {
      if (_animationController.isAnimating || _animationController.isCompleted) {
        await _animationController.reverse();
      }

      _overlayEntry?.remove();
      _overlayEntry = null;

      if (mounted) {
        setState(() => _isOpen = false);
      }
    }
  }

  void _toggleOverlay() async {
    if (_isOpen) {
      await close();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) setState(() => _isOpen = true);
      _animationController.forward();
      _focusNode.requestFocus();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final screen = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return OverlayEntry(builder: (_) => const SizedBox.shrink());

    final iconPos = box.localToGlobal(Offset.zero);

    final spaceBelow = screen.height - (iconPos.dy + box.size.height) - padding.bottom;
    final spaceAbove = iconPos.dy - padding.top;

    // Decide initial opening direction BEFORE rendering frame 1
    _openUpwards = spaceBelow < widget.maxHeight && spaceAbove > spaceBelow;

    final overlayWidth =
        screen.width < (widget.width + 20) ? screen.width - 20 : widget.width;

    final iconCenterX = iconPos.dx + (box.size.width / 2);
    double left = iconCenterX - (overlayWidth / 2);
    left = left.clamp(10.0, screen.width - overlayWidth - 10.0);

    Size? overlaySize;

    return OverlayEntry(
      builder: (context) {
        return _MeasureSize(
          onChange: (size) {
            if (overlaySize != size) {
              overlaySize = size;
              _overlayEntry?.markNeedsBuild();
            }
          },
          child: Builder(builder: (context) {
            // Calculate top dynamically
            double top;
            if (_openUpwards) {
              final measuredHeight = overlaySize?.height ?? widget.maxHeight;
              top = iconPos.dy - measuredHeight - 8;
            } else {
              top = iconPos.dy + box.size.height + 8;
            }

            // Hard clamp to avoid hiding under bottom screen padding
            final maxAllowedTop = screen.height - padding.bottom - (overlaySize?.height ?? 50) - 10;
            top = top.clamp(padding.top + 10, maxAllowedTop < (padding.top + 10) ? padding.top + 10 : maxAllowedTop);

            final slideTween = Tween<Offset>(
              begin: Offset(0, _openUpwards ? -0.08 : 0.08),
              end: Offset.zero,
            );

            final slideAnimation = slideTween.animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutQuart,
            ));

            return Positioned(
              top: top,
              left: left,
              width: overlayWidth,
              child: _overlayContent(widget.bgColor, slideAnimation, spaceAbove, spaceBelow),
            );
          }),
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _focusNode.dispose();
    if (!widget.isNotDispose) {
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: widget.icon,
        iconSize: widget.iconSize,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: widget.iconSize,
          minHeight: widget.iconSize,
        ),
        onPressed: _toggleOverlay,
      ),
    );
  }

  Widget _overlayContent(Color? bgColor, Animation<Offset> slideAnimation, double spaceAbove, double spaceBelow) {
    // Limit maximum allowed vertical size based on available space
    final availableHeight = _openUpwards ? spaceAbove - 16 : spaceBelow - 16;
    final maxAllowedHeight = availableHeight < widget.maxHeight 
        ? (availableHeight > 100 ? availableHeight : 100.0) 
        : widget.maxHeight;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: TapRegion(
          onTapOutside: (_) {
            if (_isOpen && widget.isCloseOutsideClick) close();
          },
          child: Material(
            color: bgColor ?? Theme.of(context).cardColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(widget.borderRadious),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxAllowedHeight,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadious),
                child: SingleChildScrollView(
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class COverlayController {
  _COverlayState? _state;

  void _attach(_COverlayState state) {
    _state = state;
  }

  void close() => _state?.close();

  bool get isOpen => _state?._isOpen ?? false;
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final Function(Size size) onChange;

  const _MeasureSize({
    required this.child,
    required this.onChange,
  });

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = context.size;
      if (size != null && _oldSize != size) {
        _oldSize = size;
        widget.onChange(size);
      }
    });

    return widget.child;
  }
}
// class COverlay extends StatefulWidget {
//   final Widget child;
//   final Widget icon;
//   final double width;
//   final double iconSize;
//   final double borderRadious;
//   final COverlayController? controller;
//   final bool isCloseOutsideClick;
//   final bool isNotDispose;
//   final Color? bgColor;

//   const COverlay({
//     super.key,
//     required this.child,
//     this.icon = const Icon(Icons.search),
//     this.width = 370,
//     this.controller,
//     this.borderRadious = 8,
//     this.iconSize = 16,
//     this.isCloseOutsideClick = true,
//     this.isNotDispose = false,
//     this.bgColor=null
//   });

//   @override
//   State<COverlay> createState() => _COverlayState();
// }

// class _COverlayState extends State<COverlay>
//     with SingleTickerProviderStateMixin {
//   final FocusNode _focusNode = FocusNode();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   bool _isOpen = false;
//   bool _openUpwards = false;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller?._attach(this);

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutQuart,
//     ));

//     _opacityAnimation =
//         CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

//     _focusNode.addListener(() {
//       if (!_focusNode.hasFocus && _isOpen) close();
//     });
//   }

//   close() async {
//     if (_isOpen && mounted) {
//       // Guard against running animation if already unmounted
//       if (_animationController.isAnimating || _animationController.isCompleted) {
//         await _animationController.reverse();
//       }
      
//       _overlayEntry?.remove();
//       _overlayEntry = null;
      
//       if (mounted) {
//         setState(() => _isOpen = false);
//       }
//     }
//   }


//   void _toggleOverlay() async {
//     if (_isOpen) {
//       await _animationController.reverse();
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//       if (mounted) setState(() => _isOpen = false);
//     } else {
//       _overlayEntry = _createOverlayEntry();
//       Overlay.of(context).insert(_overlayEntry!);
//       if (mounted) setState(() => _isOpen = true);
//       _animationController.forward();
//       _focusNode.requestFocus();
//     }
//   }

//   OverlayEntry _createOverlayEntry() {
//     final screen = MediaQuery.of(context).size;
//     final RenderBox box = context.findRenderObject() as RenderBox;
//     final iconPos = box.localToGlobal(Offset.zero);

//     final overlayWidth =
//         screen.width < (widget.width + 20) ? screen.width - 20 : widget.width;

//     final iconCenterX = iconPos.dx + (box.size.width / 2);
//     double left = iconCenterX - (overlayWidth / 2);
//     left = left.clamp(10.0, screen.width - overlayWidth - 10.0);

//     Size? overlaySize;

//     return OverlayEntry(
//       builder: (context) {
//         return _MeasureSize(
//           onChange: (size) {
//             overlaySize = size;
//             final spaceBelow = screen.height - (iconPos.dy + box.size.height);
//             final shouldOpenUp = spaceBelow < size.height + 10;

//             if (shouldOpenUp != _openUpwards) {
//               _openUpwards = shouldOpenUp;
//               _overlayEntry?.markNeedsBuild();
//             }
//           },
//           child: Positioned(
//             top: _openUpwards && overlaySize != null
//                 ? iconPos.dy - overlaySize!.height - 8 // precise top
//                 : iconPos.dy + box.size.height + 8, // normal bottom
//             left: left,
//             width: overlayWidth,
//             child: _overlayContent(widget.bgColor),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // 1. Instantly remove overlay entry to prevent orphan overlays
//     _overlayEntry?.remove();
//     _overlayEntry = null;

//     // 2. Safely dispose focus node and animation controller
//     _focusNode.dispose();
//     if (!widget.isNotDispose) {
//       _animationController.dispose();
//     }
    
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: IconButton(
//         icon: widget.icon,
//         iconSize: widget.iconSize,
//         padding: EdgeInsets.zero,
//         constraints: BoxConstraints(
//           minWidth: widget.iconSize,
//           minHeight: widget.iconSize,
//         ),
//         onPressed: _toggleOverlay,
//       ),
//     );
//   }

//   Widget _overlayContent(Color? bgColor) {
//     return FadeTransition(
//       opacity: _opacityAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: TapRegion(
//           onTapOutside: (_) {
//             if (_isOpen && widget.isCloseOutsideClick) close();
//           },
//           child: Material(
//             color: bgColor,
//             elevation: 8,
//             borderRadius: BorderRadius.circular(widget.borderRadious),
//             child: widget.child,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class COverlayController {
//   _COverlayState? _state;

//   void _attach(_COverlayState state) {
//     _state = state;
//   }

//   void close() => _state?.close();

//   bool get isOpen => _state?._isOpen ?? false;
// }

// /// Helper widget to measure child size
// class _MeasureSize extends StatefulWidget {
//   final Widget child;
//   final Function(Size size) onChange;

//   const _MeasureSize({
//     required this.child,
//     required this.onChange,
//   });

//   @override
//   State<_MeasureSize> createState() => _MeasureSizeState();
// }

// class _MeasureSizeState extends State<_MeasureSize> {
//   Size? _oldSize;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final size = context.size;
//       if (size != null && _oldSize != size) {
//         _oldSize = size;
//         widget.onChange(size);
//       }
//     });

//     return widget.child;
//   }
// }



 

/// Controller holding the close method passed into widget.builder
class COverlayBuilderController {
  _COverlayBuilderState? _state;

  void _attach(_COverlayBuilderState state) {
    _state = state;
  }

  void close() => _state?.close();

  bool get isOpen => _state?._isOpen ?? false;
}

class COverlayBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, COverlayBuilderController obj) builder;
  final Widget icon;
  final double width;
  final double iconSize;
  final double borderRadious;
  final COverlayBuilderController? controller;
  final bool isCloseOutsideClick;
  final bool isNotDispose;
  final Color? bgColor;
  final double maxHeight;

  const COverlayBuilder({
    super.key,
    required this.builder,
    this.icon = const Icon(Icons.search),
    this.width = 370,
    this.controller,
    this.borderRadious = 8,
    this.iconSize = 16,
    this.isCloseOutsideClick = true,
    this.isNotDispose = false,
    this.bgColor,
    this.maxHeight = 350.0,
  });

  @override
  State<COverlayBuilder> createState() => _COverlayBuilderState();
}

class _COverlayBuilderState extends State<COverlayBuilder>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _openUpwards = false;

  late COverlayBuilderController _effectiveController;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _effectiveController = widget.controller ?? COverlayBuilderController();
    _effectiveController._attach(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacityAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) close();
    });
  }

  @override
  void didChangeMetrics() {
    // Triggers when window is resized or rotated
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  Future<void> close() async {
    if (_isOpen && mounted) {
      if (_animationController.isAnimating || _animationController.isCompleted) {
        await _animationController.reverse();
      }

      _overlayEntry?.remove();
      _overlayEntry = null;

      if (mounted) {
        setState(() => _isOpen = false);
      }
    }
  }

  void _toggleOverlay() async {
    if (_isOpen) {
      await close();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) setState(() => _isOpen = true);
      _animationController.forward();
      _focusNode.requestFocus();
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        // Dynamic re-calculation inside builder during rebuilds
        final mediaQuery = MediaQuery.of(context);
        final screenSize = mediaQuery.size;
        final padding = mediaQuery.padding;

        final RenderBox? box = this.context.findRenderObject() as RenderBox?;
        if (box == null || !box.attached) return const SizedBox.shrink();

        final iconPos = box.localToGlobal(Offset.zero);
        final iconHeight = box.size.height;

        final spaceBelow = screenSize.height - (iconPos.dy + iconHeight) - padding.bottom;
        final spaceAbove = iconPos.dy - padding.top;

        _openUpwards = spaceBelow < widget.maxHeight && spaceAbove > spaceBelow;

        final overlayWidth =
            screenSize.width < (widget.width + 20) ? screenSize.width - 20 : widget.width;

        final iconCenterX = iconPos.dx + (box.size.width / 2);
        double left = iconCenterX - (overlayWidth / 2);
        left = left.clamp(10.0, screenSize.width - overlayWidth - 10.0);

        final maxAvailableHeight = (_openUpwards ? spaceAbove : spaceBelow) - 12.0;
        final maxAllowedHeight = maxAvailableHeight.clamp(80.0, widget.maxHeight);

        final slideTween = Tween<Offset>(
          begin: Offset(0, _openUpwards ? 0.05 : -0.05),
          end: Offset.zero,
        );

        final slideAnimation = slideTween.animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutQuart,
        ));

        return Positioned(
          left: left,
          width: overlayWidth,
          top: _openUpwards ? null : iconPos.dy + iconHeight + 6.0,
          bottom: _openUpwards ? screenSize.height - iconPos.dy + 6.0 : null,
          child: _overlayContent(widget.bgColor, slideAnimation, maxAllowedHeight),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _overlayEntry?.remove();
    _overlayEntry = null;

    _focusNode.dispose();
    if (!widget.isNotDispose) {
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: widget.icon,
        iconSize: widget.iconSize,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: widget.iconSize,
          minHeight: widget.iconSize,
        ),
        onPressed: _toggleOverlay,
      ),
    );
  }

  Widget _overlayContent(
    Color? bgColor,
    Animation<Offset> slideAnimation,
    double maxAllowedHeight,
  ) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: TapRegion(
          onTapOutside: (_) {
            if (_isOpen && widget.isCloseOutsideClick) close();
          },
          child: Material(
            color: bgColor ?? Theme.of(context).cardColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(widget.borderRadious),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxAllowedHeight,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadious),
                child: SingleChildScrollView(
                  child: widget.builder(context, _effectiveController),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}