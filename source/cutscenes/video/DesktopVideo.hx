package cutscenes.video;

#if VIDEO_DESKTOP
import flixel.util.FlxTimer;
import flixel.FlxG;
import hxcodec.flixel.FlxVideoSprite;
import flixel.FlxBasic;

class DesktopVideo extends FlxBasic
{
	public var video:FlxVideoSprite;

	public var finishCallback:Void->Void;

	public function new(vidSrc:String)
	{
		super();

		video = new FlxVideoSprite(0, 0);

		if (video != null)
		{
			trace('ITS VIDEO TIME BITCH!');
			video.autoPause = false;
			video.play(vidSrc, false);
			FlxG.state.add(video);

			video.bitmap.onEndReached.add(finishVideo);

			// Resize video bigger or smaller than the screen.
			video.bitmap.onTextureSetup.add(() ->
			{
				video.setGraphicSize(FlxG.width, FlxG.height);
				video.updateHitbox();
				video.setPosition(0, 0);
			});
		}
		else
		{
			trace('Null video shit');
			FlxTimer.wait(.4, function()
			{
				finishVideo();
			});
		}
	}

	public function finishVideo()
	{
		if (FlxG.state.members.contains(video))
			FlxG.state.remove(video);

		if (finishCallback != null)
			finishCallback();
	}
}
#end
