import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'components/agile-fly.dart';
import 'components/backyard.dart';
import 'components/drooler-fly.dart';
import 'components/fly.dart';
import 'components/house-fly.dart';
import 'components/hungry-fly.dart';
import 'components/macho-fly.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  bool isOffScreen = false;
  Backyard background;

  LangawGame() {
    initialize();
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
//    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
//    Paint bgPaint = Paint();
//    bgPaint.color = Color(0xff576574);
//    canvas.drawRect(bgRect, bgPaint);
    background.render(canvas);
    flies.forEach((Fly fly) => fly.render(canvas));

  }

  @override
  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly flye) => flye.isOffScreen);
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    background = Backyard(this);
    spawnFly();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void onTapDown(TapDownDetails d) {
    flies.forEach((Fly fly) {
      if (fly.flyRect.contains(d.globalPosition)) {
        fly.onTapDown();
      }
    });
  }
}
