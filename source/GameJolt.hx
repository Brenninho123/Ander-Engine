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
        }
        else
        {
          trace("Not signed in!");
        }

        if (loginArg)
        {
          FlxG.switchState(() -> new ui.OptionsState(true));
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
  public static final font:String = Paths.font('vcr.ttf');
}
