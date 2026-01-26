package characters;

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
