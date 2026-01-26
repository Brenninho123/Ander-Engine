package ui;

import GameJolt.GameJoltLogin;
import ui.OptionsState.Page;

class JolyPage extends Page
{
  override public function new(exit:Bool = false)
  {
    super();

    if (exit) onExit.dispatch();
    else
      LoadingState.loadAndSwitchState(new GameJoltLogin());
  }
}
