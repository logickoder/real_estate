import 'package:real_estate/core/utils/constants.dart';
import 'package:real_estate/core/widgets/app_text.dart';
import 'package:real_estate/core/widgets/inline_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ButtonType { elevated, outline, flat, filled }

/// A custom button that toggles Elevated, Outline or Flat.
///
/// The [AppButton.elevated] builds a button with elevation and a
/// [backgroundColor].
///
/// The [AppButton.flat] builds a flat button with a transparent background.
///
/// The button can have an [icon] and [text]. When both are not `null`, the
/// icon is built to the left of the text with a padding in between that is
/// half of its vertical padding.
///
/// When [onTap] is `null`, the button will appear disabled by reducing the
/// foreground and background opacity.
///
/// Either [icon] or [text] must not be `null`.
class AppButton extends StatelessWidget {
  /// A button that appears raised with a shadow.
  ///
  /// Uses the [Theme.primaryColor] as the [backgroundColor] by default.
  const AppButton.elevated({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.dense = false,
    this.disabled = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor = kWhite,
    this.style,
    this.width,
    this.height,
    this.weight,
    this.fontSize,
    this.borderRadius,
    this.isIconAfterText = false,
    this.shadowColor = Colors.transparent,
    double? elevation,
    this.isLoading = false,
  })  : buttonType = ButtonType.elevated,
        elevation = elevation ?? 1,
        assert(text != null || icon != null);

  /// An Outlined button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const AppButton.outlined({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.dense = false,
    this.disabled = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor,
    this.style,
    this.width,
    this.height,
    this.weight,
    this.fontSize,
    this.isIconAfterText = false,
    this.shadowColor = Colors.transparent,
    this.borderRadius,
    this.isLoading = false,
  })  : buttonType = ButtonType.outline,
        backgroundColor = null,
        elevation = 0,
        assert(text != null || icon != null);

  const AppButton.filled({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.dense = false,
    this.disabled = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor,
    this.style,
    this.width,
    this.height,
    this.weight,
    this.fontSize,
    this.isIconAfterText = false,
    this.shadowColor = Colors.transparent,
    this.borderRadius,
    this.isLoading = false,
  })  : buttonType = ButtonType.filled,
        backgroundColor = null,
        elevation = 0,
        assert(text != null || icon != null);

  /// A flat button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const AppButton.flat({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.dense = false,
    this.disabled = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor,
    this.backgroundColor,
    this.style,
    this.width,
    this.height,
    this.weight,
    this.fontSize,
    this.isIconAfterText = false,
    this.shadowColor = Colors.transparent,
    this.borderRadius,
    this.isLoading = false,
  })  : buttonType = ButtonType.flat,
        elevation = 0,
        assert(text != null || icon != null);

  /// The text widget of the button.
  ///
  /// Can be `null` if the button has no text.
  final String? text;

  /// The icon widget of the button.
  ///
  /// Can be `null` if the button has no icon.
  final Widget? icon;

  /// If button icon should display after button text
  /// defaults to false
  final bool isIconAfterText;

  /// The size of the [icon].
  ///
  /// Defaults to the current icon theme's size.
  final double? iconSize;

  /// The size of the [text].
  ///
  /// Defaults to 15.
  final double? fontSize;

  /// This weight of the [text]
  ///
  /// Defaults to FontWeight.w600
  final FontWeight? weight;

  ///
  /// Shows progress indicator when set to true.
  final bool isLoading;

  /// The callback when the button is tapped.
  ///
  /// If `null`, the button has reduced transparency to appear disabled.
  final VoidCallback onTap;

  /// Specifies the type of button, either Raised, Outlined or Flat.
  ///
  /// Uses global button theme.
  final ButtonType buttonType;

  /// The color of the button.
  ///
  /// Uses the [AppTheme.foregroundColor] if `null`.
  final Color? backgroundColor;

  /// The color of the [icon] and [text] of the button.
  ///
  /// Defaults to [kContrastColor] if the [backgroundColor] is `null`,
  /// to the text foreground color if the [backgroundColor] is transparent or to
  /// white or black when [backgroundColor] is set.
  final Color? foregroundColor;

  /// Button text style.
  final TextStyle? style;

  /// Whether the button should have less padding.
  ///
  /// Has no effect if [padding] is not `null`.
  final bool dense;

  /// The padding for the button.
  ///
  /// Should usually be `null` to use the default padding that is controlled
  /// with [dense] if a smaller padding is required.
  final EdgeInsets? padding;

  /// The padding between the [icon] and [text].
  ///
  /// Only has an affect when both [icon] and [text] is not `null`.
  ///
  /// Defaults to half of the vertical padding.
  final double? betweenPadding;

  /// The [elevation] that changes when using a [AppButton.flat] or
  /// [AppButton.raised].
  final double elevation;

  /// Specifies [width] of button
  final double? width;

  /// Specifies [height] of button
  final double? height;

  /// Specifies [borderRadius] of button
  final double? borderRadius;

  /// Specifies [ShadowColor] of button
  final Color? shadowColor;

  final bool disabled;

  EdgeInsets get _padding =>
      padding ??
      EdgeInsets.symmetric(vertical: dense ? 8 : 6, horizontal: dense ? 16 : 0);

  /// Builds the row with the [Icon] and [Text] widget.
  Widget _buildContent() {
    // Determine the order of the icon and text based on isIconAfterText
    List<Widget> contentChildren = _buildIconAndText();

    // If isLoading is true, overlay the loader on top of the content
    if (isLoading) {
      return _buildLoadingOverlay(contentChildren);
    }

    // If not loading, return the Row widget directly
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the content
      children: contentChildren,
    );
  }

  List<Widget> _buildIconAndText() {
    List<Widget> children = [];

    // Add the icon if it exists and isIconAfterText is false
    if (!isIconAfterText && icon != null) {
      children.add(icon!);
      _addSpacing(children);
    }

    // Add the text widget
    if (text != null) {
      children.add(
        Expanded(
          child: AppText(
            text!,
            size: fontSize ?? 16,
            weight: weight ?? FontWeight.w700,
            align: TextAlign.center,
            color: foregroundColor ?? kContrastColor,
          ),
        ),
      );
    }

    // Add the icon if it exists and isIconAfterText is true
    if (isIconAfterText && icon != null) {
      _addSpacing(children);
      children.add(icon!);
    }

    return children;
  }

  void _addSpacing(List<Widget> children) {
    if (children.isNotEmpty) {
      children.add(SizedBox(width: betweenPadding ?? 8));
    }
  }

  Widget _buildLoadingOverlay(List<Widget> contentChildren) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: contentChildren,
        ),
        const InlineLoader(), // Display the loader
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Builder(
        builder: (context) => DefaultTextStyle(
          style: Theme.of(context).textTheme.labelLarge!.merge(style),
          overflow: TextOverflow.fade,
          softWrap: false,
          child: _buildButton(),
        ),
      ),
    );
    // return _buildButton();
  }

  Widget _buildButton() {
    switch (buttonType) {
      case ButtonType.flat:
        return TextButton(
          onPressed: () => {HapticFeedback.mediumImpact(), onTap()},
          style: TextButton.styleFrom(
            foregroundColor: Colors.transparent.withOpacity(0),
            shadowColor: Colors.transparent,
          ),
          child: _buildContent(),
        );

      case ButtonType.outline:
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: OutlinedButton(
            onPressed: () => {HapticFeedback.lightImpact(), onTap()},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: kGrey4,
                width: 1,
              ),
              shadowColor: kShadowColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(width ?? double.infinity, height ?? 48),
            ),
            child: _buildContent(),
          ),
        );
      case ButtonType.filled:
        return Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(1, 1.2), color: kShadowColor, blurRadius: 1),
              BoxShadow(
                  offset: Offset(1, -1.2), color: kShadowColor, blurRadius: 1),
              BoxShadow(
                  offset: Offset(1.1, 0), color: kShadowColor, blurRadius: 1),
              BoxShadow(
                  offset: Offset(-1.1, 0), color: kShadowColor, blurRadius: 1)
            ],
          ),
          child: OutlinedButton(
            onPressed: () => {HapticFeedback.lightImpact(), onTap()},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kStrokeColor),
              shadowColor: kShadowColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(width ?? double.infinity, height ?? 48),
            ),
            child: _buildContent(),
          ),
        );

      default:
        return ElevatedButton(
          onPressed: () =>
              {HapticFeedback.lightImpact(), disabled ? () {} : onTap()},
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: Size(width ?? double.infinity, height ?? 48),
            elevation: elevation,
            foregroundColor: foregroundColor ?? kWhite,
            backgroundColor:
                disabled ? kDisabledColor : (backgroundColor ?? kPrimaryColor),
            shadowColor: shadowColor,
          ),
          child: _buildContent(),
        );
    }
  }
}
