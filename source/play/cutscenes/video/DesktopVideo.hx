package play.cutscenes.video;

#if VIDEO_DESKTOP
import hxvlc.flixel.FlxVideoSprite;

class DesktopVideo
{
  public var video:FlxVideoSprite;

  public var finishCallback:Void->Void;

  public function new(vidSrc:String)
  {
    video = new FlxVideoSprite(0, 0);

    if (video != null && video.load(vidSrc))
    {
      trace('ITS VIDEO TIME BITCH!');
      video.play();

      FlxG.state.add(video);

      video.bitmap.onEndReached.add(finishVideo);

      // Resize video bigger or smaller than the screen.
      video.bitmap.onFormatSetup.add(() -> {
        video.setGraphicSize(FlxG.width, FlxG.height);
        video.updateHitbox();
        video.setPosition(0, 0);
      });
    }
    else
    {
      trace('Video is null. Skipping!');
      FlxTimer.wait(0.4, () -> finishVideo());
    }
  }

  public function finishVideo()
  {
    if (FlxG.state.members.contains(video)) FlxG.state.remove(video);

    if (finishCallback != null) finishCallback();
  }
}
#end
