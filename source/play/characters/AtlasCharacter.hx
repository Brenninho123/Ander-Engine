package play.characters;

class AtlasCharacter extends SparrowCharacter
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
      default:
        hasImplementation = false;
    }

    info(hasImplementation);
  }

  override function exclusiveInfo()
  {
    trace(' * IMPLEMENTATION: ATLAS');
  }
}
