import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class FlatCard extends StatelessWidget {
  const FlatCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = AppTheme.borderRadius,
    this.shadowOffset = AppTheme.shadowOffset,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: shadowOffset == Offset.zero
            ? null
            : [
                BoxShadow(
                  color: borderColor,
                  offset: shadowOffset,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: child,
    );

    if (margin != null) {
      if (onTap != null) {
        return Padding(
          padding: margin!,
          child: GestureDetector(
            onTap: onTap,
            child: cardContent,
          ),
        );
      }
      return Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
