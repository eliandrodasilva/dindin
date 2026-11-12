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
    this.textColor,
    this.borderColor,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = AppTheme.borderRadiusSmall,
    this.shadowOffset = AppTheme.shadowOffset,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    this.fontSize = 15,
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
  final Color? textColor;
  final Color? borderColor;
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
    // Intelligent text/icon contrast
    final effectiveTextColor = widget.textColor ??
        (widget.backgroundColor.computeLuminance() < 0.45
            ? AppColors.surface
            : AppColors.text);

    Widget buttonContent = widget.child ??
        Text(
          widget.text!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        );

    if (widget.icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: effectiveTextColor,
              size: widget.fontSize + 2,
            ),
            child: widget.icon!,
          ),
          const SizedBox(width: 8),
          Flexible(
            fit: FlexFit.loose,
            child: buttonContent,
          ),
        ],
      );
    }

    final effectiveBgColor = _isEnabled
        ? widget.backgroundColor
        : widget.backgroundColor.withValues(alpha: 0.4);

    final effectiveBorderColor = widget.borderColor ??
        (widget.backgroundColor == AppColors.surface
            ? AppColors.border
            : Colors.transparent);

    final hasShadow = widget.shadowOffset != Offset.zero &&
        _isEnabled &&
        widget.backgroundColor != AppColors.surface;

    Widget container = AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: Container(
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: widget.borderWidth,
            ),
            boxShadow: hasShadow
                ? [
                    BoxShadow(
                      color: widget.backgroundColor.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Center(
            widthFactor: widget.isExpanded ? null : 1.0,
            child: buttonContent,
          ),
        ),
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
