import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'const/app_colors.dart';

extension NumToSizedBox on num {
  SizedBox get heightBox => SizedBox(height: toDouble().h);
  SizedBox get widthBox => SizedBox(width: toDouble().w);
  SizedBox get defalutHeightButtom => SizedBox(
    child: SafeArea(top: false, bottom: true, child: SizedBox(height: 20.h)),
  );
}

extension WidgetExtensions on Widget {
  /// Wraps the current widget in a [Center] widget.
  Widget get kCentered => Center(child: this);

  /// Aligns the current widget to the right using an [Align] widget.
  Widget get kAlignRight =>
      Align(alignment: Alignment.centerRight, child: this);

  /// Aligns the current widget to the left using an [Align] widget.
  Widget get kAlignLeft => Align(alignment: Alignment.centerLeft, child: this);

  /// Aligns the current widget to the top-center using an [Align] widget.
  Widget get kAlignTopCenter =>
      Align(alignment: Alignment.topCenter, child: this);

  /// Aligns the current widget to the bottom-center using an [Align] widget.
  Widget get kAlignBottomCenter =>
      Align(alignment: Alignment.bottomCenter, child: this);

  /// Aligns the current widget to the top-left using an [Align] widget.
  Widget get kAlignTopLeft => Align(alignment: Alignment.topLeft, child: this);

  /// Aligns the current widget to the top-right using an [Align] widget.
  Widget get kAlignTopRight =>
      Align(alignment: Alignment.topRight, child: this);

  /// Aligns the current widget to the bottom-left using an [Align] widget.
  Widget get kAlignBottomLeft =>
      Align(alignment: Alignment.bottomLeft, child: this);

  /// Aligns the current widget to the bottom-right using an [Align] widget.
  Widget get kAlignBottomRight =>
      Align(alignment: Alignment.bottomRight, child: this);
}

extension StyledText on String {
  StyledTextBuilder get style => StyledTextBuilder(this);
}

class StyledTextBuilder {
  final String text;
  TextStyle _style;
  TextAlign? _textAlign;
  TextOverflow? _overflow;
  int? _maxLines;

  StyledTextBuilder(this.text) : _style = const TextStyle();

  StyledTextBuilder fontSize(double size) => copyWith(fontSize: size.sp);

  StyledTextBuilder fontWeight(FontWeight weight) =>
      copyWith(fontWeight: weight);
  StyledTextBuilder get bold => copyWith(fontWeight: FontWeight.bold);
  StyledTextBuilder get italic => copyWith(fontStyle: FontStyle.italic);

  // Color
  StyledTextBuilder color(Color color) => copyWith(color: color);
  StyledTextBuilder get white => copyWith(color: Colors.white);
  StyledTextBuilder get red => copyWith(color: Colors.redAccent);

  // Spacing

  StyledTextBuilder get ls_05 => copyWith(letterSpacing: -0.5);
  StyledTextBuilder get ls_1 => copyWith(letterSpacing: -1);
  StyledTextBuilder get ls_2 => copyWith(letterSpacing: -2);
  StyledTextBuilder get ls_1_5 => copyWith(letterSpacing: -1.5);
  StyledTextBuilder get ls05 => copyWith(letterSpacing: .5);

  StyledTextBuilder get w311 => copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w312 => copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );

  StyledTextBuilder get w413 => copyWith(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w416 => copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w418 => copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w420 => copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w411 => copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w410 => copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w408 => copyWith(
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w412 => copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w409 => copyWith(
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    height: 1,
  );

  // new fonts

  StyledTextBuilder get w520 => copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w530 => copyWith(
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w536 => copyWith(
    fontSize: 36.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w524 => copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w528 => copyWith(
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w548 => copyWith(
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w516 => copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w518 => copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w514 => copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w510 => copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w511 => copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w508 => copyWith(
    fontSize: 8.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w512 => copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  //use
  StyledTextBuilder get w513 => copyWith(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w609 => copyWith(
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w608 => copyWith(
    fontSize: 8.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );

  StyledTextBuilder get w626 => copyWith(
    fontSize: 26.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w620 => copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w615 => copyWith(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w616 => copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w617 => copyWith(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w612 => copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w613 => copyWith(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w611 => copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w610 => copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );
  StyledTextBuilder get w648 => copyWith(
    fontSize: 48.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    height: 1,
  );

  // new fonts
  StyledTextBuilder get w721 => copyWith(
    fontSize: 21.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );

  StyledTextBuilder get w714 => copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w712 => copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w715 => copyWith(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w718 => copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );

  StyledTextBuilder get w724 => copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  StyledTextBuilder get w816 => copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryColor,
    height: 1,
    letterSpacing: 0,
  );
  // new fonts

  StyledTextBuilder letterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);
  StyledTextBuilder lineHeight(double height) => copyWith(height: height);

  // Alignment
  StyledTextBuilder get center => copyWith(textAlign: TextAlign.center);
  StyledTextBuilder get left => copyWith(textAlign: TextAlign.left);
  StyledTextBuilder get right => copyWith(textAlign: TextAlign.right);

  // Overflow
  StyledTextBuilder get ellipsis => copyWith(overflow: TextOverflow.ellipsis);
  StyledTextBuilder maxLines(int lines) => copyWith(maxLines: lines);

  // Decoration
  StyledTextBuilder underline({Color? color}) =>
      copyWith(decoration: TextDecoration.underline, decorationColor: color);

  // Helper Methods
  StyledTextBuilder copyWith({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return StyledTextBuilder(text)
      .._style = _style.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
        decoration: decoration,
        decorationColor: decorationColor,
      )
      .._textAlign = textAlign ?? _textAlign
      .._overflow = overflow ?? _overflow
      .._maxLines = maxLines ?? _maxLines;
  }

  Text make() => Text(
    text,
    style: _style,
    textAlign: _textAlign,
    overflow: _overflow,
    maxLines: _maxLines,
  );
}

//padding extension

extension PaddingExtension on Widget {
  Padding kpTop(double padding) => Padding(
    padding: EdgeInsets.only(top: padding.h),
    child: this,
  );
  Padding kpBottom(double padding) => Padding(
    padding: EdgeInsets.only(bottom: padding.h),
    child: this,
  );
  Padding kpLeft(double padding) => Padding(
    padding: EdgeInsets.only(left: padding.w),
    child: this,
  );
  Padding kpRight(double padding) => Padding(
    padding: EdgeInsets.only(right: padding.w),
    child: this,
  );

  Padding kpLR(double padding) => Padding(
    padding: EdgeInsets.symmetric(horizontal: padding.w),
    child: this,
  );
  Padding kpAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding.r), child: this);
  Padding kpTB(double padding) => Padding(
    padding: EdgeInsets.symmetric(vertical: padding.h),
    child: this,
  );

  Padding kpLRDefault() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: this,
  );

  Padding withPaddingOnly({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    ),
    child: this,
  );
}

TextStyle textFiledHintTextStyle = TextStyle(
  // fontWeight: FontWeight.w400,
  fontWeight: FontWeight.w500,
  fontSize: 20.sp,
  letterSpacing: 1.2,
  height: 0.8,
  color: const Color.fromRGBO(21, 34, 79, 1),
);
TextStyle textFiledLabelTextStyle = TextStyle(
  // fontWeight: FontWeight.w400,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
  height: .06,
  letterSpacing: 1.2,
  color: Color.fromRGBO(150, 154, 168, 1),
);
