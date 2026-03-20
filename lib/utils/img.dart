import 'package:core/core.dart';
import 'package:flutter/material.dart';

extension ImageExtension on CoreBase {
  Image imgHost(
    String url, {
    double scale = 1.0,
    frameBuilder,
    loadingBuilder,
    errorBuilder,
    semanticLabel,
    excludeFromSemantics = false,
    width,
    height,
    color,
    opacity,
    colorBlendMode,
    BoxFit? fit,
    alignment = Alignment.center,
    repeat = ImageRepeat.noRepeat,
    centerSlice,
    matchTextDirection = false,
    gaplessPlayback = false,
    filterQuality = FilterQuality.medium,
    isAntiAlias = false,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
    WebHtmlElementStrategy webHtmlElementStrategy =
        WebHtmlElementStrategy.never,
  }) {
    return Image.network(
      imgHostNetwork(url),
      scale: scale,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      headers: headers,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      webHtmlElementStrategy: webHtmlElementStrategy,
    );
  }

  String imgHostNetwork(String url) {
    return "$storageHost/$url";
  }
}
