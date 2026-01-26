package;

import global.TitleStateGlobal;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import shaderslmfao.ColorSwap;
import ui.PreferencesMenu;
import GameJolt.GameJoltAPI;

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class TitleState extends MusicBeatState
{
  public static var initialized:Bool = false;

  var startedIntro:Bool;

  var blackScreen:FlxSprite;
  var textGroup:FlxGroup;
  var ngSpr:FlxSprite;

  var curWacky:Array<String> = [];
  var wackyImage:FlxSprite;
  var lastBeat:Int = 0;
  var swagShader:ColorSwap;
  var thingie:FlxSprite;

  override public function create():Void
  {
    #if polymod
    polymod.Polymod.init({modRoot: "mods", dirs: ['introMod'], framework: OPENFL});
    #end

    startedIntro = false;

    FlxG.game.focusLostFramerate = 60;

    swagShader = new ColorSwap();

    FlxG.sound.muteKeys = [ZERO];

    curWacky = FlxG.random.getObject(getIntroTextShit());

    // DEBUG BULLSHIT

    super.create();

    FlxG.save.bind('legacy', 'Macohi');
    PreferencesMenu.initPrefs();
    PlayerSettings.init();
    Highscore.load();

    if (FlxG.save.data.weekUnlocked != null)
    {
      if (StoryMenuState.weekUnlocked.length < 4) StoryMenuState.weekUnlocked.insert(0, true);
      if (!StoryMenuState.weekUnlocked[0]) StoryMenuState.weekUnlocked[0] = true;
    }

    VideoState.seenVideo = true;

    FlxTimer.wait(1, () -> startIntro());

    #if discord_rpc
    DiscordClient.initialize();
    Application.current.onExit.add(_ -> DiscordClient.shutdown());
    #end

    #if tentools
    GameJoltAPI.connect();
    GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);
    #end
  }

  var logoBl:FlxSprite;

  var gfDance:FlxSprite;
  var danceLeft:Bool = false;
  var titleText:FlxSprite;

  function startIntro()
  {
    if (!initialized)
    {
      FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
        new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
      FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
        new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
    }

    if (FlxG.sound.music == null || !FlxG.sound.music.playing)
    {
      FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
      FlxG.sound.music.fadeIn(4, 0, 0.7);
    }

    Conductor.changeBPM(102);
    persistentUpdate = true;

    logoBl = new FlxSprite(20, 20);
    logoBl.frames = Paths.getSparrowAtlas('FLegacyBumpin');
    logoBl.antialiasing = true;
    logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
    logoBl.animation.play('bump');

    logoBl.updateHitbox();

    logoBl.shader = swagShader.shader;

    gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
    gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
    gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
    gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
    gfDance.antialiasing = true;
    add(gfDance);

    gfDance.shader = swagShader.shader;

    add(logoBl);

    titleText = new FlxSprite(100, FlxG.height * 0.8);
    titleText.frames = Paths.getSparrowAtlas('titleEnter');
    titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
    titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
    titleText.antialiasing = true;
    titleText.animation.play('idle');
    titleText.updateHitbox();
    add(titleText);

    textGroup = new FlxGroup();

    blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(blackScreen);

    add(textGroup);

    ngSpr = new FlxSprite(0, FlxG.height * 0.52, Paths.image('newgrounds_logo'));
    add(ngSpr);
    ngSpr.visible = false;
    ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
    ngSpr.updateHitbox();
    ngSpr.screenCenter(X);
    ngSpr.antialiasing = true;

    FlxG.mouse.visible = false;

    if (initialized) skipIntro();
    else
      initialized = true;

    startedIntro = true;
  }

  function getIntroTextShit():Array<Array<String>>
  {
    var fullText:String = Assets.getText(TitleStateGlobal.introTextPath);
    return [for (i in fullText.split('\n')) i.split('--')];
  }

  var transitioning:Bool = false;

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

    if (FlxG.keys.justPressed.F) FlxG.fullscreen = !FlxG.fullscreen;

    var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

    var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

    if (gamepad != null)
    {
      if (gamepad.justPressed.START) pressedEnter = true;
    }

    if (pressedEnter && !transitioning && skippedIntro)
    {
      if (FlxG.sound.music != null) FlxG.sound.music.onComplete = null;

      titleText.animation.play('press');

      FlxG.camera.flash(FlxColor.WHITE, 1);
      FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

      transitioning = true;

      FlxG.switchState(() -> new MainMenuState());
    }

    if (pressedEnter && !skippedIntro && initialized) skipIntro();

    if (controls.UI_LEFT) swagShader.update(-elapsed * 0.1);
    if (controls.UI_RIGHT) swagShader.update(elapsed * 0.1);

    super.update(elapsed);
  }

  function createCoolText(textArray:Array<String>)
  {
    for (i in 0...textArray.length)
      addMoreText(textArray[i]);
  }

  function addMoreText(text:String)
  {
    var coolText:Alphabet = new Alphabet(0, (textGroup.length * 60) + 200, text, true, false);
    coolText.screenCenter(X);
    textGroup.add(coolText);
  }

  inline function deleteCoolText()
  {
    textGroup.clear();
  }

  override function beatHit()
  {
    super.beatHit();

    if (skippedIntro)
    {
      logoBl.animation.play('bump', true);

      danceLeft = !danceLeft;

      if (danceLeft) gfDance.animation.play('danceRight');
      else
        gfDance.animation.play('danceLeft');
    }
    else
    {
      if (curBeat > lastBeat)
      {
        for (i in lastBeat...curBeat)
        {
          var scene:Array<String> = TitleStateGlobal.introTextList[i];
          var arr:Array<String> = [];

          var parseSceneString = function(str:String) {
            if (str.startsWith('%'))
            {
              var key = str.split('=')[0];
              var keyVal = str.split('=')[1];

              trace(key + '=' + keyVal);

              switch (key)
              {
                case '%ngSpr':
                  ngSpr.visible = keyVal == "1";
                case '%wacky':
                  addMoreText(curWacky[Std.parseInt(keyVal)]);
                case '%skipIntro':
                  skipIntro();
                case '%clear':
                  deleteCoolText();
              }

              return;
            }

            if (str.trim() != '') addMoreText(str);
          }

          for (i in scene)
          {
            trace('scene bit: ${Std.string(i)}');
            parseSceneString(i);
          }
        }
      }
      lastBeat = curBeat;
    }
  }

  var skippedIntro:Bool = false;

  function skipIntro():Void
  {
    if (!skippedIntro)
    {
      remove(ngSpr);

      FlxG.camera.flash(FlxColor.WHITE, 4);
      remove(textGroup);
      remove(blackScreen);
      skippedIntro = true;
    }
  }
}
