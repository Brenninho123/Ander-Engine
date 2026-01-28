package play.cutscenes.dialogue;

import flixel.addons.text.FlxTypeText;
import ui.Alphabet;

class BasicDialogueBox extends FlxSpriteGroup
{
  var box:FlxSprite;

  var curCharacter:String = '';

  var dialogue:Alphabet;

  public var dialogueList:Array<String> = [];

  // SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
  var swagDialogue:FlxTypeText;

  var dropText:FlxText;

  public var finishThing:Void->Void;

  var portraitLeft:FlxSprite;
  var portraitRight:FlxSprite;

  var handSelect:FlxSprite;
  var bgFade:FlxSprite;

  public function makePortraits() {}

  /**
    @return hasDialog
  **/
  public function makeDialogueBox():Bool
  {
    return false;
  }

  public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
  {
    super();

    bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
    bgFade.scrollFactor.set();
    bgFade.alpha = 0;
    add(bgFade);

    new FlxTimer().start(0.83, function(tmr:FlxTimer) {
      bgFade.alpha += (1 / 5) * 0.7;
      if (bgFade.alpha > 0.7) bgFade.alpha = 0.7;
    }, 5);

    makePortraits();

    box = new FlxSprite(-20, 45);

    var hasDialog = false;

    hasDialog = makeDialogueBox();

    this.dialogueList = dialogueList;

    if (!hasDialog) return;

    add(box);

    box.screenCenter(X);
    portraitLeft.screenCenter(X);

    dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
    dropText.font = Paths.font('pixel.otf');
    dropText.color = 0xFFDAF7F3;
    add(dropText);

    swagDialogue = new FlxTypeText(dropText.x - 2, dropText.y - 2, Std.int(dropText.fieldWidth), "", dropText.size);
    swagDialogue.font = dropText.font;
    swagDialogue.color = 0xFF949BA5;
    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
    add(swagDialogue);
  }

  var dialogueOpened:Bool = false;
  var dialogueStarted:Bool = false;
  var dialogueEnded:Bool = false;

  public var music:FlxSound;

  public function playMusic()
  {
    if (music != null) music.play();
  }

  override function update(elapsed:Float)
  {
    dropText.text = swagDialogue.text;

    if (box.animation.curAnim != null)
    {
      if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
      {
        box.animation.play('normal');
        dialogueOpened = true;
      }
    }

    if (dialogueOpened && !dialogueStarted)
    {
      startDialogue();
      dialogueStarted = true;
    }

    if (FlxG.keys.justPressed.ANY && dialogueEnded)
    {
      remove(dialogue);

      FlxG.sound.play(Paths.sound('clickText'), 0.8);

      if (dialogueList[1] == null && dialogueList[0] != null)
      {
        if (!isEnding)
        {
          isEnding = true;

          ending();

          new FlxTimer().start(0.2, function(tmr:FlxTimer) {
            box.alpha -= 1 / 5;
            bgFade.alpha -= 1 / 5 * 0.7;
            portraitLeft.visible = false;
            portraitRight.visible = false;
            swagDialogue.alpha -= 1 / 5;
            handSelect.alpha -= 1 / 5;
            dropText.alpha = swagDialogue.alpha;
          }, 5);

          new FlxTimer().start(1.2, function(tmr:FlxTimer) {
            finishThing();
            kill();
          });
        }
      }
      else
      {
        dialogueList.remove(dialogueList[0]);
        startDialogue();
      }
    }
    else if (FlxG.keys.justPressed.ANY && dialogueStarted) swagDialogue.skip();

    super.update(elapsed);
  }

  public function ending() {}

  var isEnding:Bool = false;

  function startDialogue():Void
  {
    cleanDialog();
    // var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
    // dialogue = theDialog;
    // add(theDialog);

    // swagDialogue.text = ;
    swagDialogue.resetText(dialogueList[0]);
    swagDialogue.start(0.04);
    swagDialogue.completeCallback = function() {
      trace("dialogue finish");
      if (handSelect != null) handSelect.visible = true;
      dialogueEnded = true;
    };
    if (handSelect != null) handSelect.visible = false;
    dialogueEnded = false;

    switch (curCharacter)
    {
      case 'dad':
        portraitRight.visible = false;
        if (!portraitLeft.visible)
        {
          portraitLeft.visible = true;
          portraitLeft.animation.play('enter');
        }
      case 'bf':
        portraitLeft.visible = false;
        if (!portraitRight.visible)
        {
          portraitRight.visible = true;
          portraitRight.animation.play('enter');
        }
    }
  }

  function cleanDialog():Void
  {
    var splitName:Array<String> = dialogueList[0].split(":");
    curCharacter = splitName[1];
    dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
  }
}
