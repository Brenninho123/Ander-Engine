package backend;

import animate.FlxAnimateFrames;
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

  public static inline function animateAtlas(path:String, ?library:String):String
    return getLibraryPath('images/$path', library);

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

  public static function getAnimateAtlas(key:String, ?library:String, settings:AtlasSpriteSettings):FlxAnimateFrames
  {
    var assetLibrary:String = library ?? "";
    var graphicKey:String = "";

    if (assetLibrary != "")
    {
      graphicKey = Paths.animateAtlas(key, assetLibrary);
    }
    else
    {
      graphicKey = Paths.animateAtlas(key);
    }

    var validatedSettings:AtlasSpriteSettings =
      {
        swfMode: settings?.swfMode ?? false,
        cacheOnLoad: settings?.cacheOnLoad ?? false,
        filterQuality: settings?.filterQuality ?? MEDIUM,
        spritemaps: settings?.spritemaps ?? null,
        metadataJson: settings?.metadataJson ?? null,
        cacheKey: settings?.cacheKey ?? null,
        uniqueInCache: settings?.uniqueInCache ?? false,
        onSymbolCreate: settings?.onSymbolCreate ?? null,
        applyStageMatrix: settings?.applyStageMatrix ?? false,
        useRenderTexture: settings?.useRenderTexture ?? false
      };

    // Validate asset path.
    if (!Assets.exists('${graphicKey}/Animation.json'))
    {
      throw 'No Animation.json file exists at the specified path (${graphicKey})';
    }

    return FlxAnimateFrames.fromAnimate(graphicKey, validatedSettings.spritemaps, validatedSettings.metadataJson, validatedSettings.cacheKey,
      validatedSettings.uniqueInCache, {
        swfMode: validatedSettings.swfMode,
        cacheOnLoad: validatedSettings.cacheOnLoad,
        filterQuality: validatedSettings.filterQuality,
        onSymbolCreate: validatedSettings.onSymbolCreate
      });
  }
}

typedef AtlasSpriteSettings =
{
  /**
   * If true, the texture atlas will behave as if it was exported as an SWF file.
   * Notably, this allows MovieClip symbols to play.
   */
  @:optional
  var swfMode:Bool;

  /**
   * If true, filters and masks will be cached when the atlas is loaded, instead of during runtime.
   */
  @:optional
  var cacheOnLoad:Bool;

  /**
   * The filter quality.
   * Available values are: HIGH, MEDIUM, LOW, and RUDY.
   *
   * If you're making an atlas sprite in HScript, you pass an Int instead:
   *
   * HIGH - 0
   * MEDIUM - 1
   * LOW - 2
   * RUDY - 3
   */
  @:optional
  var filterQuality:FilterQuality;

  /**
   * Optional, an array of spritemaps for the atlas to load.
   */
  @:optional
  var spritemaps:Array<SpritemapInput>;

  /**
   * Optional, string of the metadata.json contents.
   */
  @:optional
  var metadataJson:String;

  /**
   * Optional, force the cache to use a specific key to index the texture atlas.
   */
  @:optional
  var cacheKey:String;

  /**
   * If true, the texture atlas will use a new slot in the cache.
   */
  @:optional
  var uniqueInCache:Bool;

  /**
   * Optional callback for when a symbol is created.
   */
  @:optional
  var onSymbolCreate:animate.internal.SymbolItem->Void;

  /**
   * Whether to apply the stage matrix, if it was exported from a symbol instance.
   * Also positions the Texture Atlas as it displays in Animate.
   * Turning this on is only recommended if you prepositioned the character in Animate.
   * For other cases, it should be turned off to act similarly to a normal FlxSprite.
   */
  @:optional
  var applyStageMatrix:Bool;

  /**
   * If enabled, the sprite will render as one texture instead of rendering multiple limbs.
   * This is useful for stuff like changing alpha, and shaders that require the whole sprite.
   *
   * Only enable this if your sprite either:
   * - Changes alpha to something other than 1.0
   * - Has a shader or blend mode
   */
  @:optional
  var useRenderTexture:Bool;
}
