package ui.mainmenu;

import flixel.effects.FlxFlicker;
import ui.AtlasMenuList;
import ui.MenuList;
import ui.options.OptionsState;
import ui.options.PreferencesMenu;
import ui.Prompt;

class MainMenuState extends MusicBeatState
{
  var menuItems:MainMenuList;

  var magenta:FlxSprite;
  var camFollow:FlxObject;

  var spacing = 0;
  var top(get, never):Float;

  inline function get_top():Float
    return (FlxG.height - (spacing * (menuItems.length - 1))) / 2;

  override function create()
  {
    #if linc_discord_rpc
    Discord.changePresence("In the Menus", null);
    #end

    transIn = FlxTransitionableState.defaultTransIn;
    transOut = FlxTransitionableState.defaultTransOut;

    if (!FlxG.sound.music.playing) FlxG.sound.playMusic(Paths.music('freakyMenu'));

    persistentUpdate = persistentDraw = true;

    var bg:FlxSprite = new FlxSprite(Paths.image('menuBG'));
    bg.scrollFactor.x = 0;
    bg.scrollFactor.y = 0.17;
    bg.setGraphicSize(Std.int(bg.width * 1.2));
    bg.updateHitbox();
    bg.screenCenter();
    bg.antialiasing = true;
    add(bg);

    camFollow = new FlxObject(0, 0, 1, 1);
    add(camFollow);

    magenta = new FlxSprite(Paths.image('menuDesat'));
    magenta.scrollFactor.x = bg.scrollFactor.x;
    magenta.scrollFactor.y = bg.scrollFactor.y;
    magenta.setGraphicSize(Std.int(bg.width));
    magenta.updateHitbox();
    magenta.x = bg.x;
    magenta.y = bg.y;
    magenta.visible = false;
    magenta.antialiasing = true;
    magenta.color = 0xFFfd719b;
    if (PreferencesMenu.preferences.get('flashing-menu')) add(magenta);

    menuItems = new MainMenuList();
    add(menuItems);
    menuItems.onChange.add(onMenuItemChange);
    menuItems.onAcceptPress.add(function(_) {
      FlxFlicker.flicker(magenta, 1.1, 0.15, false, true);
    });

    menuItems.enabled = false; // disable for intro
    menuItems.createItem('story mode', () -> startExitState(new ui.story.StoryMenuState()));
    menuItems.createItem('freeplay', () -> startExitState(new ui.freeplay.FreeplayState()));
    #if CAN_OPEN_LINKS
    var hasPopupBlocker = #if web true #else false #end;
    menuItems.createItem('support', selectSupport, hasPopupBlocker);
    #end
    menuItems.createItem('options', () -> startExitState(new ui.options.OptionsState()));

    // center vertically

    spacing = 180;
    for (i in 0...menuItems.length)
    {
      var menuItem = menuItems.members[i];

      menuItem.scale.set(.9, .9);
      if (menuItem.name == 'support') menuItem.scale.set(.8, .8);
      menuItem.updateHitbox();

      menuItem.x = FlxG.width / 2;
      menuItem.y = top + spacing * i;

      menuItem.idle();
    }

    menuItems.selectItem(0);

    FlxG.cameras.reset();
    FlxG.camera.follow(camFollow, null, 0.06);

    var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + lime.app.Application.current.meta.get('version'), 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(versionShit);

    super.create();
  }

  override function finishTransIn()
  {
    super.finishTransIn();
    menuItems.enabled = true;
  }

  function onMenuItemChange(selected:MenuItem)
  {
    camFollow.setPosition(selected.getGraphicMidpoint().x, selected.getGraphicMidpoint().y);
  }

  #if CAN_OPEN_LINKS
  function selectSupport()
  {
    final link:String = 'https://ko-fi.com/sphis/tip';

    #if linux
    Sys.command('/usr/bin/xdg-open', [link, "&"]);
    #else
    FlxG.openURL(link);
    #end
  }
  #end

  public function openPrompt(prompt:Prompt, onClose:Void->Void)
  {
    menuItems.enabled = false;
    prompt.closeCallback = function() {
      menuItems.enabled = true;
      if (onClose != null) onClose();
    }

    openSubState(prompt);
  }

  function startExitState(state:MusicBeatState)
  {
    menuItems.enabled = false; // disable for exit
    var duration = 0.4;
    menuItems.forEach(function(item) {
      if (menuItems.selectedIndex != item.ID) FlxTween.tween(item, {alpha: 0}, duration, {ease: FlxEase.quadOut});
      else
        item.visible = false;
    });

    new FlxTimer().start(duration, function(_) FlxG.switchState(() -> state));
  }

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music.volume < 0.8)
    {
      FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
    }

    if (_exiting) menuItems.enabled = false;

    if (controls.BACK && menuItems.enabled && !menuItems.busy)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxG.switchState(() -> new ui.title.TitleState());
    }

    super.update(elapsed);
  }
}

class MainMenuList extends MenuTypedList<MainMenuItem>
{
  public function new()
  {
    super(Vertical);
  }

  public function createItem(x = 0.0, y = 0.0, name:String, callback, fireInstantly = false)
  {
    var item = new MainMenuItem(x, y, name, Paths.getSparrowAtlas('main_menu/$name'), callback);
    item.fireInstantly = fireInstantly;
    item.ID = length;

    return addItem(name, item);
  }
}

class MainMenuItem extends AtlasMenuItem
{
  public function new(x = 0.0, y = 0.0, name, atlas, callback)
  {
    super(x, y, name, atlas, callback);
    scrollFactor.set();
  }

  override function setData(name:String, ?callback:Void->Void)
  {
    this.name = name;

    if (callback != null) this.callback = callback;

    frames = atlas;
    animation.addByPrefix('idle', '$name basic', 12);
    animation.addByPrefix('selected', '$name white', 24);
  }

  override function changeAnim(anim:String)
  {
    super.changeAnim(anim);
    centerOrigin();
    offset.copyFrom(origin);
  }
}
