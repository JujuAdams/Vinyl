/// @param playableArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylBrainRandom(_playableArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : VinylBrainCommonConstructor(false) constructor
{
    _playableArray = VinylEnsureArray(_playableArray);
    VinylAssertPlayable(_playableArray);
    
    __playableArray = _playableArray;
    __gain          = _gain;
    __gainRange     = _gainRange;
    __pitch         = _pitch;
    __pitchRange    = _pitchRange;
    __soundCount    = array_length(__playableArray);
    
    static PopPlayable = function()
    {
        return __playableArray[VinylIRandom(__soundCount-1)];
    }
    
    static PopGain = function()
    {
        return VinylRandomRange(__gain - __gainRange, __gain + __gainRange);
    }
    
    static PopPitch = function()
    {
        return VinylRandomRange(__pitch - __pitchRange, __pitch + __pitchRange);
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