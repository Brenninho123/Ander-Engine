package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class Alphabet extends FlxSpriteGroup
{
    public var delay:Float = 0.05;
    public var paused:Bool = false;
    public var text:String = "";
    public var targetY:Float = 0;
    public var isMenuItem:Bool = false;
    public var bold:Bool = false;
    public var typed:Bool = false;
    public var personTalking:String = 'gf';
    
    // Controle de espaçamento
    public var letterSpacing:Float = 3;
    public var spaceWidth:Float = 40;
    public var typedSpaceWidth:Float = 20;
    public var rowHeight:Float = 110;
    public var boldOffset:Float = 0;
    
    // Controle visual
    public var autoSize:Bool = true;
    public var maxWidth:Float = FlxG.width;
    public var centerText:Bool = false;
    
    // Controle de som
    public var soundChance:Float = 0.4; // 40% de chance
    public var soundVolume:Float = 0.6;
    
    // Privado
    var _finalText:String = "";
    var _curText:String = "";
    var _splitWords:Array<String> = [];
    var _lastSprite:AlphaCharacter;
    var _xPos:Float = 0;
    var _row:Int = 0;
    var _yMulti:Float = 1;
    var _xPosResetted:Bool = false;
    var _lastWasSpace:Bool = false;
    var _typingTimer:FlxTimer;
    var _currentChar:Int = 0;
    
    // Cache de caracteres válidos para performance
    static final _validChars:String = AlphaCharacter.alphabet + AlphaCharacter.numbers + AlphaCharacter.symbols;
    
    public function new(x:Float = 0, y:Float = 0, text:String = "", ?bold:Bool = false, typed:Bool = false)
    {
        super(x, y);
        
        this.text = text;
        _finalText = text;
        this.bold = bold;
        this.typed = typed;
        
        if (text != "")
        {
            if (typed)
                startTypedText();
            else
                instantAddText();
        }
    }
    
    /**
     * Adiciona texto instantaneamente
     */
    function instantAddText():Void
    {
        _splitWords = _finalText.split("");
        _xPos = 0;
        _row = 0;
        
        for (char in _splitWords)
        {
            processCharacter(char, false);
        }
        
        if (centerText && autoSize)
            center();
    }
    
    /**
     * Processa um caractere individual
     */
    function processCharacter(char:String, typedMode:Bool = false):Void
    {
        if (char == "\n")
        {
            _yMulti++;
            _xPosResetted = true;
            _xPos = 0;
            _row++;
            return;
        }
        
        if (char == " " || char == "-")
        {
            _lastWasSpace = true;
            if (!typedMode)
                _xPos += spaceWidth;
            return;
        }
        
        if (isValidCharacter(char))
        {
            updatePosition(typedMode);
            
            var letter = createLetterSprite(char, typedMode);
            add(letter);
            
            _lastSprite = letter;
            
            if (typedMode && FlxG.random.float() < soundChance)
                playTalkSound();
        }
    }
    
    /**
     * Atualiza a posição para o próximo caractere
     */
    inline function updatePosition(typedMode:Bool):Void
    {
        if (_lastSprite != null && !_xPosResetted)
        {
            _lastSprite.updateHitbox();
            _xPos += _lastSprite.width + (bold ? boldOffset : letterSpacing);
        }
        else
        {
            _xPosResetted = false;
        }
        
        if (_lastWasSpace)
        {
            _xPos += typedMode ? typedSpaceWidth : spaceWidth;
            _lastWasSpace = false;
        }
    }
    
    /**
     * Cria um sprite de letra
     */
    function createLetterSprite(char:String, typedMode:Bool):AlphaCharacter
    {
        var yPos = typedMode ? 55 * _yMulti : 0;
        var letter = new AlphaCharacter(_xPos, yPos);
        letter.row = _row;
        
        var charLower = char.toLowerCase();
        var isNumber = AlphaCharacter.numbers.contains(char);
        var isSymbol = AlphaCharacter.symbols.contains(char);
        
        if (bold)
        {
            letter.createBold(char);
        }
        else if (isNumber)
        {
            letter.createNumber(char);
        }
        else if (isSymbol)
        {
            letter.createSymbol(char);
        }
        else
        {
            letter.createLetter(char);
        }
        
        // Ajuste para texto datilografado
        if (typedMode && !bold && !isNumber && !isSymbol)
            letter.x += 90;
        
        return letter;
    }
    
    /**
     * Inicia texto datilografado
     */
    public function startTypedText():Void
    {
        if (_typingTimer != null)
        {
            _typingTimer.cancel();
            _typingTimer = null;
        }
        
        _splitWords = _finalText.split("");
        _currentChar = 0;
        _xPos = 0;
        _row = 0;
        _yMulti = 1;
        
        clear();
        
        _typingTimer = new FlxTimer().start(delay, typedCharHandler, 0);
    }
    
    /**
     * Handler para cada caractere digitado
     */
    function typedCharHandler(tmr:FlxTimer):Void
    {
        if (paused || _currentChar >= _splitWords.length)
        {
            if (_currentChar >= _splitWords.length && centerText && autoSize)
                center();
            return;
        }
        
        processCharacter(_splitWords[_currentChar], true);
        
        _currentChar++;
        tmr.time = FlxG.random.float(delay * 0.8, delay * 1.2);
    }
    
    /**
     * Verifica se caractere é válido
     */
    inline function isValidCharacter(char:String):Bool
    {
        return _validChars.indexOf(char.toLowerCase()) != -1;
    }
    
    /**
     * Toca som de fala
     */
    function playTalkSound():Void
    {
        var soundPath = '${personTalking}_${FlxG.random.int(1, 4)}';
        FlxG.sound.play(Paths.soundRandom(personTalking, 1, 4), soundVolume);
    }
    
    /**
     * Reinicia a digitação
     */
    public function resetTyping():Void
    {
        if (!typed) return;
        
        if (_typingTimer != null)
        {
            _typingTimer.cancel();
            _typingTimer = null;
        }
        
        clear();
        startTypedText();
    }
    
    /**
     * Centraliza o texto
     */
    public function center():Void
    {
        if (members.length == 0) return;
        
        var minX = members[0].x;
        var maxX = members[0].x + members[0].width;
        
        for (member in members)
        {
            if (member.x < minX) minX = member.x;
            if (member.x + member.width > maxX) maxX = member.x + member.width;
        }
        
        var textWidth = maxX - minX;
        var offsetX = (maxWidth - textWidth) / 2 - minX;
        
        for (member in members)
        {
            member.x += offsetX;
        }
    }
    
    /**
     * Pula a animação de digitação
     */
    public function skipTyping():Void
    {
        if (!typed || _typingTimer == null) return;
        
        _typingTimer.cancel();
        _typingTimer = null;
        
        while (_currentChar < _splitWords.length)
        {
            processCharacter(_splitWords[_currentChar], true);
            _currentChar++;
        }
        
        if (centerText && autoSize)
            center();
    }
    
    override function update(elapsed:Float)
    {
        if (isMenuItem)
        {
            // Animação suave para itens de menu
            var lerpVal = CoolUtil.coolLerp(0.16);
            var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
            
            y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), lerpVal);
            x = FlxMath.lerp(x, (targetY * 20) + 90, lerpVal);
        }
        
        super.update(elapsed);
    }
    
    override function destroy()
    {
        if (_typingTimer != null)
        {
            _typingTimer.cancel();
            _typingTimer = null;
        }
        super.destroy();
    }
}

/**
 * Sprite individual para cada caractere
 */
class AlphaCharacter extends FlxSprite
{
    public static final alphabet:String = "abcdefghijklmnopqrstuvwxyz";
    public static final numbers:String = "1234567890";
    public static final symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";
    
    public var row:Int = 0;
    public var charType:CharType = LETTER;
    
    // Cache de animações para evitar recriação
    static var _animCache:Map<String, Bool> = new Map();
    
    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        var tex = Paths.getSparrowAtlas('alphabet');
        frames = tex;
        antialiasing = true;
    }
    
    public function createBold(letter:String):Void
    {
        charType = BOLD;
        var animName = letter.toUpperCase() + " bold";
        playCachedAnim(animName);
        y = 0;
    }
    
    public function createLetter(letter:String):Void
    {
        charType = LETTER;
        var letterCase = (letter.toLowerCase() == letter) ? "lowercase" : "capital";
        var animName = letter + " " + letterCase;
        playCachedAnim(animName);
        
        y = (110 - height);
        y += row * 60;
    }
    
    public function createNumber(letter:String):Void
    {
        charType = NUMBER;
        playCachedAnim(letter);
        y = (110 - height) + row * 60;
    }
    
    public function createSymbol(letter:String):Void
    {
        charType = SYMBOL;
        
        switch (letter)
        {
            case '.':
                playCachedAnim('period');
                y += 50;
            case "'":
                playCachedAnim('apostraphie');
            case "?":
                playCachedAnim('question mark');
            case "!":
                playCachedAnim('exclamation point');
            default:
                playCachedAnim(letter);
        }
        
        y += row * 60;
    }
    
    /**
     * Toca animação com cache
     */
    inline function playCachedAnim(animName:String):Void
    {
        if (!_animCache.exists(animName))
        {
            animation.addByPrefix(animName, animName, 24, false);
            _animCache.set(animName, true);
        }
        
        animation.play(animName);
        updateHitbox();
    }
}

/**
 * Tipos de caractere para referência
 */
enum CharType
{
    LETTER;
    NUMBER;
    SYMBOL;
    BOLD;
}