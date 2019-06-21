import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import '../LangawGame.dart';
import '../view.dart';
import 'callout.dart';

class Fly{
  final LangawGame game;
  Rect flyRect;
  bool isDead = false;
  bool isOffScreen = false;
  Sprite deadSprite;
  List<Sprite> flyingSprite;
  double flyingSpriteIndex =0;
  Offset targetLocation;
  Callout callout;

  double get speed => game.tileSize*3;


  Fly(this.game) {
    setTargetLocation();
    callout = Callout(this);

  }
  void render(Canvas c) {
//    print(flyingSpriteIndex);
    c.drawRect(flyRect.inflate(flyRect.width / 2), Paint()..color = Color(0x77ffffff));

    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(flyRect.width / 2));
    }else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, flyRect.inflate(flyRect.width / 2));
      if (game.activeView == View.playing) {
        callout.render(c);
      }
    }
    c.drawRect(flyRect, Paint()..color = Color(0x88000000));

    if (game.activeView == View.playing) {
      callout.render(c);
    }
  }

  void update(double t) {
    if (isDead) {
      if (game.activeView == View.playing){
        game.score +=1;
      }

      flyRect = flyRect.translate(0, game.tileSize*12*t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }

    } else {

      // flap the wings
      flyingSpriteIndex += 30*t;
      while (flyingSpriteIndex >= 2){
        flyingSpriteIndex -=2;
      }

      //move fly
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        setTargetLocation();
        flyRect = flyRect.shift(toTarget);
      }
    }

    callout.update(t);
  }

  void onTapDown() {
    Flame.audio.play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
    isDead=true;
    if (game.score > (game.storage.getInt('highscore') ?? 0)) {
      game.storage.setInt('highscore', game.score);
      game.highscoreDisplay.updateHighscore();
    }

    if (game.soundButton.isEnabled) {
      Flame.audio.play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
    }
//    game.spawnFly();
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);
  }
}
