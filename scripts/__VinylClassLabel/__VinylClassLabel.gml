/// @param name
/// @param parent
/// @param [gain=0]
/// @param [freq=1]

function __VinylClassLabel(_name, _parent, _gain = 0, _freq = 1) constructor
{
    __name      = _name;
    __parent    = _parent;
    __inputGain = _gain;
    __inputFreq = _freq;
    
    __audioArray = [];
    
    __outputGain = 0;
    __outputFreq = 1;
	
	
	
	static __GainSet = function(_gain)
	{
		
	}
	
	static __GainGet = function()
	{
		
	}
	
	static __GainTargetSet = function(_targetGain, _rate, _stopAtSilence)
	{
		
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
        __outputFreq = _oldLabel.__outputFreq;
    }
    
    static __Tick = function()
    {
        var _gainDelta = __outputGain;
        var _freqDelta = __outputFreq;
        
        __outputGain = __inputGain;
        __outputFreq = __inputFreq;
        
        if (is_struct(__parent))
        {
            __outputGain += __parent.__outputGain;
            __outputFreq *= __parent.__outputFreq;
        }
        
        _gainDelta = __outputGain - _gainDelta;
        _freqDelta = __outputFreq / _freqDelta;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 0) || (_freqDelta != 1))
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
                    _instance.__outputGain += _gainDelta;
                    _instance.__outputFreq *= _freqDelta;
                    ++_i;
                }
            }
        }
    }
}