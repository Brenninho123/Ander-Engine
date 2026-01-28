package ui.story.objects;

class StoryTitle extends FlxSprite
{
  public var targetY:Float = 0;
  public var flashingInt:Int = 0;

  public function new(x:Float, y:Float, weekNum:Int = 0)
  {
    super(x, y, Paths.image('storymenu/week$weekNum'));
  }

  var isFlashing:Bool = false;

  public inline function startFlashing():Void
    isFlashing = true;

  var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

  override function update(elapsed:Float)
  {
    super.update(elapsed);
    y = CoolUtil.coolLerp(y, (targetY * 120) + 480, 0.17);

    if (isFlashing) flashingInt++;

    if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2)) this.color = 0xFF33ffff;
    else
      this.color = FlxColor.WHITE;
  }
}
