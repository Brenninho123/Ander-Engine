package play.cutscenes.video;

#if VIDEO_WEB
typedef VideoCutsceneClass = WebVideo;
#elseif VIDEO_DESKTOP
typedef VideoCutsceneClass = DesktopVideo;
#else
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
    trace('Unable to find a suitable video class, set "finishCallback" to do whatever you need to.');
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
