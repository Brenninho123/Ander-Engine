package characters;

import characters.SimpleCharacterDatas;

class SparrowCharacter implements ICharacter
{
	public var character:Character;

	public var curCharacter:String;

	public function new(character:Character, curCharacter:String)
	{
		this.character = character;
		this.curCharacter = curCharacter;
	}

	public function loadImage(data:AssetPath):Void
	{
		if (data.assetPath == null)
			return;

		var tex = Paths.getSparrowAtlas('characters/${data.assetPath}');
		character.frames = tex;
	}

	public function loadSingerAnimations(data:SingerAnimations)
	{
		character.quickAnimAdd('singUP', data.upName);
		character.quickAnimAdd('singRIGHT', data.rightName);
		character.quickAnimAdd('singDOWN', data.downName);
		character.quickAnimAdd('singLEFT', data.leftName);
	}

	public function loadSinger(data:SingerCharacterData)
	{
		// DAD ANIMATION LOADING CODE
		loadImage(data);

		if (data.idleName != null)
			character.quickAnimAdd('idle', data.idleName);

		loadSingerAnimations(data);

		character.loadOffsetFile(data.offsetFile ?? curCharacter);

		if (data.idleName != null)
			character.playAnim('idle');
	}

	public function loadDamselSinger(data:DamselSingerCharacterData)
	{
		loadDamsel(data);
		loadSingerAnimations(cast data);
	}

	public function loadDamselAnimations(data:DamselAnimations)
	{
		if (data.danceLeft_indices != null)
			character.animation.addByIndices('danceLeft', data.danceLeft, data.danceLeft_indices, "", 24, false);
		else
			character.quickAnimAdd('danceLeft', data.danceLeft);

		if (data.danceRight != null)
			character.animation.addByIndices('danceRight', data.danceRight, data.danceRight_indices, "", 24, false);
		else
			character.quickAnimAdd('danceRight', data.danceRight);
	}

	public function loadDamsel(data:DamselCharacterData)
	{
		loadImage(data);

		loadDamselAnimations(data);

		character.loadOffsetFile(data.offsetFile ?? curCharacter);

		character.playAnim('danceLeft');
	}

	public function loadDeathAnimations(data:DeathAnimations)
	{
		character.quickAnimAdd('firstDeath', data.firstDeathName);
		character.animation.addByPrefix('deathLoop', data.deathLoopName, 24, true);
		character.quickAnimAdd('deathConfirm', data.deathConfirmName);
	}

	public function loadDeath(data:DeathCharacterData)
	{
		trace('loading death...');
		loadImage(data);

		loadDeathAnimations(data);

		character.loadOffsetFile(data.offsetFile ?? curCharacter);

		character.playAnim('firstDeath');
	}

	public function loadCharacter()
	{
		var hasImplementation:Bool = true;

		switch (curCharacter)
		{
			case 'gf' | 'gf-christmas' | 'gf-tankmen' | 'gf-car' | 'gf-pixel':
				if (curCharacter == 'gf-pixel')
				{
					loadDamsel({
						assetPath: 'gfPixel',

						danceLeft: 'GF IDLE',
						danceRight: 'GF IDLE',

						danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
						danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
					});

					character.setGraphicSize(Std.int(character.width * PlayState.daPixelZoom));
					character.updateHitbox();
					character.antialiasing = false;

					return;
				}

				if (curCharacter == 'gf-car')
				{
					loadDamsel({
						assetPath: 'gfCar',

						danceLeft: 'GF Dancing Beat Hair blowing CAR',
						danceRight: 'GF Dancing Beat Hair blowing CAR',

						danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
						danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
					});

					character.animation.addByIndices('idleHair', 'GF Dancing Beat Hair blowing CAR', [10, 11, 12, 25, 26, 27], "", 24, true);

					return;
				}

				if (curCharacter == 'gf-tankmen')
				{
					loadDamsel({
						assetPath: 'gfTankmen',

						danceLeft: 'GF Dancing at Gunpoint',
						danceRight: 'GF Dancing at Gunpoint',

						danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
						danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],

						offsetFile: 'gf'
					});

					character.animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
					return;
				}

				var constData:DamselCharacterData = {
					assetPath: (curCharacter == 'gf-christmas') ? 'gfChristmas' : 'GF_assets',

					danceLeft: 'GF Dancing Beat',
					danceRight: 'GF Dancing Beat',

					danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
					danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
				};

				if (curCharacter == 'gf')
					loadDamselSinger({
						assetPath: constData.assetPath,

						danceLeft: constData.danceLeft,
						danceRight: constData.danceRight,

						danceLeft_indices: constData.danceLeft_indices,
						danceRight_indices: constData.danceRight_indices,

						leftName: 'GF left note',
						downName: 'GF Down note',
						upName: 'GF Up note',
						rightName: 'GF Right note',
					});
				else
					loadDamsel(constData);

				character.quickAnimAdd('cheer', 'GF Cheer');

				character.animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				character.animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				character.animation.addByPrefix('scared', 'GF FEAR', 24, true);

				character.animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);

			case 'dad':
				loadSinger({
					assetPath: 'DADDY_DEAREST',
					idleName: 'Dad idle dance',
					upName: 'Dad Sing Note UP',
					rightName: 'Dad Sing Note RIGHT',
					downName: 'Dad Sing Note DOWN',
					leftName: 'Dad Sing Note LEFT',
				});

			case 'spooky':
				loadSinger({
					assetPath: 'spooky_kids_assets',
					idleName: null,
					upName: 'spooky UP NOTE',
					downName: 'spooky DOWN note',
					leftName: 'note sing left',
					rightName: 'spooky sing right',
				});

				character.animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				character.animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				character.playAnim('danceRight');

			case 'mom' | 'mom-car':
				loadSinger({
					assetPath: ((curCharacter == 'mom') ? 'Mom_Assets' : 'momCar'),
					idleName: 'Mom Idle',
					upName: 'Mom Up Pose',
					downName: 'MOM DOWN POSE',
					leftName: 'Mom Left Pose',
					rightName: 'Mom Pose Left',
				});

				if (curCharacter == 'mom-car')
					character.animation.addByIndices('idleHair', "Mom Idle", [10, 11, 12, 13], "", 24, true);

			case 'monster' | 'monster-christmas':
				loadSinger({
					assetPath: ((curCharacter == 'monster') ? 'Monster_Assets' : 'monsterChristmas'),
					idleName: 'monster idle',
					upName: 'monster up note',
					downName: 'monster down',
					leftName: 'Monster left note',
					rightName: 'Monster Right note',
				});

			case 'pico':
				loadSinger({
					assetPath: 'pico/Pico_FNF_assetss',
					idleName: 'Pico Idle Dance',
					upName: 'pico Up note0',
					downName: 'Pico Down Note0',
					leftName: (character.isPlayer) ? 'Pico NOTE LEFT0' : 'Pico Note Right0',
					rightName: (character.isPlayer) ? 'Pico Note Right0' : 'Pico NOTE LEFT0',
					offsetFile: 'pico/' + curCharacter
				});

				if (character.isPlayer)
				{
					character.quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
					character.quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					character.quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
					character.quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
				}

				character.quickAnimAdd('singUPmiss', 'pico Up note miss');
				character.quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

				character.flipX = true;

			case 'pico-speaker':
				character.frames = Paths.getSparrowAtlas('characters/pico/picoSpeaker');

				character.quickAnimAdd('shoot1', "Pico shoot 1");
				character.quickAnimAdd('shoot2', "Pico shoot 2");
				character.quickAnimAdd('shoot3', "Pico shoot 3");
				character.quickAnimAdd('shoot4', "Pico shoot 4");

				// here for now, will be replaced later for less copypaste
				character.loadOffsetFile('pico/' + curCharacter);
				character.playAnim('shoot1');

			case 'bf' | 'bf-christmas' | 'bf-car' | 'bf-pixel' | 'bf-holding-gf':
				var ass = 'BOYFRIEND';

				if (curCharacter == 'bf-christmas')
					ass = 'bfChristmas';
				if (curCharacter == 'bf-car')
					ass = 'bfCar';
				if (curCharacter == 'bf-pixel')
					ass = 'bfPixel';
				if (curCharacter == 'bf-holding-gf')
					ass = 'bfAndGF';

				loadSinger({
					assetPath: ass,
					idleName: (curCharacter == 'bf-pixel') ? 'BF IDLE' : 'BF idle dance',
					upName: (curCharacter == 'bf-pixel') ? 'BF UP NOTE' : 'BF NOTE UP0',
					rightName: (curCharacter == 'bf-pixel') ? 'BF RIGHT NOTE' : 'BF NOTE RIGHT0',
					downName: (curCharacter == 'bf-pixel') ? 'BF DOWN NOTE' : 'BF NOTE DOWN0',
					leftName: (curCharacter == 'bf-pixel') ? 'BF LEFT NOTE' : 'BF NOTE LEFT0',
				});

				if (curCharacter == 'bf-pixel')
				{
					character.quickAnimAdd('singUPmiss', 'BF UP MISS');
					character.quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
					character.quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
					character.quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');
				}
				else
				{
					character.quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
					character.quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
					character.quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
					character.quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				}

				if (curCharacter != 'bf-car' && curCharacter != 'bf-pixel')
					character.quickAnimAdd('hey', 'BF HEY');

				if (curCharacter == 'bf')
				{
					loadDeathAnimations({
						firstDeathName: 'BF dies',
						deathLoopName: 'BF Dead Loop',
						deathConfirmName: 'BF Dead confirm',
					});

					character.animation.addByPrefix('scared', 'BF idle shaking', 24, true);
				}

				if (curCharacter == 'bf-holding-gf')
					character.quickAnimAdd('catch', 'BF catches GF');

				if (curCharacter == 'bf-car')
					character.animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], "", 24, true);

				if (curCharacter == 'bf-pixel')
				{
					character.setGraphicSize(Std.int(character.width * 6));
					character.updateHitbox();

					character.width -= 100;
					character.height -= 100;

					character.antialiasing = false;
				}

				character.flipX = true;

			case 'bf-pixel-dead':
				loadDeath({
					assetPath: 'bfPixelsDEAD',
					firstDeathName: 'BF Dies pixel',
					deathLoopName: 'Retry Loop',
					deathConfirmName: 'RETRY CONFIRM',
				});

				// pixel bullshit
				character.setGraphicSize(Std.int(character.width * 6));
				character.updateHitbox();
				character.antialiasing = false;
				character.flipX = true;

			case 'bf-holding-gf-dead':
				loadDeath({
					assetPath: 'bfHoldingGF-DEAD',
					firstDeathName: 'BF Dies with GF',
					deathLoopName: 'BF Dead with GF Loop',
					deathConfirmName: 'RETRY confirm holding gf',
				});

				character.flipX = true;

			case 'senpai' | 'senpai-angry':
				loadSinger({
					assetPath: 'senpai',

					idleName: (curCharacter == 'senpai-angry') ? 'Angry Senpai Idle' : 'Senpai Idle',
					upName: (curCharacter == 'senpai-angry') ? 'Angry Senpai UP NOTE' : 'SENPAI UP NOTE',
					downName: (curCharacter == 'senpai-angry') ? 'Angry Senpai DOWN NOTE' : 'SENPAI DOWN NOTE',
					rightName: (curCharacter == 'senpai-angry') ? 'Angry Senpai RIGHT NOTE' : 'SENPAI RIGHT NOTE',
					leftName: (curCharacter == 'senpai-angry') ? 'Angry Senpai LEFT NOTE NOTE' : 'SENPAI LEFT NOTE NOTE',
				});

				character.loadOffsetFile(curCharacter);

				character.setGraphicSize(Std.int(character.width * 6));
				character.updateHitbox();

				character.antialiasing = false;

			case 'parents-christmas':
				loadSinger({
					assetPath: 'mom_dad_christmas_assets',
					idleName: 'Parent Christmas Idle',
					upName: 'Parent Up Note Dad',
					downName: 'Parent Down Note Dad',
					rightName: 'Parent Right Note Dad',
					leftName: 'Parent Left Note Dad',
				});

				character.quickAnimAdd('singUP-alt', 'Parent Up Note Mom');
				character.quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
				character.quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
				character.quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

			case 'tankman':
				loadSinger({
					assetPath: 'tankmanCaptain',
					idleName: 'Pico Idle Dance',
					upName: 'Tankman UP note ',
					downName: 'Tankman DOWN note ',
					leftName: (character.isPlayer) ? 'Tankman Note Left' : 'Tankman Right Note',
					rightName: (character.isPlayer) ? 'Tankman Right Note' : 'Tankman Note Left',
				});

				character.frames = Paths.getSparrowAtlas('characters/tankmanCaptain');

				if (character.isPlayer)
				{
					character.quickAnimAdd('singLEFTmiss', 'Tankman Note Left MISS');
					character.quickAnimAdd('singRIGHTmiss', 'Tankman Right Note MISS');
				}
				else
				{
					// Need to be flipped! REDO THIS LATER
					character.quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');
					character.quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
				}

				character.quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
				character.quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');

				// PRETTY GOOD tankman
				// TANKMAN UGH instanc

				character.quickAnimAdd('singDOWN-alt', 'PRETTY GOOD');
				character.quickAnimAdd('singUP-alt', 'TANKMAN UGH');

				character.loadOffsetFile(curCharacter);

				character.playAnim('idle');

				character.flipX = true;

			default:
				hasImplementation = false;
				trace('no sparrow implementation');
		}

		info(hasImplementation);
	}

	public function info(hasImplementation:Bool)
	{
		if (hasImplementation)
		{
			exclusiveInfo();
			trace(' * ASSET PATH: ${character.graphic.assetsKey}');
		}
	}

	public function exclusiveInfo()
	{
		trace(' * CHARACTER TYPE: SPARROW');
	}
}
