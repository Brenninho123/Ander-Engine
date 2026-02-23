package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
    // =========================
    // CONFIG
    // =========================

    public static inline var SOUND_EXT:String = #if web "mp3" #else "ogg" #end;

    static var currentLevel:String = null;

    public static function setCurrentLevel(name:String):Void
    {
        currentLevel = (name != null) ? name.toLowerCase() : null;
    }

    // =========================
    // CORE PATH SYSTEM
    // =========================

    static function getPath(file:String, type:AssetType, ?library:String):String
    {
        // Explicit library
        if (library != null)
            return getLibraryPath(file, library);

        // Level override
        if (currentLevel != null)
        {
            var levelPath = getLibraryPathForce(file, currentLevel);
            if (OpenFlAssets.exists(levelPath, type))
                return levelPath;

            var sharedPath = getLibraryPathForce(file, "shared");
            if (OpenFlAssets.exists(sharedPath, type))
                return sharedPath;
        }

        return getPreloadPath(file);
    }

    public static function getLibraryPath(file:String, library:String = "preload"):String
    {
        return (library == "preload" || library == "default")
            ? getPreloadPath(file)
            : getLibraryPathForce(file, library);
    }

    static inline function getLibraryPathForce(file:String, library:String):String
    {
        return '$library:assets/$library/$file';
    }

    static inline function getPreloadPath(file:String):String
    {
        return 'assets/$file';
    }

    // =========================
    // GENERIC FILES
    // =========================

    public static inline function file(file:String, type:AssetType = TEXT, ?library:String):String
        return getPath(file, type, library);

    public static inline function txt(key:String, ?library:String):String
        return getPath('data/$key.txt', TEXT, library);

    public static inline function xml(key:String, ?library:String):String
        return getPath('data/$key.xml', TEXT, library);

    public static inline function json(key:String, ?library:String):String
        return getPath('data/$key.json', TEXT, library);

    public static inline function dialogue(key:String, ?library:String):String
        return txt('dialogue/$key', library);

    public static inline function chart(song:String, chart:String, ?library:String):String
        return json('songs/${song.toLowerCase()}/${chart.toLowerCase()}', library);

    // =========================
    // AUDIO
    // =========================

    public static function sound(key:String, ?library:String):String
        return getPath('sounds/$key.$SOUND_EXT', SOUND, library);

    public static function music(key:String, ?library:String):String
        return getPath('music/$key.$SOUND_EXT', MUSIC, library);

    public static function soundRandom(key:String, min:Int, max:Int, ?library:String):String
        return sound(key + FlxG.random.int(min, max), library);

    public static inline function voices(song:String, ?suffix:String):String
    {
        var extra = (suffix != null && suffix.length > 0) ? '-$suffix' : '';
        return 'songs:assets/songs/${song.toLowerCase()}/Voices$extra.$SOUND_EXT';
    }

    public static inline function inst(song:String):String
        return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';

    public static function video(key:String, ?library:String):String
        return getPath('videos/$key.mp4', BINARY, library);

    // =========================
    // GRAPHICS
    // =========================

    public static inline function image(key:String, ?library:String):String
        return getPath('images/$key.png', IMAGE, library);

    public static inline function font(key:String):String
        return 'assets/fonts/$key';

    public static function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
    {
        var imagePath = image(key, library);
        var xmlPath = getPath('images/$key.xml', TEXT, library);
        return FlxAtlasFrames.fromSparrow(imagePath, xmlPath);
    }

    public static function getPackerAtlas(key:String, ?library:String):FlxAtlasFrames
    {
        var imagePath = image(key, library);
        var txtPath = getPath('images/$key.txt', TEXT, library);
        return FlxAtlasFrames.fromSpriteSheetPacker(imagePath, txtPath);
    }
}