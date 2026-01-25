package characters;

import characters.SimpleCharacterDatas;

interface ICharacter
{
	public function loadImage(data:AssetPath):Void;

	public function loadSingerAnimations(data:SingerAnimations):Void;

	public function loadSinger(data:SingerCharacterData):Void;

	public function loadDamselSinger(data:DamselSingerCharacterData):Void;

	public function loadDamselAnimations(data:DamselAnimations):Void;

	public function loadDamsel(data:DamselCharacterData):Void;

	public function loadDeathAnimations(data:DeathAnimations):Void;

	public function loadDeath(data:DeathCharacterData):Void;

	public function loadCharacter():Void;
	
}