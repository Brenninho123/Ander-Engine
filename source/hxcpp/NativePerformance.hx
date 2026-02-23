package hxcpp;

#if cpp
@:include("NativePerformance.cpp")
extern class NativePerformance
{
    @:native("getHighPrecisionTime")
    public static function getHighPrecisionTime():Float;
}
#end
