package;

import Type.ValueType;
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
	var validScore:Bool;

	var ?vocalsList:VocalsDef;

	var version:Null<Int>;
}

typedef VocalsDef =
{
	opponent:Array<String>,
	player:Array<String>,
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

		swagShit.validScore = true;
		if (swagShit.version == null)
			swagShit.version = 0;

		trace('swagshit(${swagShit.song}) version: ${swagShit.version}');

		if (swagShit.version != SWAGSHITVER)
		{
			trace(' * porting to $SWAGSHITVER...');

			if (swagShit.vocalsList == null)
				swagShit.vocalsList = DEFAULTVOCALS;

			if (swagShit.vocalsList.opponent == null)
				swagShit.vocalsList.opponent = DEFAULTVOCALS.opponent;
			if (swagShit.vocalsList.player == null)
				swagShit.vocalsList.player = DEFAULTVOCALS.player;

			swagShit.version = SWAGSHITVER;
			trace('PORTED!');
		}

		for (shit in Reflect.fields(swagShit))
			trace(' * $shit : ${Reflect.field(swagShit, shit)}');

		return swagShit;
	}

	public static var SWAGSHITVER:Int = 2;

	public static var DUMBASS:SwagSong = {
		song: 'Test',
		notes: [],
		bpm: 150,
		needsVoices: true,
		player1: 'bf',
		player2: 'dad',
		speed: 1,
		validScore: false,
		version: 0,
		vocalsList: {
			player: [],
			opponent: [],
		},
	};

	public static var DEFAULTVOCALS:VocalsDef = {
		player: [],
		opponent: [],
	}
}
