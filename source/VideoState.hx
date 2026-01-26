package;

import cutscenes.video.VideoCutscene;
import flixel.FlxG;
import openfl.display.Sprite;

class VideoState extends MusicBeatState
{
  var video:VideoCutscene;
  private var overlay:Sprite;

  public static var seenVideo:Bool = false;

  override function create()
  {
    super.create();

    seenVideo = true;

    FlxG.save.data.seenVideo = true;
    FlxG.save.flush();

    if (FlxG.sound.music != null) FlxG.sound.music.stop();

    video = new VideoCutscene(Paths.mp4('kickstarterTrailer'));

    video.finishCallback = function() {
      TitleState.initialized = false;
      FlxG.switchState(() -> new TitleState());
    };
  }

  override function update(elapsed:Float)
  {
    if (controls.ACCEPT) finishVid();

    super.update(elapsed);
  }

  function finishVid():Void
  {
    video.finishCallback();
  }
}
