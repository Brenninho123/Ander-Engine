package play.characters;

interface ICharacter
{
  public function loadImage(data:AssetPath):Void;

  public function loadOffset(data:OffsetFile):Void;

  public function loadCustomAnimations(data:CustomAnimations):Void;

  public function loadCustom(data:CustomCharacterData):Void;

  public function loadSingerAnimations(data:SingerAnimations):Void;

  public function loadSinger(data:SingerCharacterData):Void;

  public function loadDamselSinger(data:DamselSingerCharacterData):Void;

  public function loadDamselAnimations(data:DamselAnimations):Void;

  public function loadDamsel(data:DamselCharacterData):Void;

  public function loadDeathAnimations(data:DeathAnimations):Void;

  public function loadDeath(data:DeathCharacterData):Void;

  public function loadCharacter():Void;
}

typedef OffsetFile =
{
  ?offsetFile:String,
}

typedef AssetPath =
{
  assetPath:String,
}

typedef SingerDirectionAnimations =
{
  leftName:String,
  downName:String,
  upName:String,
  rightName:String,
}

typedef SingerAnimations =
{
  > SingerDirectionAnimations,
  idleName:String,
}

typedef CustomAnimations =
{
  ?custom:Map<String, String>,
}

typedef CustomCharacterData =
{
  > OffsetFile,
  > AssetPath,
  > CustomAnimations,
}

typedef SingerCharacterData =
{
  > OffsetFile,
  > AssetPath,
  > CustomAnimations,
  > SingerAnimations,
}

typedef DeathAnimations =
{
  firstDeathName:String,
  deathLoopName:String,
  deathConfirmName:String,
}

typedef DeathCharacterData =
{
  > OffsetFile,
  > AssetPath,
  > CustomAnimations,
  > DeathAnimations,
}

typedef DamselAnimations =
{
  danceLeft:String,
  danceRight:String,

  ?danceLeft_indices:Array<Int>,
  ?danceRight_indices:Array<Int>,
}

typedef DamselCharacterData =
{
  > OffsetFile,
  > AssetPath,
  > CustomAnimations,
  > DamselAnimations,
}

typedef DamselSingerCharacterData =
{
  > DamselCharacterData,
  > SingerDirectionAnimations,
}
