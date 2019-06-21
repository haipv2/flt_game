import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flt_game/views/credits-view.dart';
import 'package:flt_game/views/help-view.dart';
import 'package:flutter/gestures.dart';

import './components/start-button.dart';
import './views/home-view.dart';
import 'components/agile-fly.dart';
import 'components/backyard.dart';
import 'components/credits-button.dart';
import 'components/drooler-fly.dart';
import 'components/fly.dart';
import 'components/help-button.dart';
import 'components/highscore-display.dart';
import 'components/house-fly.dart';
import 'components/hungry-fly.dart';
import 'components/macho-fly.dart';
import 'components/music-button.dart';
import 'components/score-display.dart';
import 'components/sound-button.dart';
import 'controller/spawner.dart';
import 'view.dart';
import 'views/lost-vew.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  bool isOffScreen = false;
  Backyard background;
  HomeView homeView;
  StartButton startButton;
  FlySpawner spawner;
  View activeView = View.home;
  LostView lostView;
  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;
  int score;
  ScoreDisplay scoreDisplay;
  final SharedPreferences storage;
  HighscoreDisplay highscoreDisplay;
  AudioPlayer homeBGM;
  AudioPlayer playingBGM;
  MusicButton musicButton;
  SoundButton soundButton;

  LangawGame(this.storage) {
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
    background.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
    flies.forEach((Fly fly) => fly.render(canvas));
    highscoreDisplay.render(canvas);
    musicButton.render(canvas);
    soundButton.render(canvas);
  }

  @override
  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly flye) => flye.isOffScreen);
    spawner.update(t);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    background = Backyard(this);
    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    spawner = FlySpawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
    score = 0;
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);

    homeBGM = await Flame.audio.loop('bgm/home.mp3', volume: .25);
    homeBGM.pause();
    playingBGM = await Flame.audio.loop('bgm/playing.mp3', volume: .25);
    playingBGM.pause();

    playHomeBGM();
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);

//    spawnFly();
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
    bool isHandled = false;
    bool didHitAFly = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // press Start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }
    // flies
    if (!isHandled) {
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }
    }

    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

// credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    // music button
    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

// sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    if (soundButton.isEnabled) {
      Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
    }
  }

  void playHomeBGM() {
    playingBGM.pause();
    playingBGM.seek(Duration.zero);
    homeBGM.resume();
  }

  void playPlayingBGM() {
    homeBGM.pause();
    homeBGM.seek(Duration.zero);
    playingBGM.resume();
  }
}
