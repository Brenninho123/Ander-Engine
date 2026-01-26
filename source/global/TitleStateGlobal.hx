package global;

import flixel.util.typeLimit.OneOfTwo;

class TitleStateGlobal
{
	public static var introTextPath:String = Paths.txt('introText');

	/**
		A list of the intro text shit
		each entry is a beat

		@param Array<String> will add multiple texts
		@param String will add a single text
		@param Null clears screen
		@param "" nothing

		@param "$ngSpr=" will change `ngSpr` to visisble (1) or invisible (anything else)
		@param "$wacky=" will add one of the curWacky's
	**/
	public static var introTextList:Array<OneOfTwo<Array<String>, String>> = [
		['macohi', 'djotta flow'],
		['funniboi', 'flying.haxe'],
		'present',
		null,
		['with no association', 'with'],
		'',
		['newgrounds', '%ngSpr=1'],
		[null, '%ngSpr=0'],
		'%wacky=0',
		'%wacky=1',
		null,
		'Friday',
		'Night',
		'Funkin'
	];
}
