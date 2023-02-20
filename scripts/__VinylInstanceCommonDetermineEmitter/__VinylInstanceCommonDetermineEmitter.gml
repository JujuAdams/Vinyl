/// @param forceEmitter

function __VinylInstanceCommonDetermineEmitter(_forceEmitter)
{
    var _effectChainName = __VinylPatternGetEffectChain(__sound);
    
    var _usedEmitter = undefined;
    if (_emitter != undefined)
    {
        //Playback on a normal emitter
        _usedEmitter = _emitter.__GetEmitter();
        
        //Add this instance to the emitter's array
        array_push(_emitter.__emitter.__instanceIDArray, __id);
    }
    else
    {
        if (_pan == undefined)
        {
            //Standard playback
            //Only use an emitter if the effect chain demands it
            var _usedEmitter = __VinylEffectChainGetEmitter(_effectChainName);
        }
        else
        {
            //Playback on a pan emitter
            __panEmitter = __poolPanEmitter.__Depool();
            __panEmitter.__Pan(_pan);
            __panEmitter.__Bus(_effectChainName);
            
            _usedEmitter = __panEmitter.__emitter;
        }
    }
    
    return _usedEmitter;
}