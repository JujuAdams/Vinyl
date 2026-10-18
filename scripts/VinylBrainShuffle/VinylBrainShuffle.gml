/// @param playableArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylBrainShuffle(_playableArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : VinylBrainParentConstructor(false) constructor
{
    _playableArray = VinylUtilEnsureArray(_playableArray);
    VinylAssertPlayable(_playableArray);
    
    __playableArray = _playableArray;
    __gain          = _gain;
    __gainRange     = _gainRange;
    __pitch         = _pitch;
    __pitchRange    = _pitchRange;
    __playIndex     = infinity;
    
    static PopPlayable = function()
    {
        var _playableCount = array_length(__playableArray);
        
        if (_playableCount == 1)
        {
            return __playableArray[0];
        }
        else if (_playableCount == 2)
        {
            //Special case for two sounds - randomly choose either of them
            return __playableArray[VinylUtilIRandom(1)];
        }
        else
        {
            if (__playIndex >= _playableCount) //If we've played through our bank of sounds, reshuffle
            {
                __playIndex = 0;
                var _last = __playableArray[_playableCount-1];
                array_delete(__playableArray, _playableCount-1, 1); //Make sure we don't reshuffle in the last played sound...
                VinylUtilArrayShuffle(__playableArray);
                array_insert(__playableArray, _playableCount div 2, _last); //...and stick it somewhere in the middle instead
            }
            
            return __playableArray[__playIndex++];
        }
    }
    
    static PopPlayable = function()
    {
        return VinylUtilRandomRange(__gain - __gainRange, __gain + __gainRange);
    }
    
    static PopPitch = function()
    {
        return VinylUtilRandomRange(__pitch - __pitchRange, __pitch + __pitchRange);
    }
    
    
    
    
    
    static ImplPlayOmni = function(_loop, _gain, _pitch)
    {
        VinylPlayOmni(PopPlayable(), _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain, _pitch)
    {
        VinylPlayAt(PopPlayable(), _x, _y, _z, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain, _pitch)
    {
        VinylPlayOn(PopPlayable(), _emitter, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
}