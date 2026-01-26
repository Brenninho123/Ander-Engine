package ui;

import GameJolt.GameJoltLogin;
import ui.OptionsState.Page;

class JolyPage extends Page
{
  override public function new()
  {
    super();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    LoadingState.loadAndSwitchState(new GameJoltLogin());
  }
}
