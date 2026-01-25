package characters;

import characters.SimpleCharacterDatas;

class PackerCharacter extends SparrowCharacter
{
	override function loadImage(data:AssetPath)
	{
		if (data.assetPath == null)
			return;

		trace('loading packer : characters/${data.assetPath}');
		var tex = Paths.getPackerAtlas('characters/${data.assetPath}');
		character.frames = tex;
	}

	override function loadCharacter()
	{
		trace('attempting to load packer character ${curCharacter}');
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
				trace('no packer implementation');
		}
	}
}
