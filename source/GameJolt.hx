package;

// GameJolt things
import flixel.addons.ui.FlxUIState;
import tentools.api.FlxGameJolt as GJApi;
// Login things
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import lime.system.System;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;

using StringTools;

@:unreflective
class GameJoltAPI // Connects to tentools.api.FlxGameJolt
{
  /**
   * Whether the user has logged in or not.
   */
  public static var userLogin:Bool = false;

  /**
   * Whether the user wants to submit scores or not.
   */
  public static var leaderboardToggle:Bool;

  /**
   * Grabs user data and returns as a string, true for Username, false for Token
   * @param username Bool value
   * @return String 
   */
  public static function getUserInfo(username:Bool = true):String
  {
    return username ? GJApi.username : GJApi.usertoken;
  }

  /**
   * Returns the user login status
   * @return Bool
   */
  public static inline function getStatus():Bool
    return userLogin;

  /**
   * Sets the game API key from GJKeys.api
   */
  public static inline function connect()
    GJApi.init(Std.int(GJKeys.id), Std.string(GJKeys.key), () -> {});

  /**
   * Inline function to auth the user. Shouldn't be used outside of GameJoltAPI things.
   * @param in1 username
   * @param in2 token
   * @param loginArg Used in only GameJoltLogin
   */
  public static function authDaUser(in1, in2, ?loginArg:Bool = false)
  {
    if (!userLogin)
    {
      GJApi.authUser(in1, in2, v -> {
        if (v)
        {
          trace(in1 + " authenticated!");
          FlxG.save.data.gjUser = in1;
          FlxG.save.data.gjToken = in2;
          FlxG.save.flush();
          userLogin = true;
          startSession();
          if (loginArg)
          {
            GameJoltLogin.login = true;
            FlxG.switchState(() -> new GameJoltLogin());
          }
        }
        else
        {
          if (loginArg)
          {
            GameJoltLogin.login = true;
            FlxG.switchState(() -> new GameJoltLogin());
          }
          trace("Not signed in!");
        }
      });
    }
  }

  /**
   * Inline function to deauth the user, shouldn't be used out of GameJoltLogin state!
   * @return  Logs the user out and closes the game
   */
  public static function deAuthDaUser()
  {
    closeSession();
    userLogin = false;
    trace(FlxG.save.data.gjUser + FlxG.save.data.gjToken);
    FlxG.save.data.gjUser = "";
    FlxG.save.data.gjToken = "";
    FlxG.save.flush();
    trace(FlxG.save.data.gjUser + FlxG.save.data.gjToken);
    trace("Logged out!");
    System.exit(0);
  }

  /**
   * Awards a trophy to the user!
   * @param trophyID Trophy ID. Check your game's API settings for trophy IDs.
   */
  public static function getTrophy(trophyID:Int)
  {
    if (userLogin) GJApi.addTrophy(trophyID);
  }

  /**
   * Checks a trophy to see if it was collected
   * @param id TrophyID
   * @return Bool (True for achieved, false for unachieved)
   */
  public static function checkTrophy(id:Int):Bool
  {
    var value:Bool = false;
    GJApi.fetchTrophy(id, data -> {
      if (data.get("achieved").toString() != "false") value = true;
    });
    return value;
  }

  public static function pullTrophy(?id:Int):Map<String, String>
  {
    var returnable:Map<String, String> = null;
    GJApi.fetchTrophy(id, data -> returnable = data);
    return returnable;
  }

  /**
   * Add a score to a table!
   * @param score Score of the song. **Can only be an int value!**
   * @param tableID ID of the table you want to add the score to!
   */
  public static function addScore(score:Int, tableID:Int)
  {
    if (GameJoltAPI.leaderboardToggle) GJApi.addScore(score + "%20Points", score, tableID, false, null);
  }

  /**
   * Return the highest score from a table!
   * 
   * Usable by pulling the data from the map by [function].get();
   * 
   * Values returned in the map: score, sort, user_id, user, extra_data, stored, guest, success
   * 
   * @param tableID The table you want to pull from
   * @return Map<String,String>
   */
  public static function pullHighScore(tableID:Int):Map<String, String>
  {
    var returnable:Map<String, String>;
    GJApi.fetchScore(tableID, 1, data -> returnable = data);
    return returnable;
  }

  /**
   * Starts the session. Shouldn't be used out of GameJoltAPI.
   */
  public static inline function startSession()
  {
    GJApi.openSession(() -> new FlxTimer().start(20, _ -> pingSession(), 0));
  }

  /**
   * Tells GameJolt that you are still active!
   * Called every 20 seconds by a loop in startSession().
   */
  public static inline function pingSession()
    GJApi.pingSession(true);

  /**
   * Closes the session, used when signing out.
   */
  public static inline function closeSession()
    GJApi.closeSession();
}

final class GameJoltInfo
{
  /**
   * Variable to change which state to when leaving the login screen.
   */
  public static final changeState:FlxUIState = new MainMenuState();

  /**
   * The font used for the GameJolt API elements.
   */
  public static final font:String = "VCR OSD Mono";
}

class GameJoltLogin extends MusicBeatState
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

  override function create()
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
      FlxG.sound.play(Paths.sound('confirmMenu'), 0.7, false, null, true, () -> FlxG.switchState(() -> GameJoltInfo.changeState));
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
    }

    if (GameJoltInfo.font != null)
    {
      username1.font = GameJoltInfo.font;
      username2.font = GameJoltInfo.font;
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
