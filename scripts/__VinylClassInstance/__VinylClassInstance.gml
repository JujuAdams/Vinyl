function __VinylClassInstance() constructor
{
    __instance   = undefined;
    __sound      = undefined;
    __loops      = undefined;
    __inputGain  = 1.0;
    __inputPitch = 1.0;
    
    static __Play = function(_sound, _loops, _gain, _pitch)
    {
        var _data = global.__vinylData[$ "assets"];
        if (is_struct(_data)) _data = _data[$ audio_get_name(_sound)] ?? _data[$ "default"];
        
        if (is_struct(_data))
        {
            _gain  *= _data[$ "gain" ] ?? 1;
            _pitch *= _data[$ "pitch"] ?? 1;
        }
    }
    
    static Stop = function()
    {
        
    }
    
    static __ReturnToPool = function()
    {
        
    }
}