package play.cutscenes.objects;

class TankCutscene extends FlxAnimate
{
  public var startSyncAudio:FlxSound;

  public function new(x:Float, y:Float)
  {
    super(x, y);
  }

  var startedPlayingSound:Bool = false;

  override function update(elapsed:Float)
  {
    if (anim.curAnim.curFrame >= 1 && !startedPlayingSound)
    {
      startSyncAudio.play();
      startedPlayingSound = true;
    }

    super.update(elapsed);
  }
}
