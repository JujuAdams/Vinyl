function __VinylClassInstance() constructor
{
	__inPool = true;
	__id     = undefined;
	
    __sound           = undefined;
    __loops           = undefined;
    __inputGain       = 0.0;
    __inputFreqCoeff  = 1.0;
	
    __instance        = undefined;
	__outputAmplitude = 1.0;
	__outputFreqCoeff = 1.0;
    
    static __Play = function(_sound, _loops, _gain, _freqCoeff)
    {
	    __sound          = _sound;
	    __loops          = _loops;
	    __inputGain      = _gain;
	    __inputFreqCoeff = _freqCoeff;
		
        var _data = global.__vinylData[$ "assets"];
        if (is_struct(_data)) _data = _data[$ audio_get_name(_sound)] ?? _data[$ "default"];
        
        if (is_struct(_data))
        {
            _gain      += _data[$ "gain" ] ?? 0;
            _freqCoeff *= _data[$ "pitch"] ?? 1;
        }
		
		__outputAmplitude = __VinylGainToAmplitudeCoeff(_gain - VINYL_GAIN_MAXIMUM);
		__outputFreqCoeff = __inputFreqCoeff;
		
	    __instance = audio_play_sound(__sound, 1, __loops, __outputAmplitude, 0, __outputFreqCoeff);
    }
    
    static __Stop = function()
    {
		if (__instance == undefined) return;
		
        audio_stop_sound(__instance);
		__instance = undefined;
		
		__ReturnToPool();
    }
    
    static __ReturnToPool = function()
    {
		if (!__inPool)
		{
			__inPool = true;
			
			Stop();
			
			var _i = 0;
			repeat(array_length(global.__vinylPlaying))
			{
				if (global.__vinylPlaying[_i] == self)
				{
					array_delete(global.__vinylPlaying, _i, 1);
				}
				else
				{
					++_i;
				}
			}
			
			array_push(global.__vinylPool, self);
			
			ds_map_delete(global.__vinylInstances, __id);
		}
    }
}