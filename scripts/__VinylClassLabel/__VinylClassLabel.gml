/// @param name
/// @param parent
/// @param dynamic
/// @param [gain=0]
/// @param [pitch=1]

function __VinylClassLabel(_name, _parent, _dynamic, _gain = 0, _pitch = 1) constructor
{
    __name       = _name;
    __parent     = _parent;
	__dynamic    = _dynamic;
    __assetGain  = _gain;
    __assetPitch = _pitch;
    
    __audioArray = [];
	
    __inputGain  = 0;
    __inputPitch = 1;
	
	__gainTarget    = 0.0;
	__gainRate      = VINYL_DEFAULT_GAIN_RATE;
	__stopOnSilence = true;
	
	__pitchTarget  = 1.0;
	__pitchRate    = VINYL_DEFAULT_PITCH_RATE;
	__stopOnTarget = false;
    
    __outputGain  = 0;
    __outputPitch = 1;
	
	
	
	static __Stop = function()
	{
		if (VINYL_DEBUG) __VinylTrace("Stopping ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
		
        var _i = 0;
        repeat(array_length(__audioArray))
        {
			VinylStop(__audioArray[_i]);
			++_i;
        }
		
		array_resize(__audioArray, 0);
	}
    
    static __HasAncestor = function(_label)
    {
        if (__parent == _label) return true;
        if (is_struct(__parent)) return __parent.__HasAncestor(_label);
        return false;
    }
    
    static __CopyOldState = function(_oldLabel)
    {
        __inputGain  = _oldLabel.__inputGain;
        __inputPitch = _oldLabel.__inputPitch;
		
		if (VINYL_DEBUG)
		{
			__VinylTrace("Copying state to label \"", __name, "\": gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch in=", 100*__inputPitch, "%/out=", 100*__outputPitch, "%");
		}
		
    }
    
	
	
	#region Gain
	
	static __InputGainSet = function(_gain)
	{
		__inputGain = _gain;
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
		__inputPitch = _pitch;
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
	
	
    
    static __Tick = function()
    {
		//Update input values based on gain/pitch target
		var _delta = clamp(__gainTarget - __inputGain, -__gainRate, __gainRate);
		if (_delta != 0)
		{
			__inputGain += _delta;
			if (__stopOnSilence && (_delta < 0) && (__outputGain <= VINYL_SILENCE)) __Stop();
		}
		
		var _delta = clamp(__pitchTarget - __inputPitch, -__pitchRate, __pitchRate);
		if (_delta != 0)
		{
			__inputPitch += _delta;
			if (__stopOnTarget && (__inputPitch == __pitchTarget)) __Stop();
		}
		
		//Update the output gain
        var _gainDelta  = __outputGain;
        var _pitchDelta = __outputPitch;
        
        __outputGain  = __inputGain  + __assetGain;
        __outputPitch = __inputPitch * __assetPitch;
        
        if (is_struct(__parent))
        {
            __outputGain  += __parent.__outputGain;
            __outputPitch *= __parent.__outputPitch;
        }
        
        _gainDelta  = __outputGain  - _gainDelta;
        _pitchDelta = __outputPitch / _pitchDelta;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 0) || (_pitchDelta != 1))
        {
            var _i = 0;
            repeat(array_length(__audioArray))
            {
                var _instance = global.__vinylIdToInstanceDict[? __audioArray[_i]];
                if (!is_struct(_instance))
                {
                    array_delete(__audioArray, _i, 1);
                }
                else
                {
					_instance.__outputChanged = true;
					
                    _instance.__outputGain  += _gainDelta;
                    _instance.__outputPitch *= _pitchDelta;
					
                    ++_i;
                }
            }
        }
    }
}