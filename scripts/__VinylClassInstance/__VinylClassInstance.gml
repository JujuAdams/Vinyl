function __VinylClassInstance() constructor
{
	__ResetState();
	
	static __ResetState = function()
	{
		__pooled = true;
        
		__id = undefined;
		
	    __sound     = undefined;
	    __loop      = undefined;
	    __inputGain = 0.0;
	    __inputFreq = 1.0;
		
        __outputChanged = false;
		__outputGain    = 0.0;
		__outputFreq    = 1.0;
        
	    __instance = undefined;
	}
	
	static __GainSet = function(_gain)
	{
		
	}
	
	static __GainGet = function()
	{
		
	}
	
	static __GainTargetSet = function(_targetGain, _rate, _stopAtSilence)
	{
		
	}
    
    static __Play = function(_sound, _loop, _gain, _freq)
    {
	    __sound     = _sound;
	    __loop      = _loop;
	    __inputGain = _gain;
	    __inputFreq = _freq;
		
        __AddToLabels();
        __RecalculateOutputValues();
		
		var _amplitude = __VinylGainToAmplitudeCoeff(__outputGain - VINYL_SYSTEM_HEADROOM);
	    __instance = audio_play_sound(__sound, 1, __loop, _amplitude, 0, __outputFreq);
		
		if (VINYL_DEBUG)
		{
			var _labelReadable = "";
	        var _asset = global.__vinylAssetDict[$ __sound] ?? global.__vinylAssetDict.fallback;
	        if (is_struct(_asset))
	        {
	            var _labelArray = _asset.__labelArray;
				var _size = array_length(_labelArray);
				if (_size > 1) _labelReadable += "[";
				
				var _i = 0;
				repeat(_size)
				{
					_labelReadable += _labelArray[_i].__name;
					if (_i < _size-1) _labelReadable += ", ";
					++_i;
				}
				
				if (_size > 1) _labelReadable += "]";
			}
			
			__VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), ", loop=", _loop? "true" : "false", ", gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch=", 100*_freq, "%, label=", _labelReadable, " (GMinst=", __instance, ", amplitude=", 100*_amplitude, "%)");
		}
		
		if (__outputGain > VINYL_SYSTEM_HEADROOM)
		{
			__VinylTrace("Warning! Gain value ", __outputGain, " exceeds VINYL_SYSTEM_HEADROOM (", VINYL_SYSTEM_HEADROOM, ")");
		}
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
		
		if (VINYL_DEBUG) __VinylTrace("Forcing instance ", __id, " to stop (GMinst=", __instance, ")");
		
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
		
		if (VINYL_DEBUG) __VinylTrace("Depooling an instance as ID ", __id);
	}
    
    static __Pool = function()
    {
		if (__pooled) return;
		__pooled = true;
        
		__Stop();
		
		if (VINYL_DEBUG) __VinylTrace("Pooling instance ", __id, " and resetting state");
		
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
			if (VINYL_DEBUG) __VinylTrace("Instance ", __id, " has stopped played, returning to pool");
            __Pool();
        }
        else if (__outputChanged)
        {
			__outputChanged = false;
			if (VINYL_DEBUG) __VinylTrace("Instance ", __id, " output values changed, updating GM audio instance");
            audio_sound_gain(__instance, __VinylGainToAmplitudeCoeff(__outputGain), VINYL_STEP_DURATION);
            audio_sound_pitch(__instance, __outputFreq);
        }
    }
}