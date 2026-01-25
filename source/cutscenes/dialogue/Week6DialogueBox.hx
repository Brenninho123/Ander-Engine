package cutscenes.dialogue;

import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class Week6DialogueBox extends BasicDialogueBox
{
	override function makePortraits()
	{
		super.makePortraits();

		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
	}

	override function makeDialogueBox():Bool
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				return true;

			case 'roses':
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				return true;

			case 'thorns':
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

				return true;
		}

		return super.makeDialogueBox();
	}

	override function playMusic()
	{
		if (music != null)
			music.fadeIn(1, 0, 0.8);
	}

	override public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				music = new FlxSound();
				music.loadEmbedded(Paths.music('Lunchbox'));
			case 'thorns':
				music = new FlxSound();
				music.loadEmbedded(Paths.music('LunchboxScary'));
				music.fadeIn(1, 0, 0.8);
		}

		super(talkingRight, dialogueList);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		if (dropText != null)
			dropText.color = 0xFFD89494; 
		if (swagDialogue != null)
			swagDialogue.color = 0xFF3F2021;
	}

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		super.update(elapsed);
	}

	override function ending()
	{
		super.ending();

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
			FlxG.sound.music.fadeOut(2.2, 0);
	}
}
