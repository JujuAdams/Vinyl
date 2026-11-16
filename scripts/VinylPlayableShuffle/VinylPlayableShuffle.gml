/// Allows playback from an array of playables. When popped, this logic will choose a playable from
/// its array, guaranteeing that a sound cannot be heard twice in a row. The random choice of sound
/// uses Vinyl's own internal random number system and this logic will not impact GameMaker's
/// native random functions.
/// 
/// Example:
///     /// Create Event
///     footstepLogic = new VinylLogicShuffle([sndFootstep1, sndFootstep2, sndFootstep3], 1, 0, 1, 0.2);
///     footstepTimer = 0;
///     
///     ///Step Event
///     --footstepTimer;
///     if (moved && (footstepTimer <= 0))
///     {
///         footstepTimer = 24;
///         VinylPlay(footstepLogic);
///     }
/// 
/// @param playableArray
/// @param [gain=1]
/// @param [gainRange=0]
/// @param [pitch=1]
/// @param [pitchRange=0]

function VinylPlayableShuffle(_playableArray, _gain = 1, _gainRange = 0, _pitch = 1, _pitchRange = 0) : __VinylLogicParentConstructor(false) constructor
{
    _playableArray = VinylUtilEnsureArray(_playableArray);
    VinylAssertPlayable(_playableArray);
    
    __originalPlayable = variable_clone(_playableArray, 0);
    __playableArray    = variable_clone(_playableArray, 0);
    __playIndex        = infinity;
    
    gain       = _gain;
    gainRange  = _gainRange;
    pitch      = _pitch;
    pitchRange = _pitchRange;
    
    static SetPlayableArray = function(_playableArray)
    {
        __originalPlayable = variable_clone(_playableArray, 0);
        __playableArray    = variable_clone(_playableArray, 0);
        __playIndex        = infinity;
        
        return self;
    }
    
    static GetPlayableArray = function()
    {
        return variable_clone(__originalPlayable, 0);
    }
    
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
    
    static PopGain = function()
    {
        return VinylUtilRandomRange(max(0, gain - gainRange), gain + gainRange);
    }
    
    static PopPitch = function()
    {
        return VinylUtilRandomRange(max(0.01, pitch - pitchRange), pitch + pitchRange);
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