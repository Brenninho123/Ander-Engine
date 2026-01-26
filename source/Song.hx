package;

import flixel.system.FlxVersion;
import thx.semver.Version;
import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;

	@:deprecated('This is unused now, remove your code checking for it')
	var ?validScore:Bool;

	var ?vocalsList:Array<String>;

	var version:Version;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(song:String, ?songFolder:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.chart(songFolder, song)).trim();

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;

		swagShit.version ??= "1.0.0";

		trace('swagshit(${swagShit.song}) version: ${swagShit.version}');

		if (swagShit.version != SWAGSHITVER)
		{
			trace(' * porting to $SWAGSHITVER...');

			#if MULTIPLE_VOICES
			swagShit.vocalsList ??= [];
			#end

			swagShit.version = SWAGSHITVER;
		}

		return swagShit;
	}

	public static var SWAGSHITVER:Version = "1.0.1";

	public static var DUMBASS:SwagSong = {
		song: 'Test',
		notes: [],
		bpm: 150,
		needsVoices: true,
		player1: 'bf',
		player2: 'dad',
		speed: 1,
		version: SWAGSHITVER,
		vocalsList: [],
	};
}
