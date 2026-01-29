package play.characters;

import flixel.util.FlxSort;

class Character extends FlxAnimate
{
  public var animOffsets:Map<String, Array<Dynamic>>;
  public var debugMode:Bool = false;

  public var isPlayer:Bool = false;
  public var curCharacter:String = 'bf';

  public var holdTimer:Float = 0;

  public var animationNotes:Array<Dynamic> = [];

  public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
  {
    super(x, y);

    animOffsets = new Map<String, Array<Dynamic>>();
    curCharacter = character;
    this.isPlayer = isPlayer;

    antialiasing = true;

    new SparrowCharacter(this, character).loadCharacter();
    new PackerCharacter(this, character).loadCharacter();

    if (anim.getAnimationList().length == 0) trace(' * FAILED');

    dance();

    if (isPlayer)
    {
      flipX = !flipX;

      // Doesn't flip for BF, since his are already in the right place???
      if (!curCharacter.startsWith('bf'))
      {
        // var animArray
        var oldRight = anim.getByName('singRIGHT').frames;
        anim.getByName('singRIGHT').frames = anim.getByName('singLEFT').frames;
        anim.getByName('singLEFT').frames = oldRight;

        // IF THEY HAVE MISS ANIMATIONS??
        if (anim.getByName('singRIGHTmiss') != null)
        {
          var oldMiss = anim.getByName('singRIGHTmiss').frames;
          anim.getByName('singRIGHTmiss').frames = anim.getByName('singLEFTmiss').frames;
          anim.getByName('singLEFTmiss').frames = oldMiss;
        }

        trace('flipped ur shit');
      }
    }
  }

  public function loadMappedAnims()
  {
    trace('MAPPED SHIT');
    var swagshit = Song.loadFromJson('picospeaker', 'stress');

    var notes = swagshit.notes;

    for (section in notes)
    {
      for (idk in section.sectionNotes)
        animationNotes.push(idk);
    }

    play.stage.objects.TankmenBG.animationNotes = animationNotes;

    trace('tankmen to prob shoot: ' + animationNotes.length);
  }

  function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
  {
    return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
  }

  public function quickAnimAdd(name:String, prefix:String, looped:Bool = false)
  {
    if (isAnimate) anim.addByFrameLabel(name, prefix, 24, looped);
    else
      anim.addByPrefix(name, prefix, 24, looped);
  }

  public function indicwes(name:String, prefix:String, indices:Array<Int>, looped:Bool = false, fps:Int = 24)
  {
    if (isAnimate) anim.addByFrameLabelIndices(name, prefix, indices, fps, looped);
    else
      anim.addByIndices(name, prefix, indices, '', fps, looped);
  }

  public function loadOffsetFile(offsetCharacter:String)
  {
    var daFile:Array<String> = CoolUtil.coolTextFile(Paths.txt("offsets/" + offsetCharacter, 'characters'));

    for (i in daFile)
    {
      var splitWords:Array<String> = i.split(" ");
      addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
    }
  }

  override function update(elapsed:Float)
  {
    if (!curCharacter.startsWith('bf'))
    {
      if (anim.name.startsWith('sing'))
      {
        holdTimer += elapsed;
      }

      var dadVar:Float = 4;

      if (curCharacter == 'dad') dadVar = 6.1;
      if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
      {
        dance();
        holdTimer = 0;
      }
    }

    if (curCharacter.endsWith('-car'))
    {
      // looping hair anims after idle finished
      if (!anim.name.startsWith('sing') && anim.finished) playAnim('idleHair');
    }

    switch (curCharacter)
    {
      case 'gf':
        if (anim.name == 'hairFall' && anim.finished) playAnim('danceRight');
      case "pico-speaker":
        // for pico??
        if (animationNotes.length > 0)
        {
          if (Conductor.songPosition > animationNotes[0][0])
          {
            var shootAnim:Int = 1;

            if (animationNotes[0][1] >= 2) shootAnim = 3;

            shootAnim += FlxG.random.int(0, 1);

            playAnim('shoot' + shootAnim, true);
            animationNotes.shift();
          }
        }

        if (anim.finished)
        {
          playAnim(anim.name, false, false, anim.numFrames - 3);
        }
    }

    super.update(elapsed);
  }

  private var danced:Bool = false;

  /**
   * FOR GF DANCING SHIT
   */
  public function dance()
  {
    if (!debugMode)
    {
      if (curCharacter.startsWith('gf') && anim.name.startsWith('hair')) return;

      switch (curCharacter)
      {
        case 'tankman':
          if (!anim.name.endsWith('DOWN-alt')) playAnim('idle');
          return;
      }

      if (anim.getNameList().contains('danceLeft'))
      {
        danced = !danced;

        if (danced) playAnim('danceRight');
        else
          playAnim('danceLeft');
      }
      else
      {
        playAnim('idle');
      }
    }
  }

  public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
  {
    if (!anim.exists(AnimName)) return;

    anim.play(AnimName, Force, Reversed, Frame);

    var daOffset = animOffsets.get(AnimName);
    if (animOffsets.exists(AnimName)) offset.set(daOffset[0], daOffset[1]);
    else
      offset.set(0, 0);

    if (curCharacter == 'gf')
    {
      if (AnimName == 'singLEFT')
      {
        danced = true;
      }
      else if (AnimName == 'singRIGHT')
      {
        danced = false;
      }

      if (AnimName == 'singUP' || AnimName == 'singDOWN')
      {
        danced = !danced;
      }
    }
  }

  public function addOffset(name:String, x:Float = 0, y:Float = 0)
  {
    animOffsets[name] = [x, y];
  }
}
