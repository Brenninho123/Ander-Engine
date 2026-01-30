package ui.options;

import flixel.util.FlxSignal;

class OptionsState extends MusicBeatState
{
  var pages = new Map<PageName, Page>();
  var currentName:PageName = Options;
  var currentPage(get, never):Page;

  inline function get_currentPage()
    return pages[currentName];

  override function create()
  {
    var menuBG = new FlxSprite(Paths.image('menuDesat'));
    menuBG.color = 0xFFea71fd;
    menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
    menuBG.updateHitbox();
    menuBG.screenCenter();
    menuBG.scrollFactor.set(0, 0);
    add(menuBG);

    var options = addPage(Options, new OptionsMenu());
    var preferences = addPage(Preferences, new PreferencesMenu());
    var controls = addPage(Controls, new ControlsMenu());
    var colors = addPage(Colors, new ColorsMenu());

    if (options.hasMultipleOptions())
    {
      options.onExit.add(exitToMainMenu);
      controls.onExit.add(switchPage.bind(Options));
      colors.onExit.add(switchPage.bind(Options));
      preferences.onExit.add(switchPage.bind(Options));
    }
    else
    {
      // No need to show Options page
      controls.onExit.add(exitToMainMenu);
      setPage(Controls);
    }

    // disable for intro transition
    currentPage.enabled = false;
    super.create();
  }

  function addPage<T:Page>(name:PageName, page:T)
  {
    page.onSwitch.add(switchPage);
    pages[name] = page;
    add(page);
    page.exists = currentName == name;
    return page;
  }

  function setPage(name:PageName)
  {
    if (pages.exists(currentName)) currentPage.exists = false;

    currentName = name;

    if (pages.exists(currentName)) currentPage.exists = true;
  }

  override function finishTransIn()
  {
    super.finishTransIn();

    currentPage.enabled = true;
  }

  // TODO: animate?
  inline function switchPage(name:PageName)
  {
    setPage(name);
  }

  // TODO: animate?
  function exitToMainMenu()
  {
    currentPage.enabled = false;
    FlxG.switchState(() -> new ui.mainmenu.MainMenuState());
  }
}

class Page extends FlxGroup
{
  public var onSwitch(default, null) = new FlxTypedSignal<PageName->Void>();
  public var onExit(default, null) = new FlxSignal();

  public var enabled(default, set) = true;
  public var canExit = true;

  var controls(get, never):Controls;

  inline function get_controls()
    return PlayerSettings.player1.controls;

  inline function switchPage(name:PageName)
  {
    onSwitch.dispatch(name);
  }

  inline function exit()
  {
    onExit.dispatch();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (enabled) updateEnabled(elapsed);
  }

  function updateEnabled(elapsed:Float)
  {
    if (canExit && controls.BACK)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));
      exit();
    }
  }

  function set_enabled(value:Bool)
  {
    return this.enabled = value;
  }

  function openPrompt(prompt:Prompt, onClose:Void->Void)
  {
    enabled = false;
    prompt.closeCallback = function() {
      enabled = true;
      if (onClose != null) onClose();
    }

    FlxG.state.openSubState(prompt);
  }

  override function destroy()
  {
    super.destroy();
    onSwitch.removeAll();
  }
}

class OptionsMenu extends Page
{
  var items:TextMenuList;

  public function new()
  {
    super();

    add(items = new TextMenuList());
    createItem('preferences', function() switchPage(Preferences));
    createItem("controls", function() switchPage(Controls));
    createItem('colors', function() switchPage(Colors));
    createItem("exit", exit);
  }

  function createItem(name:String, callback:Void->Void, fireInstantly = false)
  {
    var item = items.createItem(0, 100 + items.length * 100, name, Bold, callback);
    item.fireInstantly = fireInstantly;
    item.screenCenter(X);
    return item;
  }

  override function set_enabled(value:Bool)
  {
    items.enabled = value;
    return super.set_enabled(value);
  }

  /**
   * True if this page has multiple options, excluding the exit option.
   * If false, there's no reason to ever show this page.
   */
  public inline function hasMultipleOptions():Bool
    return items.length > 2;
}

enum PageName
{
  Options;
  Controls;
  Colors;
  Preferences;
}
