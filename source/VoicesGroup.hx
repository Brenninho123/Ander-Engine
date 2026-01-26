import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;

// yoinked from funkin hehehe
// https://github.com/FunkinCrew/Funkin/blob/34dc1826ef08e70a205636075e534d6dee1ce680/source/VoicesGroup.hx
class VoicesGroup extends FlxTypedGroup<FlxSound>
{
	public var time(default, set):Float = 0;

	public var volume(default, set):Float = 1;

	public function new(song:String, ?files:Array<String>, ?needsVoices:Bool = true)
	{
		super();

		if (!needsVoices)
		{
			// simply adds an empty sound? fills it in moreso for easier backwards compatibility
			add(new FlxSound());

			return;
		}

		if (files == null || files.length == 0)
			files = [""]; // loads with no file name assumption, to load "Voices.ogg" or whatev normally

		for (sndFile in files)
		{
			var snd:FlxSound = new FlxSound().loadEmbedded(Paths.voices(song, sndFile));
			FlxG.sound.list.add(snd); // adds it to sound group for proper volumes
			add(snd); // adds it to main group for other shit
		}
	}

	// prob a better / cleaner way to do all these forEach stuff?
	public function pause()
	{
		forEachAlive(function(snd)
		{
			snd.pause();
		});
	}

	public function play()
	{
		forEachAlive(function(snd)
		{
			snd.play();
		});
	}

	public function stop()
	{
		forEachAlive(function(snd)
		{
			snd.stop();
		});
	}

	function set_time(time:Float):Float
	{
		forEachAlive(function(snd)
		{
			// account for different offsets per sound?
			snd.time = time;
		});

		return time;
	}

	// in PlayState, adjust the code so that it only mutes the player1 vocal tracks?
	function set_volume(volume:Float):Float
	{
		forEachAlive(function(snd)
		{
			snd.volume = volume;
		});

		return volume;
	}
}