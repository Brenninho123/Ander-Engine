package cutscenes.video;

import flixel.FlxG;
import hxcodec.flixel.FlxVideoSprite;
import flixel.FlxBasic;

class DesktopVideo extends FlxBasic
{
	var video:FlxVideoSprite;

	public var finishCallback:Void->Void;

	public function new(vidSrc:String)
	{
		super();

		video = new FlxVideoSprite(0, 0);
		video.bitmap.onEndReached.add(finishVideo);
		FlxG.state.add(video);

		video.play(vidSrc, false);

		// Resize video bigger or smaller than the screen.
		video.bitmap.onTextureSetup.add(() ->
		{
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
			video.x = 0;
			video.y = 0;
			// video.scale.set(0.5, 0.5);
		});
	}

	public function finishVideo()
	{
		FlxG.state.remove(video);

		if (finishCallback != null)
			finishCallback();
	}
}
