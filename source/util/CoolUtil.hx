package util;

class CoolUtil
{
  public static final difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

  public static function difficultyString():String
  {
    return difficultyArray[PlayState.storyDifficulty];
  }

  public static function coolTextFile(path:String):Array<String>
  {
    return [for (i in Assets.getText(path).trim().split('\n')) i.trim()];
  }

  public static inline function numberArray(max:Int, ?min:Int = 0):Array<Int>
    return [for (i in min...max) i];

  /**
   * Lerps camera, but accountsfor framerate shit?
   * Right now it's simply for use to change the followLerp variable of a camera during update.
   */
  public static function camLerpShit(lerp:Float):Float
  {
    return lerp * (FlxG.elapsed / (1 / 60));
  }

  /**
   * Just calls camLerpShit for you so you dont have to do it every time.
   */
  public static function coolLerp(a:Float, b:Float, ratio:Float):Float
    return FlxMath.lerp(a, b, camLerpShit(ratio));
}
