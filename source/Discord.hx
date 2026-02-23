package;

import Sys.sleep;
import sys.thread.Thread;
import sys.thread.Mutex;

#if discord_rpc
import discord_rpc.DiscordRpc;
#end

class DiscordClient
{
    #if discord_rpc

    private static var _initialized:Bool = false;
    private static var _running:Bool = false;
    private static var _thread:Thread;
    private static var _mutex:Mutex = new Mutex();

    private static final CLIENT_ID:String = "814588678700924999";

    // ==============================
    // INITIALIZE
    // ==============================

    public static function initialize():Void
    {
        if (_initialized) return;

        _running = true;
        _thread = Thread.create(rpcLoop);
        _initialized = true;

        trace("Discord RPC initialized.");
    }

    // ==============================
    // MAIN RPC LOOP (SAFE)
    // ==============================

    private static function rpcLoop():Void
    {
        try
        {
            DiscordRpc.start({
                clientID: CLIENT_ID,
                onReady: onReady,
                onError: onError,
                onDisconnected: onDisconnected
            });

            trace("Discord RPC started.");

            while (_running)
            {
                _mutex.acquire();
                DiscordRpc.process();
                _mutex.release();

                sleep(1);
            }
        }
        catch (e:Dynamic)
        {
            trace("Discord RPC Fatal Error: " + e);
        }

        DiscordRpc.shutdown();
        trace("Discord RPC stopped.");
    }

    // ==============================
    // SHUTDOWN
    // ==============================

    public static function shutdown():Void
    {
        if (!_initialized) return;

        _running = false;
        sleep(0.5);

        _initialized = false;
        trace("Discord RPC shutdown complete.");
    }

    // ==============================
    // READY CALLBACK
    // ==============================

    private static function onReady():Void
    {
        trace("Discord RPC ready.");

        changePresence(
            "In the Menus",
            null,
            null,
            false,
            0
        );
    }

    private static function onError(code:Int, message:String):Void
    {
        trace('Discord RPC Error $code : $message');
    }

    private static function onDisconnected(code:Int, message:String):Void
    {
        trace('Discord RPC Disconnected $code : $message');
    }

    // ==============================
    // CHANGE PRESENCE
    // ==============================

    public static function changePresence(
        details:String,
        state:Null<String>,
        ?smallImageKey:String,
        ?useTimer:Bool = false,
        ?durationSeconds:Float = 0
    ):Void
    {
        if (!_initialized) return;

        var startTimestamp:Float = 0;
        var endTimestamp:Float = 0;

        if (useTimer)
        {
            startTimestamp = Date.now().getTime();
            if (durationSeconds > 0)
                endTimestamp = startTimestamp + (durationSeconds * 1000);
        }

        _mutex.acquire();

        DiscordRpc.presence({
            details: details,
            state: state,
            largeImageKey: "icon",
            largeImageText: "Friday Night Funkin'",
            smallImageKey: smallImageKey,
            startTimestamp: Std.int(startTimestamp / 1000),
            endTimestamp: Std.int(endTimestamp / 1000)
        });

        _mutex.release();
    }

    #end
}