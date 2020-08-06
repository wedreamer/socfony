import 'package:flutter/material.dart';

/// Used with [TabBar.indicator] to draw a horizontal line below the
/// selected tab.
///
/// The selected tab underline is inset from the tab's boundary by [insets].
/// The [borderSide] defines the line's color and weight.
///
/// The [TabBar.indicatorSize] property can be used to define the indicator's
/// bounds in terms of its (centered) widget with [TabIndicatorSize.label],
/// or the entire tab with [TabIndicatorSize.tab].
class CustomUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const CustomUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width = 12.0,
  })  : assert(borderSide != null),
        assert(insets != null);

  final double width;

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _CustomUnderlinePainter createBoxPainter([VoidCallback onChanged]) {
    return _CustomUnderlinePainter(this, onChanged);
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  _CustomUnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final CustomUnderlineTabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;
  double get width => decoration.width;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator =
        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    final double _offset = (indicator.width - width) / 2;

    canvas.drawLine(
        Offset(indicator.bottomLeft.dx + _offset, indicator.bottomLeft.dy),
        Offset(indicator.bottomRight.dx - _offset, indicator.bottomRight.dy),
        paint);
  }
}
