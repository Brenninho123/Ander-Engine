package cutscenes.video;

#if (!VIDEO_WEB && !VIDEO_DESKTOP)
typedef VideoCutsceneClass = FlxBasic;
#elseif VIDEO_WEB
typedef VideoCutsceneClass = WebVideo;
#elseif VIDEO_DESKTOP
typedef VideoCutsceneClass = DesktopVideo;
#end

class VideoCutscene extends VideoCutsceneClass
{
	#if (!VIDEO_WEB && !VIDEO_DESKTOP)
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
			finishCallback = finishCallback;
		}

		if (finishCallback != null)
			finishCallback();

		return finishCallback;
	}

	override public function new(vidSrc:String)
	{
		trace('not VIDEO_WEB or VIDEO_DESKTOP, set "finishCallback" to do whatever you need to');

		video = new FlxSprite();
	}

	public function setCameras(cameras:Array<FlxCamera>) {}
	#end
}
