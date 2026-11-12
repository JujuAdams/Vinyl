/// Allows playback from an array of playables. When popped, this logic will choose a random
/// playable from its array. This means the same sound can play twice in a row (or, indeed, three
/// times or more). The random choice of sound uses Vinyl's own internal random number system and
/// this logic will not impact GameMaker's native random functions.
/// 
/// Example:
///     ///Create Event
///     coinLogic = new VinylLogicRandom([sndCoin1, sndCoin2, sndCoin3]);
///     
///     ///Collision with objCoin
///     score += 100;
///     VinylPlay(coinLogic);
/// 
/// @param playableArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylLogicRandom(_playableArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : VinylLogicParentConstructor(false) constructor
{
    _playableArray = VinylUtilEnsureArray(_playableArray);
    VinylAssertPlayable(_playableArray);
    
    __playableArray = _playableArray;
    __gain          = _gain;
    __gainRange     = _gainRange;
    __pitch         = _pitch;
    __pitchRange    = _pitchRange;
    __soundCount    = array_length(__playableArray);
    
    static PopPlayable = function()
    {
        return __playableArray[VinylUtilIRandom(__soundCount-1)];
    }
    
    static PopGain = function()
    {
        return VinylUtilRandomRange(__gain - __gainRange, __gain + __gainRange);
    }
    
    static PopPitch = function()
    {
        return VinylUtilRandomRange(__pitch - __pitchRange, __pitch + __pitchRange);
    }
    
    
    
    
    
    static ImplPlay = function(_loop, _gain, _pitch)
    {
        return VinylPlay(PopPlayable(), _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain, _pitch)
    {
        return VinylPlayAt(PopPlayable(), _x, _y, _z, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain, _pitch)
    {
        return VinylPlayOn(PopPlayable(), _emitter, _loop, _gain*PopGain(), _pitch*PopPitch());
    }
}