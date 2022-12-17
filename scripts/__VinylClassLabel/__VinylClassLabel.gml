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
    __inputGain  = _gain;
    __inputPitch = _pitch;
    
    __audioArray = [];
    
    __outputGain = 0;
    __outputPitch = 1;
	
	
	
	static __InputGainSet = function(_gain)
	{
		__inputGain = _gain;
	}
	
	static __InputGainTargetSet = function(_targetGain, _rate, _stopAtSilence)
	{
		
	}
	
	static __InputGainGet = function()
	{
		return __inputGain;
	}
	
	static __OutputGainGet = function()
	{
		return __outputGain;
	}
	
	
	
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
        array_resize(__audioArray, array_length(_oldLabel.__audioArray));
        array_copy(__audioArray, 0, _oldLabel.__audioArray, 0, array_length(_oldLabel.__audioArray));
        __outputGain = _oldLabel.__outputGain;
        __outputPitch = _oldLabel.__outputPitch;
    }
    
    static __Tick = function()
    {
        var _gainDelta = __outputGain;
        var _pitchDelta = __outputPitch;
        
        __outputGain = __inputGain;
        __outputPitch = __inputPitch;
        
        if (is_struct(__parent))
        {
            __outputGain += __parent.__outputGain;
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