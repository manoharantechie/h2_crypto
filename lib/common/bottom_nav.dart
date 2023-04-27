import 'package:flutter/material.dart' as md;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:h2_crypto/common/localization/localizations.dart';
import 'package:h2_crypto/common/theme/custom_theme.dart';

class BottomNav extends md.StatefulWidget {
  final int? index;
  final int? selectedIndex;
  final void Function(int i)? onTap;
  final List<BottomNavItem>? items;
  final double? elevation;
  final IconStyle? iconStyle;
  final md.Color color;
  final BgStyle? bgStyle;
  final LabelStyle? labelStyle;

  BottomNav({
    this.index,
    this.selectedIndex,
    this.onTap,
    this.items,
    this.elevation = 8.0,
    this.iconStyle,
    this.color = md.Colors.white,
    this.labelStyle,
    this.bgStyle,
  })  : assert(items != null),
        assert(items!.length >= 2);

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends md.State<BottomNav> {
  int? currentIndex;
  int? selectedIndex;
  IconStyle? iconStyle;
  LabelStyle? labelStyle;
  BgStyle? bgStyle;
  static bool clickable = true;

  @override
  void initState() {
    currentIndex = widget.index;
    selectedIndex = widget.selectedIndex;
    iconStyle = widget.iconStyle;
    labelStyle = widget.labelStyle ?? LabelStyle();
    bgStyle = widget.bgStyle;

    super.initState();
  }

  @override
  md.Widget build(md.BuildContext context) {
    return md.Material(
        elevation: widget.elevation!,
        color: widget.color,
        child: md.Row(
          mainAxisAlignment: md.MainAxisAlignment.spaceAround,
          mainAxisSize: md.MainAxisSize.max,
          children: widget.items!.map((b) {
            final int i = widget.items!.indexOf(b);
            bool selected = false;
            selected = i == currentIndex;
            return BMNavItem(
              image: b.image,
              iconSize: selected
                  ? iconStyle!.getSelectedSize()
                  : iconStyle!.getSize(),
              label: parseLabel(b.label, labelStyle!, selected),
              onTap: () => onItemClick(i),
              textStyle: selected
                  ? labelStyle!.getOnSelectTextStyle()
                  : labelStyle!.getTextStyle(),
              color: selected
                  ? CustomTheme.of(context).splashColor
                  : CustomTheme.of(context).splashColor.withOpacity(0.5),
              bgColor:
                  selected ? bgStyle!.getSelectedColor() : bgStyle!.getColor(),
            );
          }).toList(),
        ));
  }

  onItemClick(int i) {
    setState(() {
      currentIndex = i;
    });
    if (widget.onTap != null) widget.onTap!(i);
  }

  parseLabel(String label, LabelStyle style, bool selected) {
    if (!style.isVisible()) {
      return null;
    }

    if (style.isShowOnSelect()) {
      return selected ? label : null;
    }

    return label;
  }
}

class BottomNavItem {
  final String image;
  final String label;

  BottomNavItem(this.image, {required this.label});
}

class LabelStyle {
  final bool? visible;
  final bool? showOnSelect;
  final md.TextStyle? textStyle;
  final md.TextStyle? onSelectTextStyle;

  LabelStyle(
      {this.visible,
      this.showOnSelect,
      this.textStyle,
      this.onSelectTextStyle});

  isVisible() {
    return visible ?? true;
  }

  isShowOnSelect() {
    return showOnSelect ?? false;
  }

  getTextStyle() {
    if (textStyle != null) {
      return md.TextStyle(
        inherit: textStyle!.inherit,
        color: textStyle!.color,
        fontSize: textStyle!.fontSize ?? 10.0,
        fontWeight: textStyle!.fontWeight,
        fontStyle: textStyle!.fontStyle,
        letterSpacing: textStyle!.letterSpacing,
        wordSpacing: textStyle!.wordSpacing,
        textBaseline: textStyle!.textBaseline,
        height: textStyle!.height,
        locale: textStyle!.locale,
        foreground: textStyle!.foreground,
        background: textStyle!.background,
        decoration: textStyle!.decoration,
        decorationColor: textStyle!.decorationColor,
        decorationStyle: textStyle!.decorationStyle,
        debugLabel: textStyle!.debugLabel,
        fontFamily: textStyle!.fontFamily,
      );
    }
    return md.TextStyle(fontSize: 10.0);
  }

  // getOnSelectTextStyle returns `onSelectTextStyle` with
  // default `fontSize` and `color` values if not provided. if
  // `onSelectTextStyle` is null then returns default text style
  getOnSelectTextStyle() {
    if (onSelectTextStyle != null) {
      return md.TextStyle(
        inherit: onSelectTextStyle!.inherit,
        color: onSelectTextStyle!.color,
        fontSize: onSelectTextStyle!.fontSize ?? 10.0,
        fontWeight: onSelectTextStyle!.fontWeight,
        fontStyle: onSelectTextStyle!.fontStyle,
        letterSpacing: onSelectTextStyle!.letterSpacing,
        wordSpacing: onSelectTextStyle!.wordSpacing,
        textBaseline: onSelectTextStyle!.textBaseline,
        height: onSelectTextStyle!.height,
        locale: onSelectTextStyle!.locale,
        foreground: onSelectTextStyle!.foreground,
        background: onSelectTextStyle!.background,
        decoration: onSelectTextStyle!.decoration,
        decorationColor: onSelectTextStyle!.decorationColor,
        decorationStyle: onSelectTextStyle!.decorationStyle,
        debugLabel: onSelectTextStyle!.debugLabel,
        fontFamily: onSelectTextStyle!.fontFamily,
      );
    }
    return md.TextStyle(fontSize: 10.0);
  }
}

class IconStyle {
  final double size;
  final double? onSelectSize;
  final md.Color color;
  final md.Color onSelectColor;

  IconStyle(
      {required this.size,
      this.onSelectSize,
      required this.color,
      required this.onSelectColor});

  getSize() {
    return size;
  }

  getSelectedSize() {
    return onSelectSize ?? 22.0;
  }

  getColor() {
    return color;
  }

  getSelectedColor() {
    return onSelectColor;
  }
}

class BgStyle {
  final md.Color color;
  final md.Color onSelectColor;

  BgStyle({required this.color, required this.onSelectColor});

  getColor() {
    return color;
  }

  getSelectedColor() {
    return onSelectColor;
  }
}

class BorderStyleTop {
  final md.Color color;
  final md.Color onSelectColor;

  BorderStyleTop({required this.color, required this.onSelectColor});

  getColor() {
    return color;
  }

  getSelectedColor() {
    return onSelectColor;
  }
}

// ignore: must_be_immutable
class BMNavItem extends md.StatelessWidget {
  final String? image;
  final double? iconSize;
  final String? label;
  final void Function()? onTap;
  final Color? color;
  final md.Color? bgColor;
  final md.Color? borderColor;

  final md.TextStyle? textStyle;

  BMNavItem({
    this.image,
    this.iconSize,
    this.label,
    this.onTap,
    this.color,
    this.textStyle,
    this.bgColor,
    this.borderColor,
  })  : assert(svg != null),
        assert(image != ""),
        assert(iconSize != null),
        assert(color != null),
        assert(bgColor != null),
        assert(onTap != null);

  @override
  md.Widget build(md.BuildContext context) {
    return md.Expanded(
        child: md.Container(
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: md.InkResponse(
        key: key,
        child: md.Padding(
            padding: getPadding(),
            child: md.Column(
                mainAxisSize: md.MainAxisSize.min,
                children: <md.Widget>[
                  image != ""
                      ? new SvgPicture.asset(
                          image!,
                          height: iconSize,
                          width: iconSize,
                          color: color,
                          alignment: md.Alignment.center,
                          matchTextDirection: false,
                        )
                      : md.Container(),
                  md.SizedBox(
                    height: 2.0,
                  ),
                  label != null
                      ? md.Text(
                          AppLocalizations.instance.text(label!).toUpperCase(),
                          style: textStyle)
                      : md.Container()
                ])),
        highlightColor: md.Theme.of(context).highlightColor,
        splashColor: md.Theme.of(context).splashColor,
        radius: md.Material.defaultSplashRadius,
        onTap: () => onTap!(),
      ),
    ));
  }

  // getPadding returns the padding after adjusting the top and bottom
  // padding based on the font size and iconSize.
  getPadding() {
    if (label != null) {
      final double p = ((56 - textStyle!.fontSize!) - iconSize!) / 2;
      return md.EdgeInsets.fromLTRB(0.0, p, 0.0, p);
    }
    return md.EdgeInsets.fromLTRB(
        0.0, (56 - iconSize!) / 2, 0.0, (56 - iconSize!) / 2);
  }
}
