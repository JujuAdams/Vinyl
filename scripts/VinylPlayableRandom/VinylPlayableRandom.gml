/// Allows playback from an array of playables. When popped, this logic will choose a random
/// playable from its array. This means the same sound can play twice in a row (or, indeed, three
/// times or more). The random choice of sound uses Vinyl's own internal random number system and
/// this logic will not impact GameMaker's native random functions.
/// 
/// Example:
///     /// Create Event
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

function VinylPlayableRandom(_playableArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : __VinylLogicParentConstructor(false) constructor
{
    _playableArray = VinylUtilEnsureArray(_playableArray);
    VinylAssertPlayable(_playableArray);
    
    playableArray = _playableArray;
    gain          = _gain;
    gainRange     = _gainRange;
    pitch         = _pitch;
    pitchRange    = _pitchRange;
    
    static PopPlayable = function()
    {
        var _length = array_length(playableArray);
        return (_length <= 0)? undefined : playableArray[VinylUtilIRandom(_length-1)];
    }
    
    static PopGain = function()
    {
        return VinylUtilRandomRange(gain - gainRange, gain + gainRange);
    }
    
    static PopPitch = function()
    {
        return VinylUtilRandomRange(pitch - pitchRange, pitch + pitchRange);
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