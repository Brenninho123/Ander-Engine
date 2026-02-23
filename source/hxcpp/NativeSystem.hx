package hxcpp;

#if cpp
@:include("NativeSystem.cpp")
extern class NativeSystem
{
    @:native("openFolder")
    public static function openFolder(path:String):Void;

    @:native("showMessageBox")
    public static function showMessageBox(title:String, message:String):Void;
}
#end
