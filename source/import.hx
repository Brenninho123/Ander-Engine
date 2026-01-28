package;

#if !macro
#if linc_discord_rpc
import backend.api.discord.Discord;
#end
import backend.api.gamejolt.GameJolt;
import backend.api.gamejolt.GameJolt.GameJoltAPI;
#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end
import ui.Alphabet;
import ui.loading.LoadingState;
import play.PlayState;
import backend.Main;
import backend.Paths;
import backend.Highscore;
import backend.controls.Controls;
import util.CoolUtil;
import ui.MusicBeatState;
import ui.MusicBeatSubstate;
import ui.FunkinCamera;
import openfl.utils.Assets;
import backend.PlayerSettings;
import backend.audio.Conductor;
import haxe.ds.Option;
import animate.*;
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxMatrix;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSort;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.group.FlxContainer;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;

// Add some extra functions to classes.
using Lambda;
using StringTools;
using thx.Arrays;
using flixel.util.FlxStringUtil;
using flixel.util.FlxSpriteUtil;
using flixel.util.FlxArrayUtil;
#end
