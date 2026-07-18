import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Emoji extends ConfettiParticle {
  final String emoji;
  final TextStyle? textStyle;

  Emoji({
    required this.emoji,
    this.textStyle,
  });

  /// Rasterized images shared between all particles, so launching e.g. 50
  /// identical emojis only rasterizes the text once.
  static final Map<(String, TextStyle?, double), ui.Image> _imageCache = {};

  ui.Image? _cachedImage;
  bool _loading = false;

  final Paint _paint = Paint();

  Future<ui.Image> _createTextImage(ConfettiPhysics physics) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final textStyle = this.textStyle ?? const TextStyle();
    final fontSize = textStyle.fontSize ?? 18;
    final scaleFontSize = fontSize * 4 * physics.scalar;

    final textPainter = TextPainter(
      text: TextSpan(
          text: emoji, style: textStyle.copyWith(fontSize: scaleFontSize)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final imageSize = ((scaleFontSize + scaleFontSize / 2)).toInt();

    return picture.toImage(imageSize, imageSize);
  }

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    if (_cachedImage == null) {
      final key = (emoji, textStyle, physics.scalar);

      _cachedImage = _imageCache[key];

      if (_cachedImage == null) {
        if (!_loading) {
          _loading = true;
          _createTextImage(physics).then((image) {
            _imageCache[key] = image;
            _cachedImage = image;
          });
        }
        return;
      }
    }

    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(pi / 10 * physics.wobble);
    canvas.scale(0.25, 0.25);

    _paint.color = Color.fromRGBO(255, 255, 255, 1 - physics.progress);

    canvas.drawImage(_cachedImage!, Offset.zero, _paint);

    canvas.restore();
  }
}
