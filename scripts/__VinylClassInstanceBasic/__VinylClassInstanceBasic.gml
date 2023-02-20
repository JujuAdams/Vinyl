function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    static __patternType = "basic";
    
    static toString = function()
    {
        if (__sound == undefined)
        {
            return "<basic inst " + string(__id) + ">";
        }
        else
        {
            return "<basic inst " + string(__id) + " " + string(audio_get_name(__sound)) + ">";
        }
    }
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        static _poolPanEmitter = __globalData.__poolPanEmitter;
        
        //Set the state
        __patternName = _sound;
        __sound       = _sound;
        __loop        = _loop ?? __GetLoopFromLabel();
        __gainInput   = _gain;
        __pitchInput  = _pitch;
        
        __gainTarget  = __gainInput;
        __pitchTarget = __pitchInput;
        
        __randomPitchParam = __VinylRandom(1);
        
        __ApplyLabel(true);
        
        //Determine which emitter to use given the input arguments
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
                __panEmitter = _poolPanEmitter.__Depool();
                __panEmitter.__Pan(_pan);
                __panEmitter.__Bus(_effectChainName);
                
                _usedEmitter = __panEmitter.__emitter;
            }
        }
        
        __gmInstance = new __VinylClassInstanceGameMaker(); //TODO - Pool GameMaker instance wrappers
        __gmInstance.__Play(_usedEmitter, __sound, __loop, __gainOutput, __pitchOutput);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " hosting ", __gmInstance);
    }
}