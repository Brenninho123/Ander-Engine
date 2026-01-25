package characters;

import characters.SimpleCharacterDatas;

class PackerCharacter extends SparrowCharacter
{
	override function loadImage(data:AssetPath)
	{
		if (data.assetPath == null)
			return;

		var tex = Paths.getPackerAtlas('characters/${data.assetPath}', 'characters');
		character.frames = tex;
	}

	override function loadCharacter()
	{
		var hasImplementation:Bool = true;
		switch (curCharacter)
		{
			case 'spirit':
				loadSinger({
					assetPath: 'spirit',
					idleName: 'idle spirit_',
					upName: 'up_',
					rightName: 'right_',
					leftName: 'left_',
					downName: 'spirit down',
				});

				character.setGraphicSize(Std.int(character.width * 6));
				character.updateHitbox();

				character.playAnim('idle');

				character.antialiasing = false;

			default:
				hasImplementation = false;
		}

		info(hasImplementation);
	}

	override function exclusiveInfo()
	{
		trace(' * CHARACTER TYPE: PACKER');
	}
}
