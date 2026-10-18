/// @param soundArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylBrainRandom(_soundArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : __VinylClassBrainInterface() constructor
{
    __soundArray = _soundArray;
    __gain       = _gain;
    __gainRange  = _gainRange;
    __pitch      = _pitch;
    __pitchRange = _pitchRange;
    __soundCount = array_length(__soundArray);
    
    static PopSound = function()
    {
        return __soundArray[__VinylIRandom(__soundCount-1)];
    }
    
    static PopGain = function()
    {
        return __VinylRandomRange(__gain - __gainRange, __gain + __gainRange);
    }
    
    static PopPitch = function()
    {
        return __VinylRandomRange(__pitch - __pitchRange, __pitch + __pitchRange);
    }
    
    static __ImplPlayOmni = function(_loop, _gain, _pitch)
    {
        VinylPlayOmni(PopSound(), _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static __ImplPlayAt = function(_x, _y, _z, _loop, _gain, _pitch)
    {
        VinylPlayAt(PopSound(), _x, _y, _z, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static __ImplPlayOn = function(_emitter, _loop, _gain, _pitch)
    {
        VinylPlayOn(PopSound(), _emitter, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
}