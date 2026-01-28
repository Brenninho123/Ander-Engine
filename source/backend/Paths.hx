package backend;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;

class Paths
{
  public static inline final SOUND_EXT = #if web "mp3" #else "ogg" #end;

  static var currentLevel:String;

  public static inline function setCurrentLevel(name:String)
    currentLevel = name.toLowerCase();

  static function getPath(file:String, type:AssetType, library:Null<String>)
  {
    if (library != null) return getLibraryPath(file, library);

    if (currentLevel != null)
    {
      var levelPath = getLibraryPathForce(file, currentLevel);
      if (Assets.exists(levelPath, type)) return levelPath;

      levelPath = getLibraryPathForce(file, "shared");
      if (Assets.exists(levelPath, type)) return levelPath;
    }

    return getPreloadPath(file);
  }

  static public function getLibraryPath(file:String, library = "preload")
  {
    return (library == "preload" || library == "default") ? getPreloadPath(file) : getLibraryPathForce(file, library);
  }

  static inline function getLibraryPathForce(file:String, library:String)
    return '$library:assets/$library/$file';

  static inline function getPreloadPath(file:String)
    return 'assets/$file';

  public static inline function file(file:String, type:AssetType = TEXT, ?library:String)
    return getPath(file, type, library);

  public static inline function txt(key:String, ?library:String)
    return getPath('data/$key.txt', TEXT, library);

  public static inline function dialogue(key:String, ?library:String)
    return txt('dialogue/$key', library);

  public static inline function xml(key:String, ?library:String)
    return getPath('data/$key.xml', TEXT, library);

  public static inline function json(key:String, ?library:String)
    return getPath('data/$key.json', TEXT, library);

  public static inline function chart(song:String, chart:String, ?library:String)
    return json('songs/${song.toLowerCase()}/${chart.toLowerCase()}', library);

  public static function sound(key:String, ?library:String)
    return getPath('sounds/$key.$SOUND_EXT', SOUND, library);

  public static function mp4(key:String, ?library:String)
    return getPath('videos/$key.mp4', SOUND, library);

  public static inline function soundRandom(key:String, min:Int, max:Int, ?library:String)
    return sound(key + FlxG.random.int(min, max), library);

  public static inline function music(key:String, ?library:String)
    return getPath('music/$key.$SOUND_EXT', MUSIC, library);

  public static inline function voices(song:String, ?suffix:String)
    return 'songs:assets/songs/${song.toLowerCase()}/Voices${suffix != null && suffix.length > 0 ? '-' : ''}${suffix ?? ''}.$SOUND_EXT';

  public static inline function inst(song:String)
    return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';

  public static inline function image(key:String, ?library:String)
    return getPath('images/$key.png', IMAGE, library);

  public static inline function font(key:String)
    return 'assets/fonts/$key';

  public static inline function getSparrowAtlas(key:String, ?library:String)
    return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));

  public static inline function getPackerAtlas(key:String, ?library:String)
    return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
}
