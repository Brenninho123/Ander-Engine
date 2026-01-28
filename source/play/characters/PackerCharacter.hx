package play.characters;

class PackerCharacter extends SparrowCharacter
{
  override function loadImage(data:play.characters.SimpleCharacterDatas.AssetPath)
  {
    if (data.assetPath == null) return;

    character.frames = Paths.getPackerAtlas('characters/${data.assetPath}', 'characters');
  }

  override function loadCharacter()
  {
    var hasImplementation:Bool = true;
    switch (curCharacter)
    {
      case 'spirit':
        loadSinger(
          {
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
    trace(' * IMPLEMENTATION: PACKER');
  }
}
