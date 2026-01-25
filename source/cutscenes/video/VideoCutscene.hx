package cutscenes.video;

#if VIDEO_WEB
class VideoCutscene extends WebVideo
#elseif VIDEO_DESKTOP
class VideoCutscene extends DesktopVideo
#else
class VideoCutscene extends flixel.FlxBasic
#end
{
	#if (!VIDEO_WEB && !VIDEO_DESKTOP)
	public var finishCallback(default, set):Void->Void;

	function set_finishCallback(callback:Void->Void):Void->Void
	{
		if (callback != null)
		{
			finishCallback = callback;
		}
		else
		{
			finishCallback = finishCallback;
		}

		if (finishCallback != null)
			finishCallback();

		return finishCallback;
	}

	override public function new(vidSrc:String) {
		trace('not VIDEO_WEB or VIDEO_DESKTOP, set "finishCallback" to do whatever you need to');
	}
	#end
}
