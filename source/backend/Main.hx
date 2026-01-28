package backend;

import haxe.Log;
import openfl.events.UncaughtErrorEvent;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.Video;
import openfl.net.NetStream;

class Main extends Sprite
{
  var gameWidth:Int = 1280;
  var gameHeight:Int = 720;
  var initialState:Class<FlxState> = ui.title.TitleState;
  var zoom:Float = -1;
  #if web
  var framerate:Int = 60;
  #else
  var framerate:Int = 144;
  #end
  var skipSplash:Bool = true;
  var startFullscreen:Bool = false;

  // You can pretty much ignore everything from here on - your code should go in your states.

  public static function main():Void
  {
    Lib.current.addChild(new Main());
  }

  public function new()
  {
    super();

    var introShit:Array<String> = [
      '',

      'FUNKIN LEGACY',
      'VERSION: ${lime.app.Application.current.meta.get('version')}',

      '',

      #if web 'WEB', #end
      #if web ' * Video Support (openfl)', #end

      #if desktop 'DESKTOP', #end
      #if desktop ' * Video Support (hxCodec)', #end

      #if (sys && !debug) ' * Custom Trace', #end

      #if (!web && !desktop) 'UNKNOWN', #end

      '',
    ];

    #if (sys && !debug)
    Log.trace = (v, ?infos) -> {
      Sys.println('${'${infos.fileName}:${infos.lineNumber}'.rpad(' ', 48) + ':'}'.rpad(' ', 48 + 8) + '${Std.string(v)}');
    }
    #end

    for (thing in introShit)
    {
      #if sys
      Sys.println(thing);
      #else
      if (thing.trim().length > 0) trace(thing);
      #end
    }

    if (stage != null)
    {
      init();
    }
    else
    {
      addEventListener(Event.ADDED_TO_STAGE, init);
    }
  }

  private function init(?E:Event):Void
  {
    if (hasEventListener(Event.ADDED_TO_STAGE))
    {
      removeEventListener(Event.ADDED_TO_STAGE, init);
    }

    setupGame();
  }

  var video:Video;
  var netStream:NetStream;
  private var overlay:Sprite;

  public static var fpsCounter:FPS;

  private function setupGame():Void
  {
    var stageWidth:Int = Lib.current.stage.stageWidth;
    var stageHeight:Int = Lib.current.stage.stageHeight;

    if (zoom == -1)
    {
      var ratioX:Float = stageWidth / gameWidth;
      var ratioY:Float = stageHeight / gameHeight;
      zoom = Math.min(ratioX, ratioY);
      gameWidth = Math.ceil(stageWidth / zoom);
      gameHeight = Math.ceil(stageHeight / zoom);
    }

    #if !debug
    initialState = TitleState;
    #end

    addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

    fpsCounter = new FPS(10, 3, 0xFFFFFF);
    addChild(fpsCounter);
  }
}
