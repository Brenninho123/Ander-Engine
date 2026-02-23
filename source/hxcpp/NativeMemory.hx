package hxcpp;

#if cpp
@:include("NativeMemory.cpp")
extern class NativeMemory
{
    @:native("getMemoryUsage")
    public static function getMemoryUsage():Float;
}
#end
