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
    if (data.assetPath == null) return;

    var tex = Paths.getSparrowAtlas('characters/${data.assetPath}', 'characters');
    character.frames = tex;
    trace(' * sparrow: ${Paths.image('characters/${data.assetPath}', 'characters')}');
  }

  public function loadCustomAnimations(data:CustomAnimations)
  {
    if (data.custom == null) return;

    for (name => prefix in data.custom)
      character.quickAnimAdd(name, prefix);
  }

  public function loadCustom(data:CustomCharacterData)
  {
    loadImage(data);
    loadCustomAnimations(data);
    loadOffset(data);
  }

  public function loadOffset(data:OffsetFile)
  {
    character.loadOffsetFile(data.offsetFile ?? curCharacter);
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

    if (data.idleName != null) character.quickAnimAdd('idle', data.idleName);

    loadSingerAnimations(data);
    loadCustomAnimations(data);

    loadOffset(data);

    if (data.idleName != null) character.playAnim('idle');
  }

  public function loadDamselSinger(data:DamselSingerCharacterData)
  {
    loadDamsel(data);
    loadSingerAnimations(cast data);
  }

  public function loadDamselAnimations(data:DamselAnimations)
  {
    if (data.danceLeft_indices != null) character.indicwes('danceLeft', data.danceLeft, data.danceLeft_indices, false);
    else
      character.quickAnimAdd('danceLeft', data.danceLeft);

    if (data.danceRight != null) character.indicwes('danceRight', data.danceRight, data.danceRight_indices, false);
    else
      character.quickAnimAdd('danceRight', data.danceRight);
  }

  public function loadDamsel(data:DamselCharacterData)
  {
    loadImage(data);

    loadDamselAnimations(data);
    loadCustomAnimations(data);

    loadOffset(data);

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
    loadCustomAnimations(data);

    loadOffset(data);

    character.playAnim('firstDeath');
  }

  public function loadCharacter()
  {
    var hasImplementation:Bool = true;

    trace(curCharacter);

    switch (curCharacter)
    {
      case 'gf' | 'gf-christmas':
        loadDamselSinger(
          {
            assetPath: (curCharacter == 'gf-christmas') ? 'gfChristmas' : 'GF_assets',

            danceLeft: 'GF Dancing Beat0',
            danceRight: 'GF Dancing Beat0',

            danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
            danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],

            custom: ['cheer' => 'GF Cheer', 'scared' => 'GF FEAR',],

            upName: 'Gf Up note',
            downName: 'Gf Down note',
            leftName: 'Gf left note',
            rightName: 'Gf Right note'
          });

        character.indicwes('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], true);

        if (curCharacter == 'gf')
        {
          character.indicwes('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3]);
          character.indicwes('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], false);
        }

      case 'gf-car' | 'gf-tankmen':
        loadDamsel(
          {
            assetPath: (curCharacter == 'gf-car') ? 'gfCar' : 'gfTankmen',

            danceLeft: (curCharacter == 'gf-car') ? 'GF Dancing Beat Hair blowing CAR' : 'GF Dancing at Gunpoint',
            danceRight: (curCharacter == 'gf-car') ? 'GF Dancing Beat Hair blowing CAR' : 'GF Dancing at Gunpoint',

            danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
            danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],

            offsetFile: (curCharacter == 'gf-tankmen') ? 'gf' : curCharacter
          });

        if (curCharacter == 'gf-tankmen') character.indicwes('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], true);

      case 'gf-pixel':
        loadDamsel(
          {
            assetPath: 'gfPixel',

            danceLeft: 'GF IDLE',
            danceRight: 'GF IDLE',

            danceLeft_indices: [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
            danceRight_indices: [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
          });

        character.setGraphicSize(Std.int(character.width * PlayState.daPixelZoom));
        character.updateHitbox();
        character.antialiasing = false;

      case 'dad':
        loadSinger(
          {
            assetPath: 'DADDY_DEAREST',
            idleName: 'Dad idle dance',
            upName: 'Dad Sing Note UP',
            rightName: 'Dad Sing Note RIGHT',
            downName: 'Dad Sing Note DOWN',
            leftName: 'Dad Sing Note LEFT',
          });

      case 'spooky':
        loadDamselSinger(
          {
            assetPath: 'spooky_kids_assets',

            upName: 'spooky UP NOTE',
            downName: 'spooky DOWN note',
            leftName: 'note sing left',
            rightName: 'spooky sing right',

            danceLeft: 'spooky dance idle',
            danceRight: 'spooky dance idle',

            danceLeft_indices: [0, 2, 6],
            danceRight_indices: [8, 10, 12, 14],
          });

      case 'mom' | 'mom-car':
        loadSinger(
          {
            assetPath: ((curCharacter == 'mom') ? 'Mom_Assets' : 'momCar'),
            idleName: 'Mom Idle',
            upName: 'Mom Up Pose',
            downName: 'MOM DOWN POSE',
            leftName: 'Mom Left Pose',
            rightName: 'Mom Pose Left',
          });

        if (curCharacter == 'mom-car') character.indicwes('idleHair', "Mom Idle", [10, 11, 12, 13], true);

      case 'monster' | 'monster-christmas':
        loadSinger(
          {
            assetPath: ((curCharacter == 'monster') ? 'Monster_Assets' : 'monsterChristmas'),
            idleName: 'monster idle',
            upName: 'monster up note',
            downName: 'monster down',
            leftName: 'Monster left note',
            rightName: 'Monster Right note',
          });

      case 'pico':
        loadSinger(
          {
            assetPath: 'pico/Pico_FNF_assetss',
            idleName: 'Pico Idle Dance',
            upName: 'pico Up note instance',
            downName: 'Pico Down Note instance',
            leftName: (character.isPlayer) ? 'Pico NOTE LEFT instance' : 'Pico Note Right instance',
            rightName: (character.isPlayer) ? 'Pico Note Right instance' : 'Pico NOTE LEFT instance',
          });

        if (character.isPlayer)
        {
          character.quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss instance');
          character.quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss instance');
        }
        else
        {
          // Need to be flipped! REDO THIS LATER!
          character.quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss instance');
          character.quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss instance');
        }

        character.quickAnimAdd('singUPmiss', 'pico Up note miss instance');
        character.quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS instance');

        character.flipX = true;

      case 'pico-speaker':
        loadCustom(
          {
            assetPath: 'pico/picoSpeaker',
            custom: [
              'shoot1' => 'Pico shoot 1',
              'shoot2' => 'Pico shoot 2',
              'shoot3' => 'Pico shoot 3',
              'shoot4' => 'Pico shoot 4',
            ]
          });

        character.loadOffsetFile(curCharacter);
        character.playAnim('shoot1');

      case 'bf' | 'bf-christmas' | 'bf-car' | 'bf-pixel' | 'bf-holding-gf':
        var ass = 'BOYFRIEND';

        if (curCharacter == 'bf-christmas') ass = 'bfChristmas';
        if (curCharacter == 'bf-car') ass = 'bfCar';
        if (curCharacter == 'bf-pixel') ass = 'bfPixel';
        if (curCharacter == 'bf-holding-gf') ass = 'bfAndGF';

        loadSinger(
          {
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

        if (curCharacter != 'bf-car' && curCharacter != 'bf-pixel') character.quickAnimAdd('hey', 'BF HEY');

        if (curCharacter == 'bf')
        {
          loadDeathAnimations(
            {
              firstDeathName: 'BF dies',
              deathLoopName: 'BF Dead Loop',
              deathConfirmName: 'BF Dead confirm',
            });

          character.animation.addByPrefix('scared', 'BF idle shaking', 24, true);
        }

        if (curCharacter == 'bf-holding-gf') character.quickAnimAdd('catch', 'BF catches GF');

        if (curCharacter == 'bf-car') character.indicwes('idleHair', 'BF idle dance', [10, 11, 12, 13], true);

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
        loadDeath(
          {
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
        loadDeath(
          {
            assetPath: 'bfHoldingGF-DEAD',
            firstDeathName: 'BF Dies with GF',
            deathLoopName: 'BF Dead with GF Loop',
            deathConfirmName: 'RETRY confirm holding gf',
          });

        character.flipX = true;

      case 'senpai' | 'senpai-angry':
        loadSinger(
          {
            assetPath: 'senpai',

            idleName: (curCharacter == 'senpai-angry') ? 'Angry Senpai Idle' : 'Senpai Idle',
            upName: (curCharacter == 'senpai-angry') ? 'Angry Senpai UP NOTE' : 'SENPAI UP NOTE',
            downName: (curCharacter == 'senpai-angry') ? 'Angry Senpai DOWN NOTE' : 'SENPAI DOWN NOTE',
            rightName: (curCharacter == 'senpai-angry') ? 'Angry Senpai RIGHT NOTE' : 'SENPAI RIGHT NOTE',
            leftName: (curCharacter == 'senpai-angry') ? 'Angry Senpai LEFT NOTE' : 'SENPAI NOTE NOTE',
          });

        character.loadOffsetFile(curCharacter);

        character.setGraphicSize(Std.int(character.width * 6));
        character.updateHitbox();

        character.antialiasing = false;

      case 'parents-christmas':
        loadSinger(
          {
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
        loadSinger(
          {
            assetPath: 'tankmanCaptain',
            idleName: 'Tankman Idle Dance instance',
            upName: 'Tankman UP note instance',
            downName: 'Tankman DOWN note instance',
            leftName: (character.isPlayer) ? 'Tankman Note Left instance' : 'Tankman Right Note instance',
            rightName: (character.isPlayer) ? 'Tankman Right Note instance' : 'Tankman Note Left instance',
          });

        // PRETTY GOOD tankman
        // TANKMAN UGH instanc

        character.quickAnimAdd('singDOWN-alt', 'PRETTY GOOD tankman instance 1');
        character.quickAnimAdd('singUP-alt', 'TANKMAN UGH instance');

        character.flipX = true;

      default:
        hasImplementation = false;
    }
    info(hasImplementation);
  }

  public function info(hasImplementation:Bool)
  {
    if (hasImplementation)
    {
      exclusiveInfo();
    }
  }

  public function exclusiveInfo()
  {
    trace(' * IMPLEMENTATION: SPARROW');
  }
}
