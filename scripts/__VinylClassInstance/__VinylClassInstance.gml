function __VinylClassInstance() constructor
{
	__ResetState();
	
	static __ResetState = function()
	{
		__pooled = true;
        
		__id = undefined;
		
	    __sound     = undefined;
	    __loops     = undefined;
	    __inputGain = 0.0;
	    __inputFreq = 1.0;
		
        __outputChanged = false;
		__outputGain    = 0.0;
		__outputFreq    = 1.0;
        
	    __instance = undefined;
	}
    
    static __Play = function(_sound, _loops, _gain, _freq)
    {
	    __sound     = _sound;
	    __loops     = _loops;
	    __inputGain = _gain;
	    __inputFreq = _freq;
		
        __AddToLabels();
        __RecalculateOutputValues();
        
	    __instance = audio_play_sound(__sound, 1, __loops, __VinylGainToAmplitudeCoeff(__outputGain - VINYL_HEADROOM), 0, __outputFreq);
    }
    
    static __AddToLabels = function()
    {
        //Playing instances are removed from labels inside the label's __Tick() method
        //  N.B. This has no protection for duplicate entries!
        
        var _asset = global.__vinylAssetDict[$ __sound] ?? global.__vinylAssetDict.fallback;
        if (is_struct(_asset))
        {
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                array_push(_labelArray[_i].__audioArray, __id);
                ++_i;
            }
        }
    }
    
    static __RecalculateOutputValues = function()
    {
        var _prevGain = __outputGain;
        var _prevFreq = __outputFreq;
        
		__outputGain = __inputGain;
		__outputFreq = __inputFreq;
        
        var _asset = global.__vinylAssetDict[$ __sound] ?? global.__vinylAssetDict.fallback;
        if (is_struct(_asset))
        {
            __outputGain += _asset.__gain;
            __outputFreq *= _asset.__freq;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                __outputGain += _label.__outputGain;
                __outputFreq *= _label.__outputFreq;
                ++_i;
            }
        }
        
        if (!__outputChanged && ((__outputGain != _prevGain) || (__outputFreq != _prevFreq)))
        {
            __outputChanged = true;
        }
    }
    
    static __Stop = function()
    {
		if (__instance == undefined) return;
		
        audio_stop_sound(__instance);
		__instance = undefined;
		
		__Pool();
    }
    
	static __Depool = function(_id)
	{
		if (!__pooled) return;
		__pooled = false;
        
		__id = _id;
		global.__vinylIdToInstanceDict[? _id] = self;
		array_push(global.__vinylPlaying, self);
	}
    
    static __Pool = function()
    {
		if (__pooled) return;
		__pooled = true;
        
		__Stop();
		
		ds_map_delete(global.__vinylIdToInstanceDict, __id);
        
        //Move this instance to the "return" array
        //This prevents an instance being pooled and depooled in the same step
        //which would lead to problems with labels tracking what they're playing
		array_push(global.__vinylPoolReturn, self);
		
		__ResetState();
    }
    
    static __Tick = function()
    {
        if (!audio_is_playing(__instance))
        {
            __Pool();
        }
        else if (__outputChanged)
        {
            audio_sound_gain(__instance, __VinylGainToAmplitudeCoeff(__outputGain), VINYL_STEP_DURATION);
            audio_sound_pitch(__instance, __outputFreq);
        }
    }
}