package global;

class TitleStateGlobal
{
  public static var introTextPath:String = Paths.txt('introText');

  /**
    A list of the intro text shit

    each entry is a beat

    # THINGS THAT CAN GO IN THE ARRAYS
    @param String will add a single text
    @param "" nothing

    @param "%ngSpr=" will change `ngSpr` to visisble (1) or invisible (anything else)
    @param "%wacky=" will add one of the curWacky's
    @param "%skipIntro" ...
    @param "%clear" Clears all the texts
  **/
  public static var introTextList:Array<Array<String>> = [
    ['macohi', 'djotta flow'],
    ['funniboi', 'flying.haxe'],
    ['present'],
    ['%clear'],
    ['in no way'],
    ['associated with'],
    ['newgrounds', '%ngSpr=1'],
    ['%clear', '%ngSpr=0'],
    ['%wacky=0'],
    [''],
    ['%wacky=1'],
    ['%clear'],
    ['Friday'],
    ['Night'],
    ['Funkin'],
    ['%skipIntro'],
  ];
}
