import 'dart:math' show min, max;
import 'dart:ui' as ui show FlutterView;

import 'package:flutter/widgets.dart';

typedef FontSizeResolver = double Function(num fontSize, ScreenUtil instance);

class ScreenUtil {
  static const Size defaultSize = Size(360, 690);
  static final ScreenUtil _instance = ScreenUtil._();

  late Size _uiSize;

  late Orientation _orientation;

  late bool _minTextAdapt;
  late MediaQueryData _data;
  late bool _splitScreenMode;
  FontSizeResolver? fontSizeResolver;

  ScreenUtil._();

  factory ScreenUtil() => _instance;

  static Future<void> ensureScreenSize([
    ui.FlutterView? window,
    Duration duration = const Duration(milliseconds: 10),
  ]) async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();

    await Future.doWhile(() {
      window ??= binding.platformDispatcher.implicitView;

      if (window == null || window!.physicalSize.isEmpty) {
        return Future.delayed(duration, () => true);
      }

      return false;
    });

    binding.allowFirstFrame();
  }

  Set<Element>? _elementsToRebuild;

  static void registerToBuild(
    BuildContext context, [
    bool withDescendants = false,
  ]) {
    (_instance._elementsToRebuild ??= {}).add(context as Element);

    if (withDescendants) {
      context.visitChildren((element) {
        registerToBuild(element, true);
      });
    }
  }

  static void configure({
    MediaQueryData? data,
    Size? designSize,
    bool? splitScreenMode,
    bool? minTextAdapt,
    FontSizeResolver? fontSizeResolver,
  }) {
    try {
      if (data != null) {
        _instance._data = data;
      } else {
        data = _instance._data;
      }

      if (designSize != null) {
        _instance._uiSize = designSize;
      } else {
        designSize = _instance._uiSize;
      }
    } catch (_) {
      throw Exception(
          'You must either use ScreenUtil.init or ScreenUtilInit first');
    }

    final MediaQueryData? deviceData = data.nonEmptySizeOrNull();
    final Size deviceSize = deviceData?.size ?? designSize;

    final orientation = deviceData?.orientation ??
        (deviceSize.width > deviceSize.height
            ? Orientation.landscape
            : Orientation.portrait);

    _instance
      ..fontSizeResolver = fontSizeResolver ?? _instance.fontSizeResolver
      .._minTextAdapt = minTextAdapt ?? _instance._minTextAdapt
      .._splitScreenMode = splitScreenMode ?? _instance._splitScreenMode
      .._orientation = orientation;

    _instance._elementsToRebuild?.forEach((el) => el.markNeedsBuild());
  }

  static void init(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    return configure(
      data: MediaQuery.maybeOf(context),
      designSize: designSize,
      splitScreenMode: splitScreenMode,
      minTextAdapt: minTextAdapt,
      fontSizeResolver: fontSizeResolver,
    );
  }

  static Future<void> ensureScreenSizeAndInit(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    return ScreenUtil.ensureScreenSize().then((_) {
      return configure(
        data: MediaQuery.maybeOf(context),
        designSize: designSize,
        minTextAdapt: minTextAdapt,
        splitScreenMode: splitScreenMode,
        fontSizeResolver: fontSizeResolver,
      );
    });
  }

  Orientation get orientation => _orientation;

  double get textScaleFactor => _data.textScaleFactor;

  double? get pixelRatio => _data.devicePixelRatio;

  double get screenWidth => _data.size.width;

  double get screenHeight => _data.size.height;

  double get statusBarHeight => _data.padding.top;

  double get bottomBarHeight => _data.padding.bottom;

  double get scaleWidth => screenWidth / _uiSize.width;

  double get scaleHeight {
    return (_splitScreenMode ? max(screenHeight, 700) : screenHeight) /
        _uiSize.height;
  }

  double get scaleText =>
      _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;

  double setWidth(num width) => width * scaleWidth;

  double setHeight(num height) => height * scaleHeight;

  double radius(num r) => r * min(scaleWidth, scaleHeight);

  double diagonal(num d) => d * scaleHeight * scaleWidth;

  double diameter(num d) => d * max(scaleWidth, scaleHeight);

  double setSp(num fontSize) {
    return fontSizeResolver?.call(fontSize, _instance) ?? fontSize * scaleText;
  }

  SizedBox setVerticalSpacing(num height) {
    return SizedBox(height: setHeight(height));
  }

  SizedBox setVerticalSpacingFromWidth(num height) {
    return SizedBox(height: setWidth(height));
  }

  SizedBox setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));

  SizedBox setHorizontalSpacingRadius(num width) {
    return SizedBox(width: radius(width));
  }

  SizedBox setVerticalSpacingRadius(num height) {
    return SizedBox(height: radius(height));
  }

  SizedBox setHorizontalSpacingDiameter(num width) {
    return SizedBox(width: diameter(width));
  }

  SizedBox setVerticalSpacingDiameter(num height) {
    return SizedBox(height: diameter(height));
  }

  SizedBox setHorizontalSpacingDiagonal(num width) {
    return SizedBox(width: diagonal(width));
  }

  SizedBox setVerticalSpacingDiagonal(num height) {
    return SizedBox(height: diagonal(height));
  }
}

extension on MediaQueryData? {
  MediaQueryData? nonEmptySizeOrNull() {
    if (this?.size.isEmpty ?? true) {
      return null;
    } else {
      return this;
    }
  }
}
