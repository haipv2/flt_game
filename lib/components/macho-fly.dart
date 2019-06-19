import 'dart:ui';

import 'package:flame/sprite.dart';

import '../LangawGame.dart';
import 'fly.dart';

class MachoFly extends Fly {
  MachoFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x,y,game.tileSize*1.5,game.tileSize*1.5);
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
  }
}