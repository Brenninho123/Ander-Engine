package cutscenes.video;

#if VIDEO_DESKTOP
import flixel.util.FlxTimer;
import flixel.FlxG;
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxBasic;

class DesktopVideo extends FlxBasic
{
  public var video:FlxVideoSprite;

  public var finishCallback:Void->Void;

  public function new(vidSrc:String)
  {
    super();

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
      trace('Null video...');
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
