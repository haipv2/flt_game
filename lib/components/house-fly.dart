import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flt_game/LangawGame.dart';

import 'fly.dart';

class HouseFly extends Fly {
  double get speed => game.tileSize * 2.5;
  HouseFly(LangawGame game, double x, double y) : super(game){
    flyRect = Rect.fromLTWH(x,y,game.tileSize*2.025,game.tileSize*1.5);
   flyingSprite = List<Sprite>();
   flyingSprite.add(Sprite('flies/house-fly-1.png'));
   flyingSprite.add(Sprite('flies/house-fly-2.png'));
   deadSprite = Sprite('flies/house-fly-dead.png');
  }

}