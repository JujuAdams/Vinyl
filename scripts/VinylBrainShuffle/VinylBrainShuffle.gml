/// @param soundArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylBrainShuffle(_soundArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : __VinylClassBrainInterface() constructor
{
    __soundArray = _soundArray;
    __gain       = _gain;
    __gainRange  = _gainRange;
    __pitch      = _pitch;
    __pitchRange = _pitchRange;
    __soundCount = array_length(__soundArray);
    __playIndex  = infinity;
    
    static PopSound = function()
    {
        if (__soundCount == 1)
        {
            return __soundArray[0];
        }
        else if (__soundCount == 2)
        {
            //Special case for two sounds - randomly choose either of them
            return __soundArray[__VinylIRandom(1)];
        }
        else
        {
            if (__playIndex >= __soundCount) //If we've played through our bank of sounds, reshuffle
            {
                __playIndex = 0;
                var _last = __soundArray[__soundCount-1];
                array_delete(__soundArray, __soundCount-1, 1); //Make sure we don't reshuffle in the last played sound...
                __VinylArrayShuffle(__soundArray);
                array_insert(__soundArray, __soundCount div 2, _last); //...and stick it somewhere in the middle instead
            }
            
            return __soundArray[__playIndex++];
        }
    }
    
    static PopSound = function()
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