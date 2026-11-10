import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum CurrencyBadgeType {
  income,
  expense,
  neutral,
}

class CurrencyBadge extends StatelessWidget {
  const CurrencyBadge({
    super.key,
    required this.amount,
    this.currencySymbol = 'R\$',
    this.type,
    this.backgroundColor,
    this.textColor,
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = 8.0,
    this.shadowOffset = AppTheme.shadowOffsetSmall,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.fontSize = 14,
    this.showSign = true,
    this.icon,
  });

  const CurrencyBadge.income({
    super.key,
    required this.amount,
    this.currencySymbol = 'R\$',
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = 8.0,
    this.shadowOffset = AppTheme.shadowOffsetSmall,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.fontSize = 14,
    this.showSign = true,
    this.icon,
  })  : type = CurrencyBadgeType.income,
        backgroundColor = AppColors.success,
        textColor = AppColors.text;

  const CurrencyBadge.expense({
    super.key,
    required this.amount,
    this.currencySymbol = 'R\$',
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = 8.0,
    this.shadowOffset = AppTheme.shadowOffsetSmall,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.fontSize = 14,
    this.showSign = true,
    this.icon,
  })  : type = CurrencyBadgeType.expense,
        backgroundColor = AppColors.alert,
        textColor = AppColors.text;

  const CurrencyBadge.neutral({
    super.key,
    required this.amount,
    this.currencySymbol = 'R\$',
    this.borderColor = AppColors.border,
    this.borderWidth = AppTheme.borderWidth,
    this.borderRadius = 8.0,
    this.shadowOffset = AppTheme.shadowOffsetSmall,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.fontSize = 14,
    this.showSign = false,
    this.icon,
  })  : type = CurrencyBadgeType.neutral,
        backgroundColor = AppColors.surface,
        textColor = AppColors.text;

  final num amount;
  final String currencySymbol;
  final CurrencyBadgeType? type;
  final Color? backgroundColor;
  final Color? textColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final bool showSign;
  final Widget? icon;

  CurrencyBadgeType get _resolvedType {
    if (type != null) {
      return type!;
    }
    if (amount > 0) {
      return CurrencyBadgeType.income;
    }
    if (amount < 0) {
      return CurrencyBadgeType.expense;
    }
    return CurrencyBadgeType.neutral;
  }

  Color get _resolvedBackgroundColor {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    return switch (_resolvedType) {
      CurrencyBadgeType.income => AppColors.success,
      CurrencyBadgeType.expense => AppColors.alert,
      CurrencyBadgeType.neutral => AppColors.surface,
    };
  }

  Color get _resolvedTextColor {
    if (textColor != null) {
      return textColor!;
    }
    return AppColors.text;
  }

  String _formatValue() {
    final isNegative = amount < 0 || _resolvedType == CurrencyBadgeType.expense;
    final absValue = amount.abs();
    final parts = absValue.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    final length = integerPart.length;
    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(integerPart[i]);
    }

    String signPrefix = '';
    if (showSign) {
      if (isNegative) {
        signPrefix = '- ';
      } else if (_resolvedType == CurrencyBadgeType.income) {
        signPrefix = '+ ';
      }
    } else if (amount < 0) {
      signPrefix = '- ';
    }

    return '$signPrefix$currencySymbol ${buffer.toString()},$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _resolvedBackgroundColor,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            _formatValue(),
            style: TextStyle(
              color: _resolvedTextColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
