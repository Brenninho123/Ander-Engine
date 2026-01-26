package cutscenes.video;

import flixel.FlxCamera;
#if VIDEO_WEB
typedef VideoCutsceneClass = WebVideo;
#elseif VIDEO_DESKTOP
typedef VideoCutsceneClass = DesktopVideo;
#else
import flixel.FlxSprite;

class VideoCutsceneClass
{
  public var video:FlxSprite;

  public var finishCallback(default, set):Void->Void;

  function set_finishCallback(callback:Void->Void):Void->Void
  {
    if (callback != null)
    {
      finishCallback = callback;
    }
    else
    {
      finishCallback = callback;
    }

    if (finishCallback != null) finishCallback();

    return finishCallback;
  }

  public function new(vidSrc:String)
  {
    trace('not VIDEO_WEB or VIDEO_DESKTOP, set "finishCallback" to do whatever you need to');

    video = new FlxSprite();
  }
}
#end

class VideoCutscene extends VideoCutsceneClass
{
  public function setCameras(cameras:Array<FlxCamera>)
  {
    #if !VIDEO_WEB
    video.cameras = cameras;
    #end
  }
}
