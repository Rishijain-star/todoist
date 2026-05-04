import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Vertical density preset for marketing / auth-style screens.
enum MarketingShellDensity {
  /// Default spacing between header, hero, and actions.
  comfortable,

  /// Tighter vertical gaps — secondary flows, smaller phones.
  compact,
}

/// Reusable **header → hero → actions → footer** column used for welcome,
/// onboarding heroes, and similar flows. Prefer variants ([density]) over
/// copying layout to new files.
class MarketingShellLayout extends StatelessWidget {
  const MarketingShellLayout({
    super.key,
    required this.header,
    required this.hero,
    required this.actions,
    this.footer,
    this.padding,
    this.backgroundColor,
    this.density = MarketingShellDensity.comfortable,
    this.scrollable = true,
  });

  /// Top block — typically logo + headline, **start**-aligned.
  final Widget header;

  /// Center visual — illustration, image, or video placeholder.
  final Widget hero;

  /// Primary actions — button column.
  final Widget actions;

  /// Optional bottom — legal, links. Use [Theme.textTheme.bodySmall].
  final Widget? footer;

  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final MarketingShellDensity density;
  final bool scrollable;

  double get _topPad => density == MarketingShellDensity.compact ? 40.h : 48.h;
  double get _afterHeader => density == MarketingShellDensity.compact ? 24.h : 32.h;
  double get _afterHero => density == MarketingShellDensity.compact ? 28.h : 40.h;
  double get _beforeFooter => density == MarketingShellDensity.compact ? 16.h : 20.h;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    final hPad = 24.w;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: _topPad),
        Align(alignment: Alignment.centerLeft, child: header),
        SizedBox(height: _afterHeader),
        hero,
        SizedBox(height: _afterHero),
        actions,
        if (footer != null) ...[
          SizedBox(height: _beforeFooter),
          footer!,
        ],
        // Keeps legal/footer clear of gesture nav + toasts on Android/iOS
        SizedBox(height: 16.h + bottomInset + 8),
      ],
    );

    final padded = Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: hPad),
      child: content,
    );

    if (!scrollable) {
      return ColoredBox(color: bg, child: padded);
    }

    return ColoredBox(
      color: bg,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: padded,
      ),
    );
  }
}
