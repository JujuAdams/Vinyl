function __VinyInstanceBasic(_pattern) constructor
{
    __VINYL_INSTANCE_COMMON
    
    __asset      = __pattern.__asset;
    __GMInstance = undefined;
    __startTime  = __pattern.__startTime;
    __endTime    = __pattern.__endTime;
    __duration   = __endTime - __startTime;
    __assetGain  = global.__vinylAssetGainDict[$ string(__asset)] ?? 0;
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_numeric(__GMInstance) || !audio_is_playing(__GMInstance)) return undefined;
        return audio_sound_get_track_position(__GMInstance) - __startTime;
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__GMInstance) && audio_is_playing(__GMInstance))
        {
            audio_sound_set_track_position(__GMInstance, _time + __startTime);
        }
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static Kill = function()
    {
        if (__started && !__finished && VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        if (!__finished)
        {
            if (is_numeric(__GMInstance) && audio_is_playing(__GMInstance)) audio_stop_sound(__GMInstance);
            
            __stopping   = false;
            __finished   = true;
            __GMInstance = undefined;
        }
    }
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    static GMInstanceGet = function()
    {
        return __GMInstance;
    }
    
    static SectionSet = function(_startTime, _endTime)
    {
        __startTime = _startTime;
        __endTime   = (_endTime == undefined)? audio_sound_length(__asset) : _endTime;
        __duration  = __endTime - __startTime;
        
        return self;
    }
    
    static SectionGet = function()
    {
        return {
            startTime : __startTime,
            endTime   : __endTime,
            duration  : __duration,
        };
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        if (__GMInstance != undefined) audio_stop_sound(__GMInstance);
        __GMInstance = undefined;
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Play the audio asset
        __GMInstance = audio_play_sound(__asset, 1, false);
        audio_sound_set_track_position(__GMInstance, __startTime);
        audio_sound_gain(__GMInstance, __VinylGainToAmplitudeCoeff(__outputGain - VINYL_GAIN_MAXIMUM), 0.0);
        audio_sound_pitch(__GMInstance, __outputPitch);
    }
    
    static __ReplayViaLoop = function()
    {
        if (__GMInstance == undefined)
        {
            __Play();
        }
        else
        {
            var _newPosition = audio_sound_get_track_position(__GMInstance) - __duration;
            if (VINYL_DEBUG) __VinylTrace("Replaying ", self, " (new pos = ", _newPosition, ")");
            audio_sound_set_track_position(__GMInstance, _newPosition);
        }
    }
    
    static __Tick = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            __Play();
        }
        else
        {
            __VinylInstanceCommonTick();
            
            //Handle fade out
            if (__stopping && (current_time - __timeStopping > __timeFadeOut)) Kill();
            
            if (is_numeric(__GMInstance) && audio_is_playing(__GMInstance))
            {
                //Update GM's sound instance
                audio_sound_gain(__GMInstance, __VinylGainToAmplitudeCoeff(__outputGain + __assetGain - VINYL_GAIN_MAXIMUM), VINYL_STEP_DURATION);
                audio_sound_pitch(__GMInstance, __outputPitch);
            }
            
            if (__WillFinish()) Kill();
        }
    }
    
    static __WillFinish = function()
    {
        if (!__started || __finished || !is_numeric(__GMInstance) || !audio_is_playing(__GMInstance)) return true;
        return (((__endTime - audio_sound_get_track_position(__GMInstance)) / __outputPitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    static toString = function()
    {
        return audio_get_name(__asset) + " [" + string(__startTime) + "->" + string(__endTime) + "]";
    }
    
    #endregion
}