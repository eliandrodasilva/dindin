import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.onPressed,
    this.text,
    this.child,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.text,
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = AppTheme.borderRadius,
    this.shadowOffset = AppTheme.shadowOffset,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.fontSize = 16,
    this.isExpanded = false,
    this.height,
  }) : assert(
          text != null || child != null,
          'Either text or child must be provided',
        );

  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final bool isExpanded;
  final double? height;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentOffset = _isPressed && _isEnabled
        ? widget.shadowOffset
        : Offset.zero;

    final currentShadow = _isPressed || !_isEnabled
        ? Offset.zero
        : widget.shadowOffset;

    Widget buttonContent = widget.child ??
        Text(
          widget.text!,
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        );

    if (widget.icon != null) {
      buttonContent = Row(
        mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon!,
          const SizedBox(width: 8),
          Flexible(
            fit: widget.isExpanded ? FlexFit.tight : FlexFit.loose,
            child: buttonContent,
          ),
        ],
      );
    }

    final effectiveColor = _isEnabled
        ? widget.backgroundColor
        : widget.backgroundColor.withValues(alpha: 0.5);

    final effectiveBorderColor = _isEnabled
        ? widget.borderColor
        : widget.borderColor.withValues(alpha: 0.5);

    Widget container = AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        currentOffset.dx,
        currentOffset.dy,
        0,
      ),
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: widget.borderWidth,
        ),
        boxShadow: currentShadow == Offset.zero
            ? null
            : [
                BoxShadow(
                  color: effectiveBorderColor,
                  offset: currentShadow,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Center(
        widthFactor: widget.isExpanded ? null : 1.0,
        child: buttonContent,
      ),
    );

    if (widget.isExpanded) {
      container = SizedBox(
        width: double.infinity,
        child: container,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: container,
    );
  }
}
