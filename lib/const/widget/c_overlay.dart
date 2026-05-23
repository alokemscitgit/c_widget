
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
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));

    _opacityAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) close();
    });
  }

  void close() async {
    if (_isOpen) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    }
  }

  void _toggleOverlay() async {
    if (_isOpen) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
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
  final RenderBox box = context.findRenderObject() as RenderBox;
  final iconPos = box.localToGlobal(Offset.zero);

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
          overlaySize = size;
          final spaceBelow = screen.height - (iconPos.dy + box.size.height);
          final shouldOpenUp = spaceBelow < size.height + 10;

          if (shouldOpenUp != _openUpwards) {
            _openUpwards = shouldOpenUp;
            _overlayEntry?.markNeedsBuild();
          }
        },
        child: Positioned(
          top: _openUpwards && overlaySize != null
              ? iconPos.dy - overlaySize!.height - 8 // precise top
              : iconPos.dy + box.size.height + 8, // normal bottom
          left: left,
          width: overlayWidth,
          child: _overlayContent(),
        ),
      );
    },
  );
}

  @override
  void dispose() {
    if (!widget.isNotDispose) {
      _animationController.dispose();
    }
    _focusNode.dispose();
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

  Widget _overlayContent() {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: TapRegion(
          onTapOutside: (_) {
            if (_isOpen && widget.isCloseOutsideClick) close();
          },
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(widget.borderRadious),
            child: widget.child,
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

/// Helper widget to measure child size
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
      final size = context.size;
      if (size != null && _oldSize != size) {
        _oldSize = size;
        widget.onChange(size);
      }
    });

    return widget.child;
  }
}

/// Extension to get approximate child height (optional)
// extension _ChildHeight on Widget {
//   double childHeight() => 150; // fallback if unknown, override if needed
// }