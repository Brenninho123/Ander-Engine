package ui;

import flixel.group.FlxGroup.FlxTypedGroup;
import GameJolt;
import ui.OptionsState.Page;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import lime.system.System;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;

class JolyPage extends Page
{
  var loginTexts:FlxTypedGroup<FlxText>;
  var loginBoxes:FlxTypedGroup<FlxUIInputText>;
  var loginButtons:FlxTypedGroup<FlxButton>;
  var usernameText:FlxText;
  var tokenText:FlxText;
  var usernameBox:FlxUIInputText;
  var tokenBox:FlxUIInputText;
  var signInBox:FlxButton;
  var helpBox:FlxButton;
  var logOutBox:FlxButton;
  var cancelBox:FlxButton;

  var username1:FlxText;
  var username2:FlxText;

  var baseX:Int = -190;

  public static var login:Bool = false;

  override public function new()
  {
    super();
  }

  public function create()
  {
    if (FlxG.save.data.lbToggle != null) GameJoltAPI.leaderboardToggle = FlxG.save.data.lbToggle;

    if (!login)
    {
      FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
      FlxG.sound.music.fadeIn(2, 0, 0.85);
    }

    FlxG.mouse.visible = true;

    Conductor.changeBPM(102);

    var bg:FlxSprite = new FlxSprite(Paths.image('menuDesat'));
    bg.setGraphicSize(FlxG.width);
    bg.antialiasing = true;
    bg.updateHitbox();
    bg.screenCenter();
    bg.scrollFactor.set();
    bg.alpha = 0.25;
    add(bg);

    loginTexts = new FlxTypedGroup<FlxText>(2);
    add(loginTexts);

    usernameText = new FlxText(0, 125, 300, "Username:", 20);

    tokenText = new FlxText(0, 225, 300, "Token:", 20);

    loginTexts.add(usernameText);
    loginTexts.add(tokenText);
    loginTexts.forEach(item -> {
      item.screenCenter(X);
      item.x += baseX;
      item.font = GameJoltInfo.font;
    });

    loginBoxes = new FlxTypedGroup<FlxUIInputText>(2);
    add(loginBoxes);

    usernameBox = new FlxUIInputText(0, 175, 300, null, 32, FlxColor.BLACK, FlxColor.GRAY);
    tokenBox = new FlxUIInputText(0, 275, 300, null, 32, FlxColor.BLACK, FlxColor.GRAY);

    loginBoxes.add(usernameBox);
    loginBoxes.add(tokenBox);
    loginBoxes.forEach(item -> {
      item.screenCenter(X);
      item.x += baseX;
      item.font = GameJoltInfo.font;
    });

    if (GameJoltAPI.getStatus())
    {
      remove(loginTexts);
      remove(loginBoxes);
    }

    loginButtons = new FlxTypedGroup<FlxButton>(3);
    add(loginButtons);

    signInBox = new FlxButton(0, 475, "Sign In", () -> GameJoltAPI.authDaUser(usernameBox.text, tokenBox.text, true));

    helpBox = new FlxButton(0, 550, "GameJolt Token", () -> {
      if (!GameJoltAPI.getStatus()) openLink('https://www.youtube.com/watch?v=T5-x7kAGGnE');
      else
        FlxG.save.data.lbToggle = GameJoltAPI.leaderboardToggle = !GameJoltAPI.leaderboardToggle;
    });

    helpBox.color = FlxColor.fromRGB(84, 155, 149);

    logOutBox = new FlxButton(0, 625, "Log Out & Close", () -> GameJoltAPI.deAuthDaUser());
    logOutBox.color = FlxColor.fromRGB(255, 134, 61);

    cancelBox = new FlxButton(0, 625, "Not Right Now", () -> {
      FlxG.save.flush();
      FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

      onExit.dispatch();
    });

    if (!GameJoltAPI.getStatus()) loginButtons.add(signInBox);
    else
    {
      cancelBox.y = 475;
      cancelBox.text = "Continue";
      loginButtons.add(logOutBox);
    }

    loginButtons.add(helpBox);
    loginButtons.add(cancelBox);

    loginButtons.forEach(item -> {
      item.screenCenter(X);
      item.setGraphicSize(Std.int(item.width) * 3);
      item.x += baseX;
    });

    if (GameJoltAPI.getStatus())
    {
      username1 = new FlxText(0, 95, 0, "Signed in as:", 40);
      username1.alignment = CENTER;
      username1.screenCenter(X);
      username1.x += baseX;
      add(username1);

      username2 = new FlxText(0, 145, 0, "" + GameJoltAPI.getUserInfo(true) + "", 40);
      username2.alignment = CENTER;
      username2.screenCenter(X);
      username2.x += baseX;
      add(username2);

      if (GameJoltInfo.font != null)
      {
        username1.font = GameJoltInfo.font;
        username2.font = GameJoltInfo.font;
      }
    }

    if (GameJoltInfo.font != null)
    {
      loginBoxes.forEach(item -> item.font = GameJoltInfo.font);
      loginTexts.forEach(item -> item.font = GameJoltInfo.font);
    }
  }

  override function update(elapsed:Float)
  {
    FlxG.save.data.lbToggle ??= false;
    FlxG.save.flush();

    if (GameJoltAPI.getStatus())
    {
      helpBox.text = "Leaderboards:\n" + (GameJoltAPI.leaderboardToggle ? "Enabled" : "Disabled");
      helpBox.color = (GameJoltAPI.leaderboardToggle ? FlxColor.GREEN : FlxColor.RED);
    }

    if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound?.music?.time ?? 0;

    if (!FlxG.sound?.music?.playing ?? false) FlxG.sound.playMusic(Paths.music('freakyMenu'));

    if (FlxG.keys.justPressed.ESCAPE)
    {
      FlxG.save.flush();
      FlxG.mouse.visible = false;
      FlxG.switchState(() -> GameJoltInfo.changeState);
    }

    super.update(elapsed);
  }

  function openLink(url:String)
  {
    #if linux
    Sys.command('/usr/bin/xdg-open', [url, "&"]);
    #else
    FlxG.openURL(url);
    #end
  }
}
