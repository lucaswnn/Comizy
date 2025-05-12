import 'package:comizy/tads/product_type.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:flutter/material.dart';

class ProductTypeDropdownButton extends StatefulWidget {
  final List<ProductMainType> mainTypes;
  final void Function(ProductMainType) onChanged;
  final ProductMainType firstSelected;

  const ProductTypeDropdownButton({
    super.key,
    required this.mainTypes,
    required this.onChanged,
    required this.firstSelected,
  });

  @override
  State<ProductTypeDropdownButton> createState() =>
      _ProductTypeDropdownButtonState();
}

class _ProductTypeDropdownButtonState extends State<ProductTypeDropdownButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;
  late ProductMainType _selected;
  final double _borderRadius = 20;

  @override
  void initState() {
    _selected = widget.firstSelected;
    super.initState();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isExpanded = true;
    });
  }

  void _onSelected(ProductMainType type) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _selected = type;
      _isExpanded = false;
    });
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isExpanded = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Gesture detector to close the dropdown
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _removeDropdown(),
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),
          Positioned(
            height: 100,
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 4.0,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widget.mainTypes.map((type) {
                    return ListTile(
                      leading: Icon(type.icon),
                      title: Text(type.label,
                          style: const TextStyle(fontSize: 12)),
                      onTap: () {
                        widget.onChanged(type);
                        _onSelected(type);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: _isExpanded
                ? BorderRadius.only(
                    topLeft: Radius.circular(_borderRadius),
                    topRight: Radius.circular(_borderRadius))
                : BorderRadius.circular(_borderRadius),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Icon(
                      _selected.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(_selected.label,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
