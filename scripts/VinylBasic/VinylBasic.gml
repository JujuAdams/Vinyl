/// @param source

function VinylBasic(_asset)
{
    return new __VinylPatternBasic(_asset);
}

/// @param asset
function __VinylPatternBasic(_asset) constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceBasic);
    
    if (!is_numeric(_asset) || !audio_exists(_asset))
    {
        __VinylError("Asset \"", _asset, "\" is invalid");
    }
    
    __asset     = _asset;
    __startTime = 0;
    __endTime   = audio_sound_length(__asset);
    __duration  = __endTime - __startTime;
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    static GroupAdd      = __VinylPatternGroupAdd;
    static GroupDelete   = __VinylPatternGroupDelete;
    static GroupClear    = __VinylPatternGroupClear;
    static GroupAssigned = __VinylPatternGroupAssigned;
    
    #endregion
    
    
    
    #region Public Methods
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    static SectionSet = function(_startTime, _endTime)
    {
        __startTime = _startTime;
        __endTime   = _endTime;
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
    
    static toString = function()
    {
        return audio_get_name(__asset);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern for ", self);
}

/// @param asset
function __VinyInstanceBasic(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __asset      = __pattern.__asset;
    __GMInstance = undefined;
    __startTime  = __pattern.__startTime;
    __endTime    = __pattern.__endTime;
    __duration   = __endTime - __startTime;
    
    
    
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
        __endTime   = _endTime;
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
    
    
    
    #region Common Public Methods
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static OutputGainGet  = __VinylInstanceOutputGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static OutputPitchGet = __VinylInstanceOutputPitchGet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    static GroupAdd      = __VinylInstanceGroupAdd;
    static GroupDelete   = __VinylInstanceGroupDelete;
    static GroupClear    = __VinylInstanceGroupClear;
    static GroupAssigned = __VinylInstanceGroupAssigned;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __GMInstance = undefined;
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Play the audio asset
        __GMInstance = audio_play_sound(__asset, 1, false);
        audio_sound_set_track_position(__GMInstance, __startTime);
        audio_sound_gain(__GMInstance, __outputGain, 0.0);
        audio_sound_pitch(__GMInstance, __outputPitch);
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
                var _asset_gain = global.__vinylGlobalAssetGain[? __asset];
                if (_asset_gain == undefined) _asset_gain = 1.0;
                
                //Update GM's sound instance
                audio_sound_gain(__GMInstance, __outputGain*_asset_gain, VINYL_STEP_DURATION);
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
        return audio_get_name(__asset);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
}