import ui.FunkinCamera;

/**
 * A `CameraFrontEnd` override that uses `FunkinCamera`!
 */
@:nullSafety
class FunkinCameraFrontEnd extends flixel.system.frontEnds.CameraFrontEnd
{
  public override function reset(?newCamera:flixel.FlxCamera):Void
  {
    super.reset(newCamera ?? new FunkinCamera());
  }
}
