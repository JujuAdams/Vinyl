function __VinylClassInstance() constructor
{
	__ResetState();
	
	static __ResetState = function()
	{
		__pooled = true;
        
		__id = undefined;
		
	    __sound      = undefined;
	    __loop       = undefined;
	    __inputGain  = 0.0;
	    __inputPitch = 1.0;
		
		__gainTarget    = 0.0;
		__gainRate      = VINYL_DEFAULT_GAIN_RATE;
		__stopOnSilence = true;
		
		__pitchTarget  = 1.0;
		__pitchRate    = VINYL_DEFAULT_PITCH_RATE;
		__stopOnTarget = false;
		
        __outputChanged = false;
		__outputGain    = 0.0;
		__outputPitch   = 1.0;
        
	    __instance = undefined;
	}
	
	
	
	#region Gain
	
	static __InputGainSet = function(_gain)
	{
		if (__inputGain != _gain)
		{
			__outputChanged = true;
			
			__outputGain += _gain - __inputGain;
			__inputGain = _gain;
		}
	}
	
	static __InputGainTargetSet = function(_targetGain, _rate, _stopAtSilence)
	{
		__gainTarget    = _targetGain;
		__gainRate      = _rate;
		__stopOnSilence = _stopAtSilence;
	}
	
	static __InputGainGet = function()
	{
		return __inputGain;
	}
	
	static __GainTargetGet = function()
	{
		return __gainTarget;
	}
	
	static __OutputGainGet = function()
	{
		return __outputGain;
	}
	
	#endregion
	
	
	
	#region Pitch
	
	static __InputPitchSet = function(_pitch)
	{
		if (__inputPitch != _pitch)
		{
			__outputChanged = true;
			
			__outputPitch *= _pitch / __inputPitch;
			__inputPitch = _pitch;
		}
	}
	
	static __InputPitchTargetSet = function(_targetPitch, _rate, _stopOnTarget)
	{
		__pitchTarget  = _targetPitch;
		__pitchRate    = _rate;
		__stopOnTarget = _stopOnTarget;
	}
	
	static __InputPitchGet = function()
	{
		return __inputPitch;
	}
	
	static __PitchTargetGet = function()
	{
		return __pitchTarget;
	}
	
	static __OutputPitchGet = function()
	{
		return __outputPitch;
	}
	
	#endregion
	
	
    
    static __Play = function(_sound, _loop, _gain, _pitch)
    {
	    __sound      = _sound;
	    __loop       = _loop;
	    __inputGain  = _gain;
	    __inputPitch = _pitch;
		
		__gainTarget    = __inputGain;
		__gainRate      = VINYL_DEFAULT_GAIN_RATE;
		__stopOnSilence = true;
		
		__pitchTarget  = __inputPitch;
		__pitchRate    = VINYL_DEFAULT_PITCH_RATE;
		__stopOnTarget = false;
		
        __AddToLabels();
        __RecalculateOutputValues();
		
	    __instance = audio_play_sound(__sound, 1, __loop, __VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), 0, __outputPitch);
		
		if (VINYL_DEBUG)
		{
			__VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch=", 100*__outputPitch, "%, label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", 100*__VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), "%)");
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
        var _prevGain  = __outputGain;
        var _prevPitch = __outputPitch;
        
		__outputGain  = __inputGain;
		__outputPitch = __inputPitch;
        
        var _asset = global.__vinylAssetDict[$ __sound] ?? global.__vinylAssetDict.fallback;
        if (is_struct(_asset))
        {
            __outputGain  += _asset.__gain;
            __outputPitch *= _asset.__pitch;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                __outputGain  += _label.__outputGain;
                __outputPitch *= _label.__outputPitch;
                ++_i;
            }
        }
        
        if (!__outputChanged && ((__outputGain != _prevGain) || (__outputPitch != _prevPitch)))
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
        else
		{
			var _gainDelta = clamp(__gainTarget - __inputGain, -__gainRate, __gainRate);
			if (_gainDelta != 0)
			{
				__inputGain  += _gainDelta;
				__outputGain += _gainDelta;
				__outputChanged = true;
				
				if (__stopOnSilence && (_gainDelta < 0) && (__outputGain <= VINYL_SILENCE))
				{
					__Stop();
					return;
				}
			}
			
			var _pitchDelta = clamp(__pitchTarget - __inputPitch, -__pitchRate, __pitchRate);
			if (_pitchDelta != 0)
			{
				__inputPitch  += _pitchDelta;
				__outputPitch += _pitchDelta;
				__outputChanged = true;
				
				if (__stopOnTarget && (__inputPitch == __pitchTarget))
				{
					__Stop();
					return;
				}
			}
			
			if (__outputChanged)
	        {
				__outputChanged = false;
				
				if (VINYL_DEBUG)
				{
					__VinylTrace("Updated instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch=", 100*__outputPitch, "%, label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", 100*__VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), "%)");
				}
				
	            audio_sound_gain(__instance, __VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), VINYL_STEP_DURATION);
	            audio_sound_pitch(__instance, __outputPitch);
	        }
		}
    }
	
	static __DebugLabelNames = function()
	{
		if (!VINYL_DEBUG) return "";
		
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
		
		return _labelReadable;
	}
}